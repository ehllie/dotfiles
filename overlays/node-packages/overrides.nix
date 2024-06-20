self: super: {
  # tailwindcss-language-server = self."@tailwindcss/language-server".override {
  #   name = "tailwindcss-language-server";
  # };

  prisma-language-server = self."@prisma/language-server".override {
    name = "prisma-language-server";
  };
}
