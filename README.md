# cdepi2

Projeto de análise em R desenvolvido no GitHub Codespaces para a disciplina **Ciência de Dados Aplicada à Epidemiologia II**.

O projeto analisa relatos de hipertensão arterial na base VIGITEL 2006-2024, com preparação dos dados em R e geração de relatório em HTML com gráficos interativos.

## Estrutura do projeto

```text
cdepi2/
├── dados/        # Dados brutos
├── scripts/      # Scripts de preparação dos dados
├── resultados/   # Bases processadas geradas pela análise
├── docs/         # Relatório em R Markdown e HTML renderizado
├── R/library/    # Biblioteca local de pacotes R, ignorada pelo Git
├── cdepi2.Rproj  # Arquivo do projeto R
└── README.md     # Descrição do projeto
```

## Arquivos principais

- `dados/vigitel-2006-2024-peso-rake.csv`: base bruta do VIGITEL.
- `scripts/preparar_dados_hipertensao.R`: script que lê a base bruta e gera tabelas resumidas.
- `resultados/hipertensao_ano.csv`: total de relatos de hipertensão por ano.
- `resultados/hipertensao_ano_sexo.csv`: relatos de hipertensão por ano e sexo.
- `docs/relatorio.Rmd`: relatório reprodutível em R Markdown.
- `docs/relatorio.html`: relatório renderizado em HTML.

## Como executar

No terminal, dentro da pasta do projeto, rode:

```bash
Rscript scripts/preparar_dados_hipertensao.R
```

Depois, para gerar o relatório HTML:

```bash
R -e ".libPaths(c('R/library', .libPaths())); rmarkdown::render('docs/relatorio.Rmd')"
```
