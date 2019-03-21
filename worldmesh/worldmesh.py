#
# Copyright (c) 2015,2016,2017,2018 Research Institute for World Grid Squares 
# Aki-Hiro Sato
# All rights reserved. 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Python functions to calculate the world grid square code.
# The world grid square code computed by this library
# is compatible to JISX0410.
#
# Release notes
# Version 1.2 : Released on 10 December 2018
# Version 1.1 : Released on 7 September 2017
# Version 1.0 : Released on 4 April 2017
#
# Written by Dr. Aki-Hiro Sato
# Graduate School of Informatics, Kyoto University
# Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
# E-mail: aki@i.kyoto-u.ac.jp
# TEL: +81-75-753-5515
#
# Difference from Version 1.1
# Compatibility of numeric calcuation for both Python2 and Python3
# Difference from Version 1.0
# Debugging for cal_meshcode5() and cal_meshcode6()
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

import math

def meshcode_to_latlong(meshcode):
    res=meshcode_to_latlong_grid(meshcode)
    xx={"lat":res["lat0"],"long":res["long0"]}
    return xx

def meshcode_to_latlong_NW(meshcode):
    res=meshcode_to_latlong_grid(meshcode)
    xx={"lat":res["lat0"],"long":res["long0"]}
    return xx

def meshcode_to_latlong_SW(meshcode):
  res=meshcode_to_latlong_grid(meshcode)
  xx={"lat":res["lat1"],"long":res["long0"]}
  return(xx)

def meshcode_to_latlong_NE(meshcode):
  res=meshcode_to_latlong_grid(meshcode)
  xx={"lat":res["lat0"],"long":res["long1"]}
  return xx

def meshcode_to_latlong_SE(meshcode):
  res=meshcode_to_latlong_grid(meshcode)
  xx={"lat":res["lat1"],"long":res["long1"]}
  return xx

def meshcode_to_latlong_grid(meshcode):
    code=str(meshcode)
    # more than 1st grid
    if len(code)>=6 :
        code0=int(code[0:1])-1
        code12=code[1:4]
        if code12[0:1]=="00":
            code12=int(code[3:4])
        else:
            if code12[0:2]=="0":
                code12=int(code[2:4])
            else:
                code12=int(code[1:4])
        if code[4:5]=="0":
            code34=int(code[5:6])
        else:
            code34=int(code[4:6])
        lat_width=2.0/3.0
        long_width=1.0
    else: return None

    # more than 2nd grid
    if len(code)>=8:
        code5=int(code[6:7])
        code6=int(code[7:8])
        lat_width=lat_width/8.0
        long_width=long_width/8.0
    # more than 3rd grid
    if len(code)>=10:
        code7=int(code[8:9])
        code8=int(code[9:10])
        lat_width=lat_width/10.0
        long_width=long_width/10.0
    # more than 4th grid
    if len(code)>=11:
        code9=int(code[10:11])
        lat_width=lat_width/20.0
        long_width=long_width/20.0
    # morethan 5th grid
    if len(code)>=12:
        code10=int(code[11:12])
        lat_width=lat_width/40.0
        long_width=long_width/40.0
    # more than 6th grid
    if len(code)>=13:
        code11=int(code[12:13])
        lat_width=lat_width/80.0
        long_width=long_width/80.0

    # 0'th grid
    z = code0 % 2
    y = ((code0-z)/2) % 2
    x = (code0-2*y-z)/4

    # 1st grid
    if len(code)==6:
        lat0  = (code12-x+1) * 2.0 / 3.0
        long0 = (code34+y) + 100*z
        lat0  = (1-2*x)*lat0
        long0 = (1-2*y)*long0
        dlat = 2.0/3.0
        dlong = 1.0
        lat1  = "%.8f" % (lat0-dlat)
        long1 = "%.8f" % (long0+dlong)
        lat0  = "%.8f" % lat0
        long0 = "%.8f" % long0
        xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
        return xx
    # 2nd grid
    elif len(code)==8:
        lat0  = code12 * 2.0 / 3.0
        long0 = code34 + 100*z
        lat0  = lat0  + ((code5-x+1) * 2.0 / 3.0) / 8.0
        long0 = long0 +  (code6+y) / 8.0
        lat0 = (1-2*x) * lat0
        long0 = (1-2*y) * long0
        dlat = 2.0/3.0/8.0
        dlong = 1.0/8.0
        lat1  = "%.8f" % (lat0-dlat)
        long1 = "%.8f" % (long0+dlong)
        lat0  = "%.8f" % lat0
        long0 = "%.8f" % long0
        xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
        return xx
     # 3rd grid
    elif len(code)==10:
         lat0  = code12 * 2.0 / 3.0
         long0 = code34 + 100*z
         lat0  = lat0  + (code5 * 2.0 / 3.0) / 8.0
         long0 = long0 +  code6 / 8.0
         lat0  = lat0  + ((code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0
         long0 = long0 +  (code8+y) / 8.0 / 10.0
         lat0 = (1-2*x)*lat0
         long0 = (1-2*y)*long0
         dlat = 2.0/3.0/8.0/10.0
         dlong = 1/8.0/10.0
         lat1  = "%.8f" % (lat0-dlat)
         long1 = "%.8f" % (long0+dlong)
         lat0  = "%.8f" % (lat0)
         long0 = "%.8f" % (long0)
         xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
         return xx
     # code 9
     #     N
     #   3 | 4
     # W - + - E
     #   1 | 2
     #     S
     # 4th frid (11 digits)
    elif len(code)==11:
         lat0  = code12 * 2.0 / 3.0
         long0 = code34 + 100*z
         lat0  = lat0  + (code5 * 2.0 / 3.0) / 8.0
         long0 = long0 +  code6 / 8.0
         lat0  = lat0  + ((code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0
         long0 = long0 +  (code8+y) / 8.0 / 10.0
         lat0  = lat0  + (math.floor((code9-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0
         long0 = long0 + ((code9-1)%2-y) / 8.0 / 10.0 / 2.0
         lat0 = (1-2*x)*lat0
         long0 = (1-2*y)*long0
         dlat = 2.0/3.0/8.0/10.0/2.0
         dlong = 1.0/8.0/10.0/2.0
         lat1  = "%.8f" % (lat0-dlat)
         long1 = "%.8f" % (long0+dlong)
         lat0  = "%.8f" % lat0
         long0 = "%.8f" % long0
         xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
         return xx
    # code 10
    #     N
    #   3 | 4
    # W - + - E
    #   1 | 2
    #     S
    # 5th grid (12 digits)
    elif len(code)==12:
        lat0  = code12 * 2.0 / 3.0
        long0 = code34 + 100*z
        lat0  = lat0  + (code5 * 2.0 / 3.0) / 8.0
        long0 = long0 +  code6 / 8.0
        lat0  = lat0  + ((code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0
        long0 = long0 +  (code8+y) / 8.0 / 10.0
        lat0  = lat0  + (math.floor((code9-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0
        long0 = long0 + ((code9-1)%2-y) / 8.0 / 10.0 / 2.0
        lat0  = lat0  + (math.floor((code10-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0
        long0 = long0 + ((code10-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0
        lat0 = (1-2*x)*lat0
        long0 = (1-2*y)*long0
        dlat = 2.0/3.0/8.0/10.0/2.0/2.0
        dlong = 1.0/8.0/10.0/2.0/2.0
        lat1  = "%.8f" % (lat0-dlat)
        long1 = "%.8f" % (long0+dlong)
        lat0  = "%.8f" % (lat0)
        long0 = "%.8f" % (long0)
        xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
        return xx
    # code 11
    #     N
    #   3 | 4
    # W - + - E
    #   1 | 2
    #     S
    # 6rd grid (13 digits)
    elif len(code)==13:
        lat0  = code12 * 2.0 / 3.0
        long0 = code34 + 100*z
        lat0  = lat0  + (code5 * 2.0 / 3.0) / 8.0
        long0 = long0 +  code6 / 8.0
        lat0  = lat0  + ((code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0
        long0 = long0 +  (code8+y) / 8.0 / 10.0
        lat0  = lat0  + (math.floor((code9-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0
        long0 = long0 + ((code9-1)%2-y) / 8.0 / 10.0 / 2.0
        lat0  = lat0  + (math.floor((code10-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0
        long0 = long0 + ((code10-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0
        lat0  = lat0  + (math.floor((code11-1)/2)+x-1) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0 / 2.0
        long0 = long0 + ((code11-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0 / 2.0
        lat0 = (1-2*x)*lat0
        long0 = (1-2*y)*long0
        dlat = 2.0/3.0/8.0/10.0/2.0/2.0/2.0
        dlong = 1.0/8.0/10.0/2.0/2.0/2.0
        lat1  = "%.8f" % (lat0-dlat)
        long1 = "%.8f" % (long0+dlong)
        lat0  = "%.8f" % lat0
        long0 = "%.8f" % long0
        xx = {"lat0":float(lat0), "long0":float(long0), "lat1":float(lat1), "long1":float(long1)}
        return xx

    xx = {"lat0":int("99999"), "long0":int("99999"), "lat1":int("99999"), "long1":int("99999")}
    return xx

# calculate 3rd mesh code
def cal_meshcode(latitude, longitude):
  return cal_meshcode3(latitude,longitude)

# calculate 1st mesh code
def cal_meshcode1(latitude, longitude):
  if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
    return "999999"
  if latitude < 0:
    o = 4
  else:
    o = 0
  if longitude < 0:
    o = o + 2
  if abs(longitude) >= 100:
    o = o + 1
  z = o % 2
  y = ((o - z)/2) % 2
  x = (o - 2*y - z)/4
#
  o = o + 1
#
  latitude = (1-2*x)*latitude
  longitude = (1-2*y)*longitude
  #
  p = math.floor(latitude*60/40)
  u = math.floor(longitude-100*z)
  #
  o = int(o)
  p = int(p)
  u = int(u)
  #
  if u < 10:
    if p < 10:
      mesh = str(o)+"00"+str(p)+"0"+str(u)
    else:
      if p < 100:
       mesh = str(o)+"0"+str(p)+"0"+str(u)
      else:
       mesh = str(o)+str(p)+"0"+str(u)
  else:
    if p < 10:
      mesh = str(o)+"00"+str(p)+str(u)
    else:
      if p < 100:
          mesh = str(o)+"0"+str(p)+str(u)
      else:
        mesh = str(o)+str(p)+str(u)
  return mesh

# calculate 2nd mesh code
def cal_meshcode2(latitude, longitude):
 if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
   return "99999999"
 if latitude < 0:
    o = 4
 else:
    o = 0
 if longitude < 0:
    o = o + 2
 if abs(longitude) >= 100: o = o + 1
 z = o % 2
 y = ((o - z)/2) % 2
 x = (o - 2*y - z)/4
#
 o = o + 1
#
 latitude = (1-2*x)*latitude
 longitude = (1-2*y)*longitude
#
 p = math.floor(latitude*60/40)
 a = (latitude*60/40-p)*40
 q = math.floor(a/5)
 u = math.floor(longitude-100*z)
 f = longitude-100*z-u
 v = math.floor(f*60/7.5)
 #
 o = int(o)
 p = int(p)
 u = int(u)
 q = int(q)
 v = int(v)
 #
 if u < 10:
    if p < 10:
      mesh = str(o)+"00"+str(p)+"0"+str(u)+str(q)+str(v)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+"0"+str(u)+str(q)+str(v)
      else:
        mesh = str(o)+str(p)+"0"+str(u)+str(q)+str(v)
 else:
    if p < 10:
      mesh =str(o)+"00"+str(p)+str(u)+str(q)+str(v)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+str(u)+str(q)+str(v)
      else:
        mesh = str(o)+str(p)+str(u)+str(q)+str(v)
 return mesh

# calculate 3rd mesh code
def cal_meshcode3(latitude, longitude):
  if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
    return "9999999999"
  if latitude < 0:
    o = 4
  else:
    o = 0
  if longitude < 0:
    o = o + 2
  if abs(longitude) >= 100:
      o = o + 1
  z = o % 2
  y = ((o - z)/2) % 2
  x = (o - 2*y - z)/4
#
  o = o + 1
#
  latitude = (1-2*x)*latitude
  longitude = (1-2*y)*longitude
  #
  p = math.floor(latitude*60/40)
  a = (latitude*60/40-p)*40
  q = math.floor(a/5)
  b = (a/5-q)*5
  r = math.floor(b*60/30)
  c = (b*60/30-r)*30
  u = math.floor(longitude-100*z)
  f = longitude-100*z-u
  v = math.floor(f*60/7.5)
  g = (f*60/7.5-v)*7.5
  w = math.floor(g*60/45)
  h = (g*60/45-w)*45
  #
  o = int(o)
  p = int(p)
  u = int(u)
  q = int(q)
  v = int(v)
  r = int(r)
  w = int(w)
  #
  if u < 10:
    if p < 10:
      mesh = str(o)+"00"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)
      else:
        mesh = str(o)+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)
  else:
    if p < 10:
      mesh = str(o)+"00"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)
    else:
      if(p < 100):
        mesh = str(o)+"0"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)
      else:
        mesh = str(o)+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)
  return mesh

# calculate 4th mesh code
def cal_meshcode4(latitude, longitude):
  if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
    return "99999999999"
  if latitude < 0:
    o = 4
  else:
    o = 0
  if longitude < 0:
    o = o + 2
  if abs(longitude) >= 100:
    o = o + 1
  z = o % 2
  y = ((o - z)/2) % 2
  x = (o - 2*y - z)/4
#
  o = o + 1
#
  latitude = (1-2*x)*latitude
  longitude = (1-2*y)*longitude
  #
  p = math.floor(latitude*60/40)
  a = (latitude*60/40-p)*40
  q = math.floor(a/5)
  b = (a/5-q)*5
  r = math.floor(b*60/30)
  c = (b*60/30-r)*30
  s2u = math.floor(c/15)
  u = math.floor(longitude-100*z)
  f = longitude-100*z-u
  v = math.floor(f*60/7.5)
  g = (f*60/7.5-v)*7.5
  w = math.floor(g*60/45)
  h = (g*60/45-w)*45
  s2l = math.floor(h/22.5)
  s2 = s2u*2+s2l+1
  #
  o = int(o)
  p = int(p)
  u = int(u)
  q = int(q)
  v = int(v)
  r = int(r)
  w = int(w)
  s2 = int(s2)
  #
  if u < 10:
    if p < 10:
      mesh = str(o)+"00"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
      else:
        mesh = str(o)+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
  else:
    if p < 10:
      mesh = str(o)+"00"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
      else:
        mesh = str(o)+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)
  return mesh

# calculate 5rd mesh code
def cal_meshcode5(latitude, longitude):
  if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
    return "999999999999"
  if latitude < 0:
    o = 4
  else:
    o = 0
  if longitude < 0:
    o = o + 2
  if abs(longitude) >= 100:
    o = o + 1
  z = o % 2
  y = ((o - z)/2) % 2
  x = (o - 2*y - z)/4
#
  o = o + 1
#
  latitude = (1-2*x)*latitude
  longitude = (1-2*y)*longitude
  #
  p = math.floor(latitude*60/40)
  a = (latitude*60/40-p)*40
  q = math.floor(a/5)
  b = (a/5-q)*5
  r = math.floor(b*60/30)
  c = (b*60/30-r)*30
  s2u = math.floor(c/15)
  d = (c/15-s2u)*15
  s4u = math.floor(d/7.5)
  u = math.floor(longitude-100*z)
  f = longitude-100*z-u
  v = math.floor(f*60/7.5)
  g = (f*60/7.5-v)*7.5
  w = math.floor(g*60/45)
  h = (g*60/45-w)*45
  s2l =math.floor(h/22.5)
  i = (h/22.5-s2l)*22.5
  s4l = math.floor(i/11.25)
  s2 = s2u*2+s2l+1
  s4 = s4u*2+s4l+1
  #
  o = int(o)
  p = int(p)
  u = int(u)
  q = int(q)
  v = int(v)
  r = int(r)
  w = int(w)
  s2 = int(s2)
  s4 = int(s4)
  #
  if u < 10:
    if p < 10:
      mesh = str(o)+"00"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
      else:
        mesh = str(o)+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
  else:
    if p < 10:
      mesh = str(o)+"00"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
    else:
      if p < 100:
        mesh = str(o)+"0"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
      else:
        mesh = str(o)+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)
  return mesh

# calculate 6rd mesh code
def cal_meshcode6(latitude, longitude):
  if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180:
      return "9999999999999"
  if latitude < 0:
    o = 4
  else:
    o = 0
  if longitude < 0:
    o = o + 2
  if abs(longitude) >= 100:
    o = o + 1
  z = o % 2
  y = ((o - z)/2) % 2
  x = (o - 2*y - z)/4
#
  o = o + 1
#
  latitude = (1-2*x)*latitude
  longitude = (1-2*y)*longitude
  #
  p = math.floor(latitude*60/40)
  a = (latitude*60/40-p)*40
  q = math.floor(math.floor(a/5))
  b = (a/5-q)*5
  r = math.floor(b*60/30)
  c = (b*60/30-r)*30
  s2u = math.floor(c/15)
  d = (c/15-s2u)*15
  s4u = math.floor(d/7.5)
  e = (d/7.5-s4u)*7.5
  s8u = math.floor(e/3.75)
  u = math.floor(longitude-100*z)
  f = longitude-100*z-u
  v = math.floor(f*60/7.5)
  g = (f*60/7.5-v)*7.5
  w = math.floor(g*60/45)
  h = (g*60/45-w)*45
  s2l = math.floor(h/22.5)
  i = (h/22.5-s2l)*22.5
  s4l = math.floor(i/11.25)
  j = (i/11.25-s4l)*11.25
  s8l = math.floor(j/5.625)
  s2 = s2u*2+s2l+1
  s4 = s4u*2+s4l+1
  s8 = s8u*2+s8l+1
  #
  o = int(o)
  p = int(p)
  u = int(u)
  q = int(q)
  v = int(v)
  r = int(r)
  w = int(w)
  s2 = int(s2)
  s4 = int(s4)
  s8 = int(s8)
  #
  if u < 10:
   if p < 10:
     mesh = str(o)+"00"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
   else:
     if p < 100:
       mesh = str(o)+"0"+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
     else:
       mesh = str(o)+str(p)+"0"+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
  else:
   if p < 10:
     mesh = str(o)+"00"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
   else:
     if p < 100:
       mesh = str(o)+"0"+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
     else:
       mesh = str(o)+str(p)+str(u)+str(q)+str(v)+str(r)+str(w)+str(s2)+str(s4)+str(s8)
  return int(mesh)
