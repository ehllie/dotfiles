#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.pydantic python3Packages.typer python3Packages.rich

import os
import subprocess
from pathlib import Path
from webbrowser import open as webopen

import typer
from pydantic import BaseModel, TypeAdapter
from rich.progress import BarColumn, Progress, SpinnerColumn, TextColumn
from typing_extensions import Annotated


class KnownBuild(BaseModel):
    major: str
    sha256: str


class UnknownBuild(BaseModel):
    major: str


BuildInfos = TypeAdapter(dict[str, KnownBuild | UnknownBuild])


def prefetch_build(
    build: str,
    major: str,
    auto_open: bool,
    download_dir: Path,
    cleanup: bool,
    progress: Progress,
) -> KnownBuild:
    url = f"https://foundryvtt.com/releases/download?build={build}&platform=node"
    version = f"{major}.{build}"
    filename = f"FoundryVTT-{version}.zip"
    filepath = download_dir / filename

    current_task = progress.add_task(f"Waiting for file {filepath}", total=2)

    if not filepath.exists():
        if auto_open:
            print(f"Downloading FoundryVTT {version} from {url}")
            webopen(url)
        else:
            print(f"Please download FoundryVTT {version} from {url}")

    while not filepath.exists():
        ...
    progress.update(current_task, advance=1, description=f"Unpacking {filepath}")
    proc = subprocess.run(
        [
            "nix-prefetch-url",
            "--type",
            "sha256",
            f"file://{filepath}",
        ],
        check=True,
        capture_output=True,
    )

    stdout = proc.stdout.decode()
    sha256 = stdout.strip().splitlines()[-1]
    progress.update(current_task, advance=1, visible=False)
    if cleanup:
        os.remove(filepath)
    return KnownBuild(major=major, sha256=sha256)


def main(
    auto_open: Annotated[
        bool,
        typer.Option(
            "--auto",
            "-a",
            help="Automatically open the download links with the default browser",
        ),
    ] = False,
    download_dir: Annotated[
        Path,
        typer.Option(
            "--download_dir", "-d", help="Location where to look for downloaded builds"
        ),
    ] = Path.home()
    / "Downloads",
    cleanup: Annotated[
        bool,
        typer.Option(
            "--cleanup",
            "-c",
            help="Remove the downloaded files after calculating the sha256",
        ),
    ] = False,
    build: Annotated[
        str,
        typer.Argument(
            ..., help="Specific build number to fetch and update the sha256 of"
        ),
    ] = "",
    path: Annotated[
        Path,
        typer.Option(
            "--path", "-p", help="Path to the builds.json file", envvar="BUILDS"
        ),
    ] = Path(__file__)
    .resolve()
    .parent
    / "builds.json",
):
    """
    Prefetches FoundryVTT builds so that their sha256 can be known ahead of time.
    """
    with open(path, mode="r+") as f:
        builds = BuildInfos.validate_json(f.read())
        if build and build not in builds:
            major = input(
                f"Build {build} not found in the builds.json file. Please enter its major version to add it: "
            )
            builds[build] = UnknownBuild(major=major)

        unknown_builds = (
            {k: v for k, v in builds.items() if isinstance(v, UnknownBuild)}
            if not build
            else {build: builds[build]}
        )

        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
        ) as progress:
            fetch_task = progress.add_task(
                "Prefetching FoundryVTT builds", total=len(unknown_builds)
            )
            for build, info in unknown_builds.items():
                info = prefetch_build(
                    build=build,
                    major=info.major,
                    auto_open=auto_open,
                    download_dir=download_dir,
                    cleanup=cleanup,
                    progress=progress,
                )
                builds[build] = info
                progress.advance(fetch_task)

        new_data = BuildInfos.dump_json(builds, indent=2).decode()
        f.seek(0)
        f.write(new_data)
        f.truncate()
        print("Updated builds.json")


if __name__ == "__main__":
    typer.run(main)
