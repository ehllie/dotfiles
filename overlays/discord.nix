self: super: {
  discord = super.discord.override {
    withOpenASAR = true;
    nss = super.nss_latest;
  };
}
