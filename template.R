i <- 4
glue('# {id[i]} {{-}}') %>% cat()

glue('## Descrição geral {{-}}') %>% cat()
dts[[i]][-1, ] %>%
  pandoc.table(split.tables = Inf, justify = 'left', col.names = c('campo', 'valor'), row.names = FALSE)

# Localização
glue('## Localização {{-}}') %>% print()
municipio_id <- obs[[i]][, "municipio_id"] %>% unique() %>% paste(collapse = "; ")
estado_id <- obs[[i]][, "estado_id"] %>% unique() %>% paste(collapse = "; ")
data.frame(campo = c("municipio_id", "estado_id"), valor = c(municipio_id, estado_id)) %>% 
  pandoc.table(split.tables = Inf, justify = 'left', row.names = FALSE)

n_obs <- nrow(obs[[i]])
n_coords <- sum(!is.na(obs[[i]]$coord_x))
if (n_coords != 0) {
  tmp <- obs[[i]]
  tmp <- tmp[!is.na(tmp$coord_x), ]
  coordinates(tmp) <- ~ coord_x + coord_y
  proj4string(tmp) <- CRS("+init=epsg:4674")
  m <- 
    mapview(
      tmp, label = tmp$observacao_id, col.regions = "firebrick1", lwd = 1, col = "ivory", 
      layer.name = id[i])@map %>% 
    addMiniMap()
  glue("O conjunto de dados `{id[**i**]}` possui {n_obs} observações.") %>% 
    cat()
  if (n_coords != n_obs) {
    out <- n_obs - n_coords
    glue(" Destas, {out} observações não possuem coordenadas espaciais.") %>% 
      cat()
  }
} else {
  m <- glue("As observações do conjunto de dados `{id[i]}` não possuem coordenadas espaciais.") %>% cat()
}
m
