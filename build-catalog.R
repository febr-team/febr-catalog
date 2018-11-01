# Build book
rmarkdown::render_site(encoding = 'UTF-8')

# AFTER BUILDING THE BOOK, EDIT FILE '/catalog/libs/gitbook-2.6.7/js/plugin-search.js'
js <- list.files(path = ".", recursive = TRUE)
idx <- grepl(pattern = "/js/plugin-search.js", x = js)
file <- js[idx]
js <- readLines(con = file)
for (i in seq(length(js))) {
  js[i] <- 
    gsub(
      pattern = "'placeholder': 'Type to search'", 
      replacement = "'placeholder': 'Escreva para pesquisar'", x = js[i], fixed = TRUE)
}
writeLines(text = js, con = file)

# Compress files
if(Sys.info()[1] == "Linux") {
  system("cd catalog && zip -r ../upload.zip *")
} else if (Sys.info()[1] == "Windows") {
  system("cd catalog && ") # Matheus, descobrir e inserir comando do Windows para zipar!
}

# Open server portal
browseURL("http://www.suporte.cpd.ufsm.br/newftp/")
