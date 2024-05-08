# plumber.R
# plumber::plumb(file='api.r')$run(host = "0.0.0.0", port = 8080)
library(stringr)
library(yaml)

# Load mac address lookup
apiConfig <- yaml.load_file('api.yaml')

# Convert binary to text
binText <- function(bin) {
  tf <- tempfile()
  writeBin(bin, tf)
  readLines(tf)
}

#* Echo the parameter that was sent in
#* @param msg The message to echo back.
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Return an image mount command based on the ifconfig
#* @post /getImagePartBootParam
#* @serializer cat
function(req) {
  # Get ifconfig output from request body
  x <- binText(req$bodyRaw)

  # Extract the ifconfig output
  mac <- str_extract(paste0(x, collapse = '\n'), "ether [^ ]* ") %>%
    str_remove("ether ") %>%
    str_remove(" $")
  
  # Create a mask to look up the applicable command for the MAC address,
  # get the numeric index of it and use it to retrieve the command
  lapply(apiConfig$macToImageDir,
         function(x) {
           mac %in% x$mac
         }) %>%
    unlist() %>%
    which() %>%
    { apiConfig$macToImageDir[[.]]$command }
  
}

