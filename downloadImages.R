# code written by Frits de Roos. Feel free to use or modify this code.

# set working directory
this_dir <- function(directory)
setwd( file.path(getwd(), directory) )

# read all csv-files in working directory
filenames <- list.files(pattern="*.csv", full.names=TRUE)
ldf <- lapply(filenames, read.csv, col.names=1:7)

# define function to remove rows from a table or list
removeRows <- function(x, numberOfRows){
  x <- x[-(1:numberOfRows),]
}

# for each file, remove the first three rows (they do not contain image entries)
ldf <- lapply(ldf, removeRows, numberOfRows=3)
# combine all the modified csv files to one file
total <-do.call(rbind, ldf)
# select only the column that contains the image urls
urls <- as.character(total$X5)
# define the destination names on the basis of the original url
# I guess this can be written more efficient, but it works
destinations <- strsplit(urls, split='/', fixed=TRUE)
destinations <- as.character(lapply(destinations, function(x) x[10]))
destinations <- strsplit(destinations, split='?', fixed=TRUE)
destinations <- as.character(lapply(destinations, function(x) x[1]))
destinations <- paste0("./images/", destinations)
# download all images. This can take quite some time.
for(i in seq_along(urls)){
  download.file(urls[i], destinations[i], mode="wb")
}
