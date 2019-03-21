#
# Copyright (c) 2015,2016,2017 Research Institute for World Grid Squares 
# Aki-Hiro Sato
# All rights reserved. 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# python functions to calculate a place identification code based on ucode.
# The place identification code is based on a ucode defined in H.642
# (06/2012) recommendation by ITU-T.
# ucode is a spatial unique sequence defined by Ubiquitous ID Center
# 128 bits len unique code to define a place with a 3-m spatial resolution.
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
# Version 1.0 : Released on March 19 2017
#
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

from worldmesh import *
import math
import re
#
# upper 64 bits is an identification sequence to indicate
# geospatial information authority of Japan.
# This corresponds to L1 to L3 of H.642 by ITU-T.
gsi = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1]
gsi16 = "00001b0000000003"

def dec2bin(num):
    b=str(bin(num))
    bb=list(b)[2:]
    return list(map(int,bb))

def bin2hex(b):
  cnt = int(len(b)/4)
  o = ""
  for i in range(cnt):
    bb=b[(i*4):(i*4)+4]
    bb10=bb[0]*8+bb[1]*4+bb[2]*2+bb[3]
    if bb10==10:
      out="a"
    elif bb10==11:
      out="b"
    elif bb10==12:
      out="c"
    elif bb10==13:
      out="d"
    elif bb10==14:
      out="e"
    elif bb10==15:
      out="f"
    else:
      out=str(bb10)
    o = o+out
  return o

def hex2bin(ucode):
   for ii in range(len(ucode)):
      c = ucode[ii:ii+1]
      if c=="0":
        o =[0,0,0,0]
      elif c=="1":
        o =[0,0,0,1]
      elif c=="2":
        o =[0,0,1,0]
      elif c=="3":
        o = [0,0,1,1]
      elif c=="4":
        o = [0,1,0,0]
      elif c=="5":
        o = [0,1,0,1]
      elif c=="6":
        o = [0,1,1,0]
      elif c=="7":
        o = [0,1,1,1]
      elif c=="8":
        o = [1,0,0,0]
      elif c=="9":
        o = [1,0,0,1]
      elif c=="a":
        o = [1,0,1,0]
      elif c=="b":
        o = [1,0,1,1]
      elif c=="c":
        o = [1,1,0,0]
      elif c=="d":
        o = [1,1,0,1]
      elif c=="e":
        o = [1,1,1,0]
      elif c=="f":
        o = [1,1,1,1]
      if ii==0:
        out = o
      else:
        out = out+o
   return out

def latlong_to_ucode(latitude,longitude):
   if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
     return "99999999999999999999999999999999"
   class_ = gsi+[0,0]
   if latitude >= 0:
     lat2_f = 0
   else:
     lat2_f = 1
   if longitude >= 0:
     long2_f = 0
   else:
     long2_f = 1
   lat =math.floor(abs(latitude)*60*60*10)
   long =math.floor(abs(longitude)*60*60*10)

#   lat = ceiling(abs(latitude)*60*60*10)
#   long = ceiling(abs(longitude)*60*60*10)
   lat2 = dec2bin(lat)
   long2 = dec2bin(long)
   if len(lat2) < 22:
     for kk in range(len(lat2),22):
       lat2 = [0]+lat2
   if len(long2) < 23:
     for kk in range(len(long2),23):
       long2 = [0]+long2
   alt2 = [0]+[0]
   for i in range(1,9):
        alt2 =alt2+[0]
   item2 = [0]+[0]
   for i in range(1,6):
       item2 = item2+[0]
   ucode = class_+[lat2_f]
   ucode = ucode+lat2
   ucode = ucode+[long2_f]
   ucode = ucode+long2
   ucode = ucode+alt2
   ucode = ucode+item2
   return bin2hex(ucode)

def extract_latlong_from_ucode(ucode):
   ucode = ucode.lower()
   ucode64_u = ucode[0:16]
   if re.match(gsi16,ucode64_u)== None:
      print("this is not a place identification code")
      return -1

   ucode64_l = ucode[16:32]
   bb = hex2bin(ucode64_l)
   b22 = [2**i for i in range(21,-1,-1)]
   lat2_f = bb[2]
   lat2 = bb[3:25]
   lat = sum([x*y for (x,y) in zip(lat2,b22)])/60/60*0.1
   if lat2_f == 1:
      lat = -lat
   b23 = [2**i for i in range(22,-1,-1)]
   long2_f = bb[25]
   long2 = bb[26:49]
   long = sum([x*y for (x,y) in zip(long2,b23)])/60/60*0.1
   if long2_f == 1:
      long = -long
   res={"latitude" : lat,"longitude" : long}
   return res

def ucode_to_meshcode1(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode1(float(gp["latitude"]),float(gp["longitude"]))

def ucode_to_meshcode2(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode2(float(gp["latitude"]),float(gp["longitude"]))

def ucode_to_meshcode3(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode3(float(gp["latitude"]),float(gp["longitude"]))

def ucode_to_meshcode4(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode4(float(gp["latitude"]),float(gp["longitude"]))


def ucode_to_meshcode5(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode5(float(gp["latitude"]),float(gp["longitude"]))

def ucode_to_meshcode6(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode6(float(gp["latitude"]),float(gp["longitude"]))


def ucode_to_meshcode(ucode):
   ucode = ucode.lower()
   gp = extract_latlong_from_ucode(ucode)
   return cal_meshcode3(float(gp["latitude"]),float(gp["longitude"]))
