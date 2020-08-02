# This program will generate a .txt file with a list of dates
#
#       WORDLIST WITH R
#
################################################

dates = c(10,20,30,40,50,60)

write.table(dates, file = "wordlist.txt", sep="\n", row.names=F, col.names=F)
