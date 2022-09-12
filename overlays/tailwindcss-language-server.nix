self: super: {
  nodePackages = with super; nodePackages //
    {
      tailwindcss-language-server = nodePackages."@tailwindcss/language-server".override
        { name = "tailwindcss-language-server"; };
    };
}
