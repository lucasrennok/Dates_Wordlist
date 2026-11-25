#!/usr/bin/env Rscript
# =============================================================================
#  Dates Wordlist: gera uma wordlist com todas as datas de um intervalo,
#  em um ou mais formatos (útil para auditoria de senhas baseadas em datas).
#
#  Uso:
#    Rscript wordlist.R --start 01/01/1990 --end 31/12/2005
#    Rscript wordlist.R -s 01/01/2000 -e 31/12/2000 -f ddmmyyyy,ddmmyy,yyyymmdd -o datas.txt
#    Rscript wordlist.R            (modo interativo: pergunta as datas)
#
#  Só usa R base: nenhum pacote precisa ser instalado.
# =============================================================================

FORMATS <- list(
  ddmmyyyy   = "%d%m%Y",   # 25122000
  ddmmyy     = "%d%m%y",   # 251200
  mmddyyyy   = "%m%d%Y",   # 12252000
  mmddyy     = "%m%d%y",   # 122500
  yyyymmdd   = "%Y%m%d",   # 20001225
  yymmdd     = "%y%m%d",   # 001225
  ddmm       = "%d%m",     # 2512
  mmyyyy     = "%m%Y",     # 122000
  "dd/mm/yyyy" = "%d/%m/%Y",
  "dd-mm-yyyy" = "%d-%m-%Y",
  "dd.mm.yyyy" = "%d.%m.%Y",
  "yyyy-mm-dd" = "%Y-%m-%d"
)

MAX_DAYS <- 200 * 366  # limite de segurança (~200 anos)

usage <- function() {
  cat(
    "Uso: Rscript wordlist.R [opções]\n\n",
    "  -s, --start DATA     data inicial (dd/mm/aaaa, dd-mm-aaaa ou aaaa-mm-dd)\n",
    "  -e, --end DATA       data final (mesmos formatos)\n",
    "  -f, --formats LISTA  formatos separados por vírgula (padrão: ddmmyyyy)\n",
    "                       ou 'all' para todos\n",
    "  -o, --output ARQ     arquivo de saída (padrão: wordlist.txt; '-' = tela)\n",
    "  -l, --list-formats   mostra os formatos disponíveis\n",
    "  -h, --help           mostra esta ajuda\n",
    sep = ""
  )
}

list_formats <- function() {
  example <- as.Date("2000-12-25")
  cat("Formatos disponíveis (exemplo para 25/12/2000):\n")
  for (name in names(FORMATS)) {
    cat(sprintf("  %-12s %s\n", name, format(example, FORMATS[[name]])))
  }
}

# Aceita dd/mm/aaaa, dd-mm-aaaa, dd.mm.aaaa, ddmmaaaa e aaaa-mm-dd
parse_date <- function(text) {
  text <- trimws(text)
  candidates <- c("%d/%m/%Y", "%d-%m-%Y", "%d.%m.%Y", "%Y-%m-%d", "%d%m%Y")
  for (fmt in candidates) {
    d <- as.Date(text, format = fmt)
    # as.Date aceita sobras ("01/01/20201"); conferimos ida e volta
    if (!is.na(d) && format(d, fmt) == text) return(d)
  }
  stop(sprintf("data inválida: '%s' (use dd/mm/aaaa)", text), call. = FALSE)
}

parse_args <- function(args) {
  opts <- list(start = NULL, end = NULL, formats = "ddmmyyyy", output = "wordlist.txt")
  i <- 1
  take <- function() {
    if (i + 1 > length(args)) stop(sprintf("faltou o valor de %s", args[i]), call. = FALSE)
    args[i + 1]
  }
  while (i <= length(args)) {
    a <- args[i]
    if (a %in% c("-h", "--help")) { usage(); quit(status = 0) }
    else if (a %in% c("-l", "--list-formats")) { list_formats(); quit(status = 0) }
    else if (a %in% c("-s", "--start")) { opts$start <- take(); i <- i + 1 }
    else if (a %in% c("-e", "--end")) { opts$end <- take(); i <- i + 1 }
    else if (a %in% c("-f", "--formats")) { opts$formats <- take(); i <- i + 1 }
    else if (a %in% c("-o", "--output")) { opts$output <- take(); i <- i + 1 }
    else stop(sprintf("opção desconhecida: %s (veja --help)", a), call. = FALSE)
    i <- i + 1
  }
  opts
}

ask <- function(prompt) {
  if (interactive()) return(readline(prompt))
  cat(prompt)
  readLines(con = "stdin", n = 1)
}

generate_wordlist <- function(start, end, format_names) {
  if (start > end) stop("a data inicial é depois da data final", call. = FALSE)
  n_days <- as.integer(end - start) + 1
  if (n_days > MAX_DAYS) stop("intervalo grande demais (máx. ~200 anos)", call. = FALSE)

  unknown <- setdiff(format_names, names(FORMATS))
  if (length(unknown) > 0) {
    stop(sprintf("formato desconhecido: %s (veja --list-formats)",
                 paste(unknown, collapse = ", ")), call. = FALSE)
  }

  days <- seq(start, end, by = "day")
  words <- unlist(lapply(format_names, function(name) format(days, FORMATS[[name]])))
  unique(words)  # formatos curtos (ddmm, ddmmyy...) geram repetições
}

main <- function() {
  opts <- tryCatch(parse_args(commandArgs(trailingOnly = TRUE)), error = function(e) {
    message("Erro: ", conditionMessage(e)); usage(); quit(status = 2)
  })

  if (is.null(opts$start)) opts$start <- ask("Data inicial (dd/mm/aaaa): ")
  if (is.null(opts$end)) opts$end <- ask("Data final   (dd/mm/aaaa): ")

  result <- tryCatch({
    format_names <- trimws(strsplit(opts$formats, ",")[[1]])
    if (identical(format_names, "all")) format_names <- names(FORMATS)
    generate_wordlist(parse_date(opts$start), parse_date(opts$end), format_names)
  }, error = function(e) {
    message("Erro: ", conditionMessage(e)); quit(status = 1)
  })

  if (opts$output == "-") {
    writeLines(result)
  } else {
    writeLines(result, opts$output, useBytes = TRUE)
    message(sprintf("%d entradas gravadas em %s", length(result), opts$output))
  }
}

if (sys.nframe() == 0L) main()
