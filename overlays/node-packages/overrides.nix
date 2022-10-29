self: super: {
  volar = self."@volar/vue-language-server".override {
    name = "volar";
  };
  tailwindcss-language-server = self."@tailwindcss/language-server".override
    { name = "tailwindcss-language-server"; };
}
