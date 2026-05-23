# Preparação dos dados de hipertensão - VIGITEL 2006-2024
# Projeto: cdepi2

.libPaths(c("R/library", .libPaths()))

# Pacotes -----------------------------------------------------------------

pacotes <- c("readr", "dplyr", "stringr")

pacotes_instalar <- pacotes[!pacotes %in% rownames(installed.packages())]

if (length(pacotes_instalar) > 0) {
  install.packages(pacotes_instalar, repos = "https://cloud.r-project.org")
}

library(readr)
library(dplyr)
library(stringr)

# Caminhos ----------------------------------------------------------------

arquivo_dados <- "dados/vigitel-2006-2024-peso-rake.csv"

if (!file.exists(arquivo_dados)) {
  stop("Arquivo não encontrado em dados/. Verifique se o CSV está na pasta dados/")
}

# Leitura dos dados --------------------------------------------------------

vigitel <- read_csv(
  arquivo_dados,
  col_select = c(ano, q7, hart, pesorake2025),
  show_col_types = FALSE,
  locale = locale(encoding = "UTF-8"),
  progress = TRUE
)

# Checagens básicas --------------------------------------------------------

variaveis_necessarias <- c("ano", "q7", "hart", "pesorake2025")

variaveis_ausentes <- setdiff(variaveis_necessarias, names(vigitel))

if (length(variaveis_ausentes) > 0) {
  stop(
    "As seguintes variáveis não foram encontradas no arquivo: ",
    paste(variaveis_ausentes, collapse = ", ")
  )
}

# Preparação da base -------------------------------------------------------

dados_hipertensao <- vigitel |>
  transmute(
    ano = as.integer(ano),
    sexo = case_when(
      q7 == "masculino" ~ "Homens",
      q7 == "feminino" ~ "Mulheres",
      TRUE ~ NA_character_
    ),
    hipertensao = case_when(
      hart == "Sim" ~ 1,
      hart == "Nao" ~ 0,
      TRUE ~ NA_real_
    ),
    peso = as.numeric(pesorake2025)
  ) |>
  filter(
    !is.na(ano),
    !is.na(hipertensao)
  )

# Tabela 1: total de relatos de hipertensão por ano ------------------------

hipertensao_ano <- dados_hipertensao |>
  group_by(ano) |>
  summarise(
    entrevistas = n(),
    relatos_hipertensao = sum(hipertensao == 1, na.rm = TRUE),
    relatos_ponderados = sum(peso * hipertensao, na.rm = TRUE),
    proporcao_hipertensao = mean(hipertensao, na.rm = TRUE),
    proporcao_ponderada = sum(peso * hipertensao, na.rm = TRUE) / sum(peso, na.rm = TRUE),
    .groups = "drop"
  )

# Tabela 2: hipertensão por ano e sexo -------------------------------------

hipertensao_ano_sexo <- dados_hipertensao |>
  filter(!is.na(sexo)) |>
  group_by(ano, sexo) |>
  summarise(
    entrevistas = n(),
    relatos_hipertensao = sum(hipertensao == 1, na.rm = TRUE),
    relatos_ponderados = sum(peso * hipertensao, na.rm = TRUE),
    proporcao_hipertensao = mean(hipertensao, na.rm = TRUE),
    proporcao_ponderada = sum(peso * hipertensao, na.rm = TRUE) / sum(peso, na.rm = TRUE),
    .groups = "drop"
  )

# Salvar resultados --------------------------------------------------------

if (!dir.exists("resultados")) {
  dir.create("resultados")
}

write_csv(hipertensao_ano, "resultados/hipertensao_ano.csv")
write_csv(hipertensao_ano_sexo, "resultados/hipertensao_ano_sexo.csv")

message("Dados preparados com sucesso.")
message("Arquivos salvos em resultados/")
