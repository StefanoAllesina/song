song.BuildBird <- function(ID, recital, start.record.time, end.record.time){
  ## create a bird:
  ## a list that includes some stats on the songs

  bird <- list()
  ## bird identifier
  bird$ID <- ID
  ## info on the recording time
  bird$start.record.time <- start.record.time
  bird$end.record.time <- end.record.time
  ## recital [start, stop] for each song
  colnames(recital) <- c("start", "end")
  rownames(recital) <- 1:dim(recital)[1]
  bird$recital <- recital
  ## number of songs
  bird$songs.num <- dim(recital)[1]
  ## length of the songs
  bird$songs.length <- recital[,2] - recital[,1]
  ## total time sang
  bird$songs.total.length <- sum(bird$songs.length)
  ## gaps in between songs
  for.gaps.start <- c(recital[,1], end.record.time)
  for.gaps.end <- c(start.record.time, recital[,2])
  bird$gaps.num <- bird$songs.num + 1
  bird$gaps.length <- for.gaps.start - for.gaps.end
  bird$gaps.total.length <- sum(bird$gaps.length)
  return(bird)
}

#' Reads a file containing the recitals for the birds
#'
#' @param file.recitals A file containing the start time and end time of all the songs
#' @param start.record.time Optional parameter to set a particular start time for the recording
#' @param end.record.time Optional parameter to set a particular end time for the recording
#' @examples
#' \dontrun{
#' Rec <- song.ReadRecitals("test.txt", 0.1, 100)
#' }
#'@return A list of birds along with their recital
song.ReadRecitals <- function(file.recitals,
                              start.record.time = NA,
                              end.record.time = NA){
  ## read a list of songs and build
  ## the bird lists

  ## The input file is a space-separated file
  ## whose rows are startsong endsong birdID

  ## one can specify the start record time
  ## and the end record time.
  ## if they are not specified, the min and max
  ## are taken (respectively)

  recitals <- read.table(file.recitals)
  ## sanity check: each song must be of positive length
  lengths <- recitals[,2] - recitals[,1]
  if (sum(lengths <= 0.) > 0){
    print("The file contains songs of null or negative length!")
    return(-1)
  }
  ## check whether the user entered start and end record.time
  if (is.na(start.record.time)){
    start.record.time <- min(recitals[,1:2])
  }
  if (is.na(end.record.time)){
    end.record.time <- max(recitals[,1:2])
  }

  ## proceed building the birds
  birds <- list()
  unique.IDs <- unique(recitals[,3])
  for (i in 1:length(unique.IDs)){
    my.ID <- as.character(unique.IDs[i])
    birds[[my.ID]] <- song.BuildBird(my.ID,
                                     as.matrix(
                                       recitals[recitals[,3] == my.ID, 1:2]
                                     ),
                                     start.record.time,
                                     end.record.time)
  }
  return(birds)
}

song.BuildRecitals <- function(recitals,
                              start.record.time = NA,
                              end.record.time = NA){

  ## sanity check: each song must be of positive length
  lengths <- recitals[,2] - recitals[,1]
  if (sum(lengths <= 0.) > 0){
    print("The file contains songs of null or negative length!")
    return(-1)
  }
  ## check whether the user entered start and end record.time
  if (is.na(start.record.time)){
    start.record.time <- min(recitals[,1:2])
  }
  if (is.na(end.record.time)){
    end.record.time <- max(recitals[,1:2])
  }

  ## proceed building the birds
  birds <- list()
  unique.IDs <- unique(recitals[,3])
  for (i in 1:length(unique.IDs)){
    my.ID <- as.character(unique.IDs[i])
    birds[[my.ID]] <- song.BuildBird(my.ID,
                                     as.matrix(
                                       recitals[recitals[,3] == my.ID, 1:2]
                                     ),
                                     start.record.time,
                                     end.record.time)
  }
  return(birds)
}

