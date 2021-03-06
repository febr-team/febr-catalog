# Este arquivo é usado apenas para testes. O arquivo usado para compilação das páginas é 'template.Rmarkdown'.
# O conteúdo dos dos arquivos é idêntico, exceto pelo índice 'i', que no arquivo 'template.Rmarkdown' precisa 
# ser no formato '**i**'.
i <- 1 # Apenas para teste!
###############################################################################################################
glue('# {id[i]} {{-}}') %>% cat()

glue("<h2 style='font-style:italic;'>{dts[[i]][2, 2] %>% as.character()}</h2>") %>% cat()

glue("{dts[[i]][3, 2] %>% as.character()}") %>% cat()

link <- glue('https://drive.google.com/drive/folders/{sheets_keys$compartilha[i]}')
glue('<form action="{link}" target="_blank"><input type="submit" value="Acessar dados"/></form>') %>%
  cat()

glue('## Autoria {{-}}') %>% cat()
idx <- match(c("autor_nome", "autor_email", "organizacao_nome", "organizacao_url"), dts[[i]][["item"]])
dts[[i]][idx, ] %>% 
  pander::pandoc.table(
    split.tables = Inf, justify = 'left', col.names = c('campo', 'valor'), row.names = FALSE)

glue('## Informações gerais {{-}}') %>% cat()
idx <- match(
  c("autor_nome", "autor_email", "organizacao_nome", "organizacao_url", "organizacao_pais_id", 
    "organizacao_municipio_id", "organizacao_codigo_postal", "organizacao_rua_nome", "organizacao_rua_numero",
    # "contribuidor_nome", "contribuidor_email", "contribuidor_organizacao", 
    "categoria_vcge", "dataset_id", "dataset_titulo", "dataset_descricao"), 
  dts[[i]][["item"]])
dts[[i]][-idx, ] %>%
  pander::pandoc.table(
    split.tables = Inf, justify = 'left', col.names = c('campo', 'valor'), row.names = FALSE)

# Localização
glue('## Localização {{-}}') %>% print()
municipio_id <- obs[[i]][, "municipio_id"] %>% unique() %>% paste(collapse = "; ")
uf_id <- obs[[i]][, "estado_id"] %>% unique() # Substituir a sigla dos estados pelo seu nome
uf_id <- match(uf_id, uf$estado_id)
uf_nome <- uf$estado_nome[uf_id] %>% paste(collapse = "; ")
data.frame(campo = c("municipio_id", "estado_id"), valor = c(municipio_id, uf_nome)) %>% 
  pander::pandoc.table(split.tables = Inf, justify = 'left', row.names = FALSE)

n_obs <- nrow(obs[[i]])
n_coords <- sum(!is.na(obs[[i]]$coord_x))
if (n_coords != 0) {
  tmp <- obs[[i]]
  tmp <- tmp[!is.na(tmp$coord_x), ]
  sp::coordinates(tmp) <- ~ coord_x + coord_y
  sp::proj4string(tmp) <- sp::CRS("+init=epsg:4674")
  m <- 
    mapview::mapview(
      tmp[, c("observacao_id", "observacao_data")], label = tmp$observacao_id, col.regions = "firebrick1", 
      lwd = 1, col = "ivory", layer.name = id[i])@map %>% 
    leaflet::addMiniMap()
  n_obs_text <- ifelse(n_obs == 1, "observação", "observações")
  glue("O conjunto de dados `{id[**i**]}` possui {n_obs} {n_obs_text}.") %>% 
    cat()
  if (n_coords != n_obs) {
    out <- n_obs - n_coords
    if (out == 1) {
      glue(" Destas, {out} observação não possui coordenadas espaciais.") %>% 
        cat()
    } else {
      glue(" Destas, {out} observações não possuem coordenadas espaciais.") %>% 
        cat()
    }
  }
} else {
  m <- glue("As observações do conjunto de dados `{id[i]}` não possuem coordenadas espaciais.") %>% cat()
}
m

glue('### Sugestões, Dúvidas e Reclamações {{-}}') %>% cat()
glue('Por favor, sinta-se à vontade para entrar em contato conosco via febr-forum@googlegroups.com. Nós faremos o possível para responder à sua mensagem em até 24 horas.') %>% cat()
