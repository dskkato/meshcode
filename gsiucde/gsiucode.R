#
# Copyright (c) 2015 Research Institute for World Grid Squares 
# Aki-Hiro Sato
# All rights reserved. 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# R functions to calculate a place identification code based on ucode.
# The place identification code is based on a ucode defined in H.642 
# (06/2012) recommendation by ITU-T.
# ucode is a spatial unique sequence defined by Ubiquitous ID Center
# 128 bits length unique code to define a place with a 3-m spatial resolution.
#
# Wirtten by Dr. Aki-Hiro Sato
# Graduate School of Informatics, Kyoto University
# and
# Japan Science and Technology Agency (JST) PRESTO
#
# Contact:
# Address: Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
# E-mail: aki@i.kyoto-u.ac.jp
# TEL: +81-75-753-5515
#
#
# Version 1.0 : Released on 11 December 2015
# Version 1.1 : Released on 19 December 2015
#
# latlong_to_ucode(latitude, longitude) 
# : convert geographic location (latitude, longitude) into ucode
# ucode_to_meshcode(ucode) 
# : calculate 1km grid square code from ucode
# ucode_to_meshcode1(ucode) 
# : calculate 80km grid square code from ucode
# ucode_to_meshcode2(ucode) 
# : calculate 10km grid square code from ucode
# ucode_to_meshcode3(ucode) 
# : calculate 1km grid square code from ucode
# ucode_to_meshcode4(ucode) 
# : calculate 500m grid square code from ucode
# ucode_to_meshcode5(ucode) 
# : calculate 250m grid square code from ucode
# ucode_to_meshcode6(ucode) 
# : calculate 125m grid square code from ucode
# extract_latlong_from_ucode(ucode)
# : extract geogphical location (latitude, longitude) from ucode

source("http://www.fttsus.jp/worldmesh/R/worldmesh.R")
#
# upper 64 bits is an identification sequence to indicate 
# geospatial information authority of Japan. 
# This corresponds to L1 to L3 of H.642 by ITU-T.
gsi <<- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1)
gsi16 <<- "00001b0000000003"
#
dec2bin <- function(num, digit=0){
  if(num <= 0 && digit <= 0){
    return(NULL)
  }else{
    return(append(Recall(num%/%2,digit-1), num%%2))
  }
}

bin2hex <- function(b){
  cnt <- length(b)/4
  o <- ""
  for(i in 1:cnt){
    bb<-b[((i-1)*4+1):(i*4)]
    bb10<-bb[1]*8+bb[2]*4+bb[3]*2+bb[4]
    if(bb10==10){
      out<-"a"
    } else if(bb10==11){
      out<-"b"
    } else if(bb10==12){
      out<-"c"
    } else if(bb10==13){
      out<-"d"
    } else if(bb10==14){
      out<-"e"
    } else if(bb10==15){
      out<-"f"
    } else {
      out<-as.character(bb10)
    }
    o <- paste(o,out,sep="")
  }
  return(o)
}

hex2bin <- function(ucode){
   for(ii in 1:nchar(ucode)){
      c <- substr(ucode,ii,ii)
      if(c=="0"){
        o <- c(0,0,0,0)
      } else if(c=="1") {
        o <- c(0,0,0,1)
      } else if(c=="2") {
        o <- c(0,0,1,0)
      } else if(c=="3") {
        o <- c(0,0,1,1)
      } else if(c=="4") {
        o <- c(0,1,0,0)
      } else if(c=="5") {
        o <- c(0,1,0,1)
      } else if(c=="6") {
        o <- c(0,1,1,0)
      } else if(c=="7") {
        o <- c(0,1,1,1)
      } else if(c=="8") {
        o <- c(1,0,0,0)
      } else if(c=="9") {
        o <- c(1,0,0,1)
      } else if(c=="a") {
        o <- c(1,0,1,0)
      } else if(c=="b") {
        o <- c(1,0,1,1)
      } else if(c=="c") {
        o <- c(1,1,0,0)
      } else if(c=="d") {
        o <- c(1,1,0,1)
      } else if(c=="e") {
        o <- c(1,1,1,0)
      } else if(c=="f"){
        o <- c(1,1,1,1)
      }
      if(ii==1){
        out <- o
      } else {
        out <- append(out,o)
      }
   }
   return(out)
}

latlong_to_ucode <- function(latitude,longitude){
   class <- append(gsi,c(0,0))
   if(latitude >= 0){
     lat2_f <- 0
   } else {
     lat2_f <- 1
   }
   if(longitude >= 0){
     long2_f <- 0
   } else {
     long2_f <- 1
   }
   lat <- floor(abs(latitude)*60*60*10)
   long <- floor(abs(longitude)*60*60*10)
#   lat <- ceiling(abs(latitude)*60*60*10)
#   long <- ceiling(abs(longitude)*60*60*10)
   lat2 <- dec2bin(lat)
   long2 <- dec2bin(long)
   if(length(lat2) < 22){
     for(kk in length(lat2):21){
       lat2 <- append(0,lat2)
     }
   }
   if(length(long2) < 23){
     for(kk in length(long2):22){
       long2 <- append(0,long2)
     }
   }
   alt2 <- append(0,0) 
   for(i in 1:7) alt2 <- append(alt2,0)
   item2 <- append(0,0)
   for(i in 1:4) item2 <- append(item2,0)
   ucode <- append(class,lat2_f)
   ucode <- append(ucode,lat2)
   ucode <- append(ucode,long2_f)
   ucode <- append(ucode,long2)
   ucode <- append(ucode,alt2)
   ucode <- append(ucode,item2)
   return(bin2hex(ucode))
}

extract_latlong_from_ucode <- function(ucode){
   ucode <- tolower(ucode)
   ucode64_u <- substr(ucode,1,16)
#   cat(sprintf("%s\n",ucode64_u))
   if(is.na(match(ucode64_u,gsi16))){
      cat(sprintf("this is not a place identification code\n"))
      return(-1);
   }
   ucode64_l <- substr(ucode,17,32)
   bb <- hex2bin(ucode64_l)
   b22 <- 2^(21:0)
   lat2_f <- bb[3]
   lat2 <- bb[4:25]
   lat <- sum(lat2*b22)/60/60*0.1
   if(lat2_f == 1){
     lat <- -lat
   }
   b23 <- 2^(22:0)
   long2_f <- bb[26]
   long2 <- bb[27:49]
   long <- sum(long2*b23)/60/60*0.1
   if(long2_f == 1){
     long <- -long
   }
   res <- c(lat,long)
   names(res) <- c("latitude","longitude")
   return(res)
}

ucode_to_meshcode1 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode1(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode2 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode2(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode3 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode3(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode4 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode4(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode5 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode5(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode6 <- function(ucode){
   ucode <- tolower(ucode)
   gp <- extract_latlong_from_ucode(ucode)
   return(cal_meshcode6(as.numeric(gp[1]),as.numeric(gp[2])))
}

ucode_to_meshcode <- function(ucode){
   return(ucode_to_meshcode3(ucode))
}
