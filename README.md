# :page_with_curl: Dates Wordlist (R)

Gera uma wordlist com todas as datas de um intervalo, em um ou mais formatos.
Útil em auditoria de senhas, já que muita gente usa datas (aniversários,
datas comemorativas) como senha.

Projeto feito originalmente para aprender a sintaxe de R; depois reescrito
como um script de linha de comando usando apenas o R base — **nenhum pacote
precisa ser instalado**.

## :rocket: Uso

```sh
# Intervalo e formato na linha de comando
Rscript wordlist.R --start 01/01/1990 --end 31/12/2005

# Vários formatos de uma vez, salvando em um arquivo
Rscript wordlist.R -s 01/01/2000 -e 31/12/2000 -f ddmmyyyy,ddmmyy,yyyymmdd -o datas.txt

# Todos os formatos
Rscript wordlist.R -s 01/01/2000 -e 31/12/2000 -f all

# Modo interativo (pergunta as datas)
Rscript wordlist.R
```

### Opções

| Opção | Descrição |
| --- | --- |
| `-s`, `--start` | Data inicial (`dd/mm/aaaa`, `dd-mm-aaaa` ou `aaaa-mm-dd`) |
| `-e`, `--end` | Data final |
| `-f`, `--formats` | Formatos separados por vírgula, ou `all` (padrão: `ddmmyyyy`) |
| `-o`, `--output` | Arquivo de saída (padrão: `wordlist.txt`; use `-` para imprimir na tela) |
| `-l`, `--list-formats` | Lista os formatos disponíveis |
| `-h`, `--help` | Ajuda |

## :page_facing_up: Formatos

`ddmmyyyy`, `ddmmyy`, `mmddyyyy`, `mmddyy`, `yyyymmdd`, `yymmdd`, `ddmm`,
`mmyyyy`, `dd/mm/yyyy`, `dd-mm-yyyy`, `dd.mm.yyyy`, `yyyy-mm-dd`.

Rode `Rscript wordlist.R --list-formats` para ver um exemplo de cada.

## :mag: Detalhes

- Trata anos bissextos corretamente (29/02 só aparece quando existe).
- Remove duplicatas (formatos curtos como `ddmm` geram repetições no intervalo).
- Valida as datas de entrada e tem um limite de segurança (~200 anos).

## :warning: Aviso

Ferramenta para uso legítimo: testar a robustez das suas próprias senhas ou
em testes de segurança autorizados.
