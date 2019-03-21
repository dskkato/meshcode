//
// Copyright (c) 2015 Research Institute for World Grid Squares 
// Aki-Hiro Sato
// All rights reserved. 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// javascript functions to calculate a place identification code based on ucode.
// The place identification code is based on a ucode defined in H.642
// (06/2012) recommendation by ITU-T.
// ucode is a spatial unique sequence defined by Ubiquitous ID Center
// 128 bits length unique code to define a place with a 3-m spatial resolution.
//
// Wirtten by Dr. Aki-Hiro Sato
// Graduate School of Informatics, Kyoto University
// and
// Japan Science and Technology Agency (JST) PRESTO
//
// Contact:
// Address: Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
// E-mail: aki@i.kyoto-u.ac.jp
// TEL: +81-75-753-5515
//
//
// Version 1.0 : Released on 11 December 2015
// Version 1.1 : Released on 19 December 2015
//
// latlong_to_ucode(latitude, longitude)
// : convert geographic location (latitude, longitude) into ucode
// ucode_to_meshcode(ucode)
// : calculate 1km grid square code from ucode
// ucode_to_meshcode1(ucode)
// : calculate 80km grid square code from ucode
// ucode_to_meshcode2(ucode)
// : calculate 10km grid square code from ucode
// ucode_to_meshcode3(ucode)
// : calculate 1km grid square code from ucode
// ucode_to_meshcode4(ucode)
// : calculate 500m grid square code from ucode
// ucode_to_meshcode5(ucode)
// : calculate 250m grid square code from ucode
// ucode_to_meshcode6(ucode)
// : calculate 125m grid square code from ucode
// extract_latlong_from_ucode(ucode)
// : extract geogphical location (latitude, longitude) from ucode
//
// upper 64 bits is an identification sequence to indicate
// geospatial information authority of Japan.
// This corresponds to L1 to L3 of H.642 by ITU-T.
 gsi =[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1]
 gsi16 = "00001b0000000003"

//
function dec2bin(num){
  return(num.toString(2).split(""))
}

function bin2hex(b){
  cnt = parseInt(b.length/4);
  o = "";
  for( i=0;i<cnt;i++){
    bb=b.slice(i*4,i*4+4);
    bb10=Number(bb[0])*8+Number(bb[1])*4+Number(bb[2])*2+Number(bb[3]);
    if(bb10==10){
      out="a";
    } else if(bb10==11){
      out="b";
    } else if(bb10==12){
      out="c";
    } else if(bb10==13){
      out="d";
    } else if(bb10==14){
      out="e";
    } else if(bb10==15){
      out="f";
    } else {
      out=String(bb10)
    }
    o = o+out
  }
  return(o)
}

function hex2bin(ucode){
   for(ii=0;ii<ucode.length;ii++){
      c = ucode.slice(ii,ii+1)
      if(c=="0"){
        o = [0,0,0,0]
      } else if(c=="1") {
        o = [0,0,0,1]
      } else if(c=="2") {
        o = [0,0,1,0]
      } else if(c=="3") {
        o = [0,0,1,1]
      } else if(c=="4") {
        o = [0,1,0,0]
      } else if(c=="5") {
        o = [0,1,0,1]
      } else if(c=="6") {
        o = [0,1,1,0]
      } else if(c=="7") {
        o = [0,1,1,1]
      } else if(c=="8") {
        o = [1,0,0,0]
      } else if(c=="9") {
        o = [1,0,0,1]
      } else if(c=="a") {
        o = [1,0,1,0]
      } else if(c=="b") {
        o = [1,0,1,1]
      } else if(c=="c") {
        o = [1,1,0,0]
      } else if(c=="d") {
        o = [1,1,0,1]
      } else if(c=="e") {
        o = [1,1,1,0]
      } else if(c=="f"){
        o = [1,1,1,1]
      }
      if(ii==0){
        out = o
      } else {
        out = out.concat(o)
      }
   }
   return(out)
}

function latlong_to_ucode(latitude,longitude){
   if (latitude < -90 || latitude >90 || longitude < -180 || longitude > 180){
     return("99999999999999999999999999999999");
   }
   classs = gsi.concat([0,0])
   if(latitude >= 0){
     lat2_f = 0;
   } else {
     lat2_f = 1;
   }
   if(longitude >= 0){
     long2_f = 0;
   } else {
     long2_f = 1;
   }
   lat = Math.floor(Math.abs(latitude)*60*60*10);
   long = Math.floor(Math.abs(longitude)*60*60*10);
   lat2 = dec2bin(lat);
   long2 = dec2bin(long);
   if(lat2.length < 22){
     for(kk=lat2.length;kk<22;kk++){
       lat2=[0].concat(lat2)
     }
   }
   if(long2.length < 23){
     for(kk=long2.length;kk<23;kk++){
       long2=[0].concat(long2)
     }
   }
   alt2 = [0,0]
   for(i=0;i<7;i++){
     alt2.push(0);
   }
   item2 = [0,0]
   for(i=0;i<4;i++){
     item2.push(0);
   }
   ucode=classs.concat(lat2_f);
   ucode=ucode.concat(lat2);
   ucode=ucode.concat(long2_f);
   ucode=ucode.concat(long2);
   ucode=ucode.concat(alt2);
   ucode=ucode.concat(item2);
   return(bin2hex(ucode));}

function extract_latlong_from_ucode(ucode){
   ucode = ucode.toLowerCase();
   ucode64_u = ucode.slice(0,16);
   if(ucode64_u.match(/(gsi16)/!=null)){
      console.log("this is not a place identification code\n");
      return(-1);
   }
   ucode64_l = ucode.slice(16,32);
   bb = hex2bin(ucode64_l);
   b22=[];
   for(i=21;i>=0;i--){
     b22.push(Math.pow(2,i));
   }
   lat2_f = bb[2];
   lat2 = bb.slice(3,25);
   lat=0
   for(i=0;i<22;i++){
     lat+=Number(lat2[i])*b22[i]/60/60*0.1;
   }
   if(lat2_f == 1){
     lat = -lat;
   }
   b23=[];
   for(i=22;i>=0;i--){
     b23.push(Math.pow(2,i));
   }
   long2_f = bb[25];
   long2 = bb.slice(26,49);
   long=0;
   for(i=0;i<23;i++){
     long+=Number(long2[i])*b23[i]/60/60*0.1;
   }
   if(long2_f == 1){
     long = -long;
   }
   res={"latitude":lat,"longitude":long};
   return res;
}

function ucode_to_meshcode1(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode1(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode2(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode2(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode3(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode3(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode4(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode4(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode5(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode5(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode6(ucode){
   ucode = ucode.toLowerCase();
   gp = extract_latlong_from_ucode(ucode);
   return(cal_meshcode6(parseFloat(gp["latitude"]),parseFloat(gp["longitude"])));
}

function ucode_to_meshcode(ucode){
   return(ucode_to_meshcode3(ucode))
}
