i <- 4
glue('# {id[i]} {{-}}') %>% cat()

glue("<h2 style='font-style:italic;'>{dts[[i]][2, 2] %>% as.character()}</h2>") %>% cat()

glue("{dts[[i]][3, 2] %>% as.character()}") %>% cat()

link <- glue('https://drive.google.com/drive/folders/{sheets_keys$compartilha[i]}')
glue('<form action="{link}" target="_blank"><input type="submit" value="Acessar dados"/></form>') %>%
  cat()

glue('## Autoria {{-}}') %>% cat()
idx <- match(c("autor_nome", "autor_email", "organizacao_nome", "organizacao_url"), dts[[i]][["item"]])
dts[[i]][idx, ] %>% 
  pandoc.table(split.tables = Inf, justify = 'left', col.names = c('campo', 'valor'), row.names = FALSE)

glue('## Informações gerais {{-}}') %>% cat()
idx <- match(
  c("autor_nome", "autor_email", "organizacao_nome", "organizacao_url", "organizacao_pais_id", 
    "organizacao_municipio_id", "organizacao_codigo_postal", "organizacao_rua_nome", "organizacao_rua_numero",
    # "contribuidor_nome", "contribuidor_email", "contribuidor_organizacao", 
    "categoria_vcge", "dataset_id", "dataset_titulo", "dataset_descricao"), 
  dts[[i]][["item"]])
dts[[i]][-idx, ] %>%
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

glue('### Sugestões, Dúvidas e Reclamações {{-}}') %>% cat()
glue('Por favor, sinta-se à vontade para entrar em contato conosco via febr-forum@googlegroups.com. Nós faremos o possível para responder à sua mensagem em até 24 horas.') %>% cat()
