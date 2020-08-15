# This program will generate a text file with a list of dates
#       Author: lucasrennok
#       -- WORDLIST WITH R --
#       Format: DMY

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
'15/04/2020'

# Create date object
date1 = dmy(begin_date_str)
date2 = dmy(end_date_str)

# Intervals
inter <- interval(date1, date2)
inter2 <- interval(date1,date1)

# Declaring variables
cont <- 1
dates <- c()
date_aux = date1

# Create the vector of dates
while(int_overlaps(inter, inter2)){
    day_w = mday(date_aux)
    if(day_w<10){
        day_w = paste("0", mday(date_aux), sep="")
    }
    month_w = month(date_aux)
    if(month_w<10){
        month_w = paste("0", month(date_aux), sep="")
    }
    year_w = year(date_aux)

    # Add the date in vector
    dates[cont] <- paste(day_w,month_w,year_w,sep="")

    #Updating variables
    cont <- cont+1
    date_aux <- date_aux+ddays(1)
    inter2 <- interval(date_aux, date_aux)
}

#Writing dates
write.table(dates, file = "wordlist.txt", quote=F, sep="\n", row.names=F, col.names=F)
