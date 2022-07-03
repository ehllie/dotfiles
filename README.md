# My Dotfiles
Not the most sophisticated stuff, but it's mine.
Using a bare git directory to manage the configuration.
Idea for that stolen from this post https://news.ycombinator.com/item?id=11071754

### To sync with the repository config run:
```bash
curl "https://raw.githubusercontent.com/ehllie/my-dotfiles/main/bootstrap.sh" | bash
```
#### WARNING
This will clone this repo and forcefully sync the contents, so could be destructive to existing configurations.
Only here for my own convinience when setting up a new system.
Again, for my own convinience of not having to look this up later:
```bash
config remote set-url origin git@github.com:ehllie/my-dotfiles.git
```
