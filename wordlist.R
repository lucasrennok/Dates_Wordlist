# This program will generate a text file with a list of dates
#       Author: Lucas Rennó Kallás
#       -- WORDLIST WITH R --
#       The Wordlist Will be Formated with: DMY or MDY
#

# Install some packages to use the Lubridate Library
install.packages("tidyverse")
install.packages("lubridate")
install.packages("devtools")

# Library Lubridate to manipulate Dates
library(lubridate)

# Read Values
begin_date_str <- readline(prompt="Enter the First Date")
'10/04/2020'

end_date_str <- readline(prompt="Enter the Last Date")
'10/04/2021'

date1 = dmy(begin_date_str)
date2 = dmy(end_date_str)

inter <- interval(date1, date2)
inter2 <- interval(date1,date1)
int_overlaps(inter, inter2)

dates <- c()
date_aux = date1
print(inter == '10/04/2020')
while(int_overlaps(inter, inter2)){
    inter2 <- interval(date_aux, date_aux)
    date_aux <- date_aux+ddays(1)
    print(date_aux)
    dates[length(dates)+1] <- date_aux
}

write.table(dates, file = "wordlist.txt", sep="\n", row.names=F, col.names=F)
