return {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          "clsx[`]([\\s\\S][^`]*)[`]",
          { "clsx\\(([^]*)\\)", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)" },
        },
      },
    },
  },
}
