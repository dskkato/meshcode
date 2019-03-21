#
# Copyright (c) 2015 Research Institute for World Grid Squares 
# Aki-Hiro Sato
# All rights reserved. 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# R functions to calculate the world grid square code.
# The world grid square code computed by this library 
# is compatible to JISX0410.
# 
# Version 1.0 : Released on 02 June 2015
# Version 1.1 : Released on 09 July 2015
# Version 1.2 : Released on 30 July 2015
# Version 1.3 : Released on 03 August 2015
# Version 1.3.1 : Released on 05 August 2015
# Version 1.4 : Released on 19 December 2015
#
# Written by Dr. Aki-Hiro Sato
# Graduate School of Informatics, Kyoto University
# and
# Japan Science and Technology Agency (JST) PRESTO
#
# Contact:
# Address: Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
# E-mail: aki@i.kyoto-u.ac.jp
# TEL: +81-75-753-5515
#
# Two types of functions are defined in this library.
# 1. calculate representative geographical position(s) (latitude, longitude) of a grid square from a grid square code
# 2. calculate a grid square code from a geographical position (latitude, longitude) 
#
# 1.
#
# meshcode_to_latlong(meshcode)
# : calculate northen western geographic position of the grid (latitude, longitude) from meshcode
# meshcode_to_latlong_NW(meshcode)
# : calculate northen western geographic position of the grid (latitude, longitude) from meshcode
# meshcode_to_latlong_SW(meshcode)
# : calculate sourthern western geographic position of the grid (latitude, longitude) from meshcode
# meshcode_to_latlong_NE(meshcode)
# : calculate northern eastern geographic position of the grid (latitude, longitude) from meshcode
# meshcode_to_latlong_SE(meshcode)
# : calculate sourthern eastern geographic position of the grid (latitude, longitude) from meshcode
# meshcode_to_latlong_grid(meshcode)
# : calculate northern western and sourthern eastern geographic positions of the grid (latitude0, longitude0, latitude1, longitude1) from meshcode
# cal_meshcode(latitude,longitude)
#
# 2.
#
# : calculate a basic (1km) grid square code (10 digits) from a geographical position (latitude, longitude)
# cal_meshcode1(latitude,longitude)
# : calculate an 80km grid square code (6 digits) from a geographical position (latitude, longitude)
# cal_meshcode2(latitude,longitude)
# : calculate a 10km grid square code (8 digits) from a geographical position (latitude, longitude)
# cal_meshcode3(latitude,longitude)
# : calculate a 1km grid square code (10 digits) from a geographical position (latitude, longitude)
# cal_meshcode4(latitude,longitude)
# : calculate a 500m grid square code (11 digits) from a geographical position (latitude, longitude)
# cal_meshcode5(latitude,longitude)
# : calculate a 250m grid square code (12 digits) from a geographical position (latitude, longitude)
# cal_meshcode6(latitude,longitude)
# : calculate a 125m grid square code (13 digits) from a geographical position (latitude, longitude)
#
# Structure of the world grid square code with compatibility to JIS X0410
# A : area code (1 digit) A takes 1 to 8
# ABBBBB : 80km grid square code (40 arc-minutes for latitude, 1 arc-degree for longitude) (6 digits)
# ABBBBBCC : 10km grid square code (5 arc-minutes for latitude, 7.5 arc-minutes for longitude) (8 digits)
# ABBBBBCCDD : 1km grid square code (30 arc-seconds for latitude, 45 arc-secondes for longitude) (10 digits)
# ABBBBBCCDDE : 500m grid square code (15 arc-seconds for latitude, 22.5 arc-seconds for longitude) (11 digits)
# ABBBBBCCDDEF : 250m grid square code (7.5 arc-seconds for latitude, 11.25 arc-seconds for longitude) (12 digits)
# ABBBBBCCDDEFG : 125m grid square code (3.75 arc-seconds for latitude, 5.625 arc-seconds for longitude) (13 digits)

meshcode_to_latlong <- function (meshcode){
  res<-meshcode_to_latlong_grid(meshcode)
  xx<-list(res$lat0,res$long0)
  names(xx)<-c("lat","long")
  return(xx)
}

meshcode_to_latlong_NW <- function (meshcode){
  res<-meshcode_to_latlong_grid(meshcode)
  xx<-list(res$lat0,res$long0)
  names(xx)<-c("lat","long")
  return(xx)
}

meshcode_to_latlong_SW <- function(meshcode){
  res<-meshcode_to_latlong_grid(meshcode)
  xx<-list(res$lat1,res$long0)
  names(xx)<-c("lat","long")
  return(xx)
}

meshcode_to_latlong_NE <- function(meshcode){
  res<-meshcode_to_latlong_grid(meshcode)
  xx<-list(res$lat0,res$long1)
  names(xx)<-c("lat","long")
  return(xx)
}

meshcode_to_latlong_SE <- function(meshcode){
  res<-meshcode_to_latlong_grid(meshcode)
  xx<-list(res$lat1,res$long1)
  names(xx)<-c("lat","long")
  return(xx)
}

meshcode_to_latlong_grid <- function (meshcode){
    code <- as.character(meshcode)

    if (length(grep("^[0-9]{6}", code)) == 1) { # more than 1st grid
        code0 <- as.numeric(substring(code, 1, 1)) # code0 : 1 to 8
        code0 <- code0 - 1 # transforming code0 from 0 to 7
          code12 <- substring(code, 2, 4)
        if(substring(code12,1,2)=="00"){
          code12 <- as.numeric(substring(code, 4, 4))
        }
        else{
          if(substring(code12,1,2)=="0"){
            code12 <- as.numeric(substring(code, 3, 4))
          }
          else{
            code12 <- as.numeric(substring(code, 2, 4))
          }
        }
        if(substring(code,5,5)=="0"){
          code34 <- as.numeric(substring(code, 6, 6))
        }
        else{
          code34 <- as.numeric(substring(code, 5, 6))
        }
        lat_width  <- 2 / 3;
        long_width <- 1;
    }
    else {
        return(NULL)
    }

    if (length(grep("^[0-9]{8}", code)) == 1) { # more than 2nd grid
        code5 <- as.numeric(substring(code, 7, 7))
        code6 <- as.numeric(substring(code, 8, 8))
        lat_width  <- lat_width / 8;
        long_width <- long_width / 8;
    }

    if (length(grep("^[0-9]{10}", code)) == 1) { # more than 3rd grid
        code7 <- as.numeric(substring(code, 9, 9))
        code8 <- as.numeric(substring(code, 10, 10))
        lat_width  <- lat_width / 10;
        long_width <- long_width / 10;
    }

    if (length(grep("^[0-9]{11}", code)) == 1) { # more than 4th grid
        code9 <- as.numeric(substring(code, 11, 11))
        lat_width  <- lat_width / 20;
        long_width <- long_width / 20;
    }

    if (length(grep("^[0-9]{12}", code)) == 1) { # more than 5th grid
        code10 <- as.numeric(substring(code, 12, 12))
        lat_width  <- lat_width / 40;
        long_width <- long_width / 40;
    }

    if (length(grep("^[0-9]{13}", code)) == 1) { # more than 6th grid
        code11 <- as.numeric(substring(code, 13, 13))
        lat_width  <- lat_width / 80;
        long_width <- long_width / 80;
    }

    # 0'th grid
    z <- code0 %% 2
    y <- ((code0 - z)/2) %% 2
    x <- (code0 - 2*y - z)/4

    if(nchar(code)==6){  #  1st grid
      lat0  <- (code12-x+1) * 2 / 3;        
      long0 <- (code34+y) + 100*z;
      lat0  <- (1-2*x)*lat0;        
      long0 <- (1-2*y)*long0;
      dlat <- 2/3;
      dlong <- 1;
      lat1  <- sprintf("%.8f", lat0-dlat);  
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0);  
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1));
      names(xx) <- c("lat0","long0","lat1","long1");
      return(xx)
    }
    if(nchar(code)==8) {  # 2nd grid
      lat0  <- code12 * 2 / 3;  
      long0 <- code34 + 100*z;
      lat0  <- lat0  + ((code5-x+1) * 2 / 3) / 8; 
      long0 <- long0 +  (code6+y) / 8;
      lat0 <- (1-2*x) * lat0;
      long0 <- (1-2*y) * long0;
      dlat <- 2/3/8;
      dlong <- 1/8;
      lat1  <- sprintf("%.8f", lat0-dlat);  
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0);  
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1))
      names(xx) <- c("lat0","long0","lat1","long1")
      return(xx)
    }
    if(nchar(code)==10) {  # 3rd grid
      lat0  <- code12 * 2 / 3;  
      long0 <- code34 + 100*z;
      lat0  <- lat0  + (code5 * 2 / 3) / 8; 
      long0 <- long0 +  code6 / 8;
      lat0  <- lat0  + ((code7-x+1) * 2 / 3) / 8 / 10;
      long0 <- long0 +  (code8+y) / 8 / 10;
      lat0 <- (1-2*x)*lat0;
      long0 <- (1-2*y)*long0;
      dlat <- 2/3/8/10;
      dlong <- 1/8/10;
      lat1  <- sprintf("%.8f", lat0-dlat); 
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0); 
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1))
      names(xx) <- c("lat0","long0","lat1","long1")
      return(xx)
    }
    # code 9
    #     N
    #   3 | 4
    # W - + - E
    #   1 | 2
    #     S
    if(nchar(code)==11) {  # 4th grid (11 digits)
      lat0  <- code12 * 2 / 3;  
      long0 <- code34 + 100*z;
      lat0  <- lat0  + (code5 * 2 / 3) / 8; 
      long0 <- long0 +  code6 / 8;
      lat0  <- lat0  + ((code7-x+1) * 2 / 3) / 8 / 10;
      long0 <- long0 +  (code8+y) / 8 / 10;
      lat0  <- lat0  + (floor((code9-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2;
      long0 <- long0 + ((code9-1)%%2-y) / 8 / 10 / 2;
      lat0 <- (1-2*x)*lat0;
      long0 <- (1-2*y)*long0;
      dlat <- 2/3/8/10/2;
      dlong <- 1/8/10/2;
      lat1  <- sprintf("%.8f", lat0-dlat); 
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0); 
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1))
      names(xx) <- c("lat0","long0","lat1","long1")
      return(xx)
    }
    # code 10
    #     N
    #   3 | 4
    # W - + - E
    #   1 | 2
    #     S
    if(nchar(code)==12) {  # 5th grid (12 digits)
      lat0  <- code12 * 2 / 3;  
      long0 <- code34 + 100*z;
      lat0  <- lat0  + (code5 * 2 / 3) / 8; 
      long0 <- long0 +  code6 / 8;
      lat0  <- lat0  + ((code7-x+1) * 2 / 3) / 8 / 10;
      long0 <- long0 +  (code8+y) / 8 / 10;
      lat0  <- lat0  + (floor((code9-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2;
      long0 <- long0 + ((code9-1)%%2-y) / 8 / 10 / 2;
      lat0  <- lat0  + (floor((code10-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2 / 2;
      long0 <- long0 + ((code10-1)%%2-y) / 8 / 10 / 2 / 2;
      lat0 <- (1-2*x)*lat0;
      long0 <- (1-2*y)*long0;
      dlat <- 2/3/8/10/2/2;
      dlong <- 1/8/10/2/2;
      lat1  <- sprintf("%.8f", lat0-dlat); 
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0); 
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1))
      names(xx) <- c("lat0","long0","lat1","long1")
      return(xx)
    }
    # code 11
    #     N
    #   3 | 4
    # W - + - E
    #   1 | 2
    #     S
    if(nchar(code)==13) {  # 6rd grid (13 digits)
      lat0  <- code12 * 2 / 3;  
      long0 <- code34 + 100*z;
      lat0  <- lat0  + (code5 * 2 / 3) / 8; 
      long0 <- long0 +  code6 / 8;
      lat0  <- lat0  + ((code7-x+1) * 2 / 3) / 8 / 10;
      long0 <- long0 +  (code8+y) / 8 / 10;
      lat0  <- lat0  + (floor((code9-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2;
      long0 <- long0 + ((code9-1)%%2-y) / 8 / 10 / 2;
      lat0  <- lat0  + (floor((code10-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2 / 2;
      long0 <- long0 + ((code10-1)%%2-y) / 8 / 10 / 2 / 2;
      lat0  <- lat0  + (floor((code11-1)/2)+x-1) * 2 / 3 / 8 / 10 / 2 / 2 / 2;
      long0 <- long0 + ((code11-1)%%2-y) / 8 / 10 / 2 / 2 / 2;
      lat0 <- (1-2*x)*lat0;
      long0 <- (1-2*y)*long0;
      dlat <- 2/3/8/10/2/2/2;
      dlong <- 1/8/10/2/2/2;
      lat1  <- sprintf("%.8f", lat0-dlat); 
      long1 <- sprintf("%.8f", long0+dlong);
      lat0  <- sprintf("%.8f", lat0); 
      long0 <- sprintf("%.8f", long0);
      xx <- list(as.numeric(lat0), as.numeric(long0), as.numeric(lat1), as.numeric(long1))
      names(xx) <- c("lat0","long0","lat1","long1")
      return(xx)
    }

    xx <- list(as.numeric(99999), as.numeric(99999),as.numeric(99999), as.numeric(99999))
    names(xx) <- c("lat0","long0","lat1","long1")
    return(xx)
}

# calculate 3rd mesh code
cal_meshcode <- function(latitude, longitude){
  return(cal_meshcode3(latitude,longitude))
}

# calculate 1st mesh code
cal_meshcode1 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  u <- floor(longitude-100*z)
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,sep="")
      }
      else{
        mesh <- paste(o,p,u,sep="")
      }
    }
  }
  return(mesh)
}

# calculate 2nd mesh code
cal_meshcode2 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  a <- (latitude*60/40-p)*40
  q <- floor(a/5)
  u <- floor(longitude-100*z)
  f <- longitude-100*z-u
  v <- floor(f*60/7.5)
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,q,v,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,q,v,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,q,v,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,q,v,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,q,v,sep="")
      }
      else{
        mesh <- paste(o,p,u,q,v,sep="")
      }
    }
  }
  return(mesh)
}

# calculate 3rd mesh code
cal_meshcode3 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  a <- (latitude*60/40-p)*40
  q <- floor(a/5)
  b <- (a/5-q)*5
  r <- floor(b*60/30)
  c <- (b*60/30-r)*30
  u <- floor(longitude-100*z)
  f <- longitude-100*z-u
  v <- floor(f*60/7.5)
  g <- (f*60/7.5-v)*7.5
  w <- floor(g*60/45)
  h <- (g*60/45-w)*45
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,q,v,r,w,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,q,v,r,w,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,q,v,r,w,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,q,v,r,w,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,q,v,r,w,sep="")
      }
      else{
        mesh <- paste(o,p,u,q,v,r,w,sep="")
      }
    }
  }
  return(mesh)
}

# calculate 4th mesh code
cal_meshcode4 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  a <- (latitude*60/40-p)*40
  q <- floor(a/5)
  b <- (a/5-q)*5
  r <- floor(b*60/30)
  c <- (b*60/30-r)*30
  s2u <- floor(c/15)
  u <- floor(longitude-100*z)
  f <- longitude-100*z-u
  v <- floor(f*60/7.5)
  g <- (f*60/7.5-v)*7.5
  w <- floor(g*60/45)
  h <- (g*60/45-w)*45
  s2l <- floor(h/22.5)
  s2 <- s2u*2+s2l+1
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,q,v,r,w,s2,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,q,v,r,w,s2,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,q,v,r,w,s2,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,q,v,r,w,s2,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,q,v,r,w,s2,sep="")
      }
      else{
        mesh <- paste(o,p,u,q,v,r,w,s2,sep="")
      }
    }
  }
  return(mesh)
}

# calculate 5rd mesh code
cal_meshcode5 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  a <- (latitude*60/40-p)*40
  q <- floor(a/5)
  b <- (a/5-q)*5
  r <- floor(b*60/30)
  c <- (b*60/30-r)*30
  s2u <- floor(c/15)
  d <- (c/15-s2u)*15
  s4u <- floor(d/7.5)
  u <- floor(longitude-100*z)
  f <- longitude-100*z-u
  v <- floor(f*60/7.5)
  g <- (f*60/7.5-v)*7.5
  w <- floor(g*60/45)
  h <- (g*60/45-w)*45
  s2l <- floor(h/22.5)
  i <- (h/22.5-s2l)*22.5
  s4l <- floor(i/11.25)
  s2 <- s2u*2+s2l+1
  s4 <- s4u*2+s4l+1
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,q,v,r,w,s2,s4,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,q,v,r,w,s2,s4,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,q,v,r,w,s2,s4,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,q,v,r,w,s2,s4,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,q,v,r,w,s2,s4,sep="")
      }
      else{
        mesh <- paste(o,p,u,q,v,r,w,s2,s4,sep="")
      }
    }
  }
  return(mesh)
}

# calculate 6rd mesh code
cal_meshcode6 <- function(latitude, longitude){
  if(latitude < 0){
    o <- 4
  }
  else{
    o <- 0
  }
  if(longitude < 0){
    o <- o + 2
  }
  if(abs(longitude) >= 100) o <- o + 1
  z <- o %% 2
  y <- ((o - z)/2) %% 2
  x <- (o - 2*y - z)/4
#
  o <- o + 1
#
  latitude <- (1-2*x)*latitude
  longitude <- (1-2*y)*longitude
  #
  p <- floor(latitude*60/40)
  a <- (latitude*60/40-p)*40
  q <- floor(a/5)
  b <- (a/5-q)*5
  r <- floor(b*60/30)
  c <- (b*60/30-r)*30
  s2u <- floor(c/15)
  d <- (c/15-s2u)*15
  s4u <- floor(d/7.5)
  e <- (d/7.5-s4u)*7.5
  s8u <- floor(e/3.75)
  u <- floor(longitude-100*z)
  f <- longitude-100*z-u
  v <- floor(f*60/7.5)
  g <- (f*60/7.5-v)*7.5
  w <- floor(g*60/45)
  h <- (g*60/45-w)*45
  s2l <- floor(h/22.5)
  i <- (h/22.5-s2l)*22.5
  s4l <- floor(i/11.25)
  j <- (i/11.25-s4l)*11.25
  s8l <- floor(j/5.625)
  s2 <- s2u*2+s2l+1
  s4 <- s4u*2+s4l+1
  s8 <- s8u*2+s8l+1
  #
  if(u < 10){
    if(p < 10){
      mesh <- paste(o,"00",p,"0",u,q,v,r,w,s2,s4,s8,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,"0",u,q,v,r,w,s2,s4,s8,sep="")
      }
      else{
        mesh <- paste(o,p,"0",u,q,v,r,w,s2,s4,s8,sep="")
      }
    }
  }
  else{
    if(p < 10){
      mesh <- paste(o,"00",p,u,q,v,r,w,s2,s4,s8,sep="")
    }else{
      if(p < 100){
        mesh <- paste(o,"0",p,u,q,v,r,w,s2,s4,s8,sep="")
      }
      else{
        mesh <- paste(o,p,u,q,v,r,w,s2,s4,s8,sep="")
      }
    }
  }
  return(mesh)
}
