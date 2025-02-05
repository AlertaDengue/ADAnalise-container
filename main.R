pkgs <- c(
  "foreign",
  "tidyverse",
  "forecast",
  "RPostgreSQL",
  "xtable",
  "zoo",
  "assertthat",
  "DBI",
  "futile.logger",
  "lubridate",
  "grid",
  "INLA",
  "cgwtools",
  "fs",
  "miceadds",
  "AlertTools",
  "parallel",
  "argparse",
  "httr"
)

lapply(pkgs, library, character.only = TRUE, quietly = T)

ufs <- data.frame(
  estado = c(
    "Acre", "Amazonas", "Amapá", "Pará", "Rondônia", "Roraima", "Tocantins",
    "Alagoas", "Bahia", "Ceará", "Maranhão", "Piauí", "Pernambuco", "Paraíba",
    "Rio Grande do Norte", "Sergipe", "Goiás", "Mato Grosso",
    "Mato Grosso do Sul", "Distrito Federal", "Espírito Santo", "Minas Gerais",
    "Rio de Janeiro", "São Paulo", "Paraná", "Rio Grande do Sul",
    "Santa Catarina"
  ),
  sigla = c(
    "AC", "AM", "AP", "PA", "RO", "RR", "TO",
    "AL", "BA", "CE", "MA", "PI", "PE", "PB", "RN", "SE",
    "GO", "MT", "MS", "DF",
    "ES", "MG", "RJ", "SP",
    "PR", "RS", "SC"
  )
)

parser <- ArgumentParser()
parser$add_argument(
  "--uf",
  choices = ufs$sigla,
  help = "Choose the UFs. Default to all UFs. Example: `--uf SP RJ MG`",
  nargs = "+",
  required = FALSE
)
parser$add_argument(
  "--disease",
  choices = c("dengue", "chik", "zika"),
  help = "Specify the disease: dengue, chik, or zika",
  default = "dengue"
)
parser$add_argument(
  "--epiweek",
  type = "character",
  required = TRUE,
  help = "Epidemiological week. Format: YYYYWW"
)

uri <- parse_url(Sys.getenv("DB_URI"))

args <- parser$parse_args()

if (!is.null(args$uf)) {
  ufs <- ufs[ufs$sigla %in% args$uf, ]
}

disease <- args$disease
epiweek <- as.numeric(args$epiweek)
finalday <- seqSE(epiweek, epiweek)$Termino
output_dir <- "./output/"

if (!dir.exists(paste0(output_dir, "sql/"))) {
  dir.create(paste0(output_dir, "sql/"), recursive = TRUE)
}

if (!dir.exists(paste0(output_dir, epiweek))) {
  dir.create(paste0(output_dir, epiweek), recursive = TRUE)
}

# con <- dbConnect(
#   RPostgreSQL::PostgreSQL(),
#   dbname = sub("^/", "", uri$path),
#   host = uri$hostname,
#   port = uri$port,
#   user = uri$username,
#   password = uri$password
# )
#
# t1 <- Sys.time()
# for (i in seq_len(nrow(ufs))) {
#   print(i)
#   estado <- ufs$estado[i]
#
#   cid10 <- list(dengue = "A90", chik = "A92", zika = "A92.8")
#   filename <- paste0("ale-", ufs$sigla[i], "-", epiweek, ".RData")
#   cities <- getCidades(uf = estado)[, "municipio_geocodigo"]
#
#   res <- list()
#
#   res[[paste0("ale.", disease)]] <- pipe_infodengue(
#     cities,
#     cid10 = cid10[[disease]],
#     nowcasting = ifelse(disease == "dengue", "none", "bayesian"),
#     finalday = finalday,
#     narule = "arima",
#     iniSE = 201001,
#     dataini = "sinpri",
#     completetail = 0
#   )
#
#   res[[paste0("restab.", disease)]] <- tabela_historico(
#     res[[paste0("ale.", disease)]],
#     iniSE = epiweek - 100
#   )
#
#   save(res, file = paste0(output_dir, epiweek, "/", filename))
# }
# t2 <- Sys.time()
# message(paste("total time was", t2 - t1))
#
# dbDisconnect(con)

file_paths <- fs::dir_ls(paste0(output_dir, epiweek, "/"))

j <- 1
for (i in seq_along(file_paths)) {
  load.Rdata(file_paths[i], "res")
  assign(paste0("res", j), res)
  j <- j + 1
  load(file_paths[i])
}
rm(res)

output_path <- paste0(output_dir, "sql/output_", disease, ".sql")

lapply(seq_along(file_paths), function(j) {
  restab <- eval(parse(
    text = paste0("res", j, "[['restab.", disease, "']] %>% bind_rows()")
  ))
  data <- do.call(rbind, restab)
  print(data)
  data$casos_est_max[data$casos_est_max > 10000] <- NA
  summary(data)
  write_alerta(data, writetofile = TRUE, arq = output_path)
})

ale_data <- list()

for (i in seq_along(file_paths)) {
  data <- eval(parse(
    text = paste0(
      "transpose(res", i, "[['ale.", disease, "']])[[1]] %>% bind_rows()"
    )
  ))
  indices <- eval(parse(
    text = paste0(
      "transpose(res", i, "[['ale.", disease, "']])[[2]] %>% bind_rows()"
    )
  ))
  ale_data[[i]] <- cbind(data, indices)
}

res <- do.call(rbind, ale_data)

if (!dir.exists(paste0(output_dir, "BR"))) {
  dir.create(paste0(output_dir, "BR"))
}

save(res, file = paste0(output_dir, "BR/ale-BR-", epiweek, ".RData"))
