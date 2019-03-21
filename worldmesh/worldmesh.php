<?php
#
# Copyright (c) 2015,2016,2017 Research Institute for World Grid Squares 
# Aki-Hiro Sato
# All rights reserved. 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# PHP fnctions to calculate the world grid square code.
# The world grid square code computed by this library is
# compatible to JIS X0410
#
# Version 1.0: Released on X February 2017
#
# Written by Dr. Aki-Hiro Sato
# Graduate School of Informatics, Kyoto University
# Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
# E-mail: aki@i.kyoto-u.ac.jp
# TEL: +81-75-753-5515
# and
# Japan Science and Technology Agency (JST)
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

function meshcode_to_latlong_grid($meshcode){
   $code = strval($meshcode);
   $ncode = strlen($code);
   if ($ncode >= 6) { # more than 1st grid
       $code0 = intval(substr($code, 0, 1)); # code0 : 1 to 8
       $code0 = $code0 - 1; # transforming code0 from 0 to 7
       $code12 = substr($code, 1, 3);
       if(strcmp(substr($code12,0,2),"00")==0){
         $code12 = intval(substr($code, 3, 1));
       }
       else{
         if(strcmp(substr($code12,0,1),"0")==0){
           $code12 = intval(substr($code, 2, 2));
         }
         else{
           $code12 = intval(substr($code, 1, 3));
         }
       }
       if(substr($code,4,1)=="0"){
         $code34 = intval(substr($code, 5, 1));
       }
       else{
         $code34 = intval(substr($code, 4, 2));
       }
       $lat_width  = 2 / 3;
       $long_width = 1;
   }
   else {
       return(NULL);
   }

if ($ncode >= 8) { # more than 2nd grid
       $code5 = intval(substr($code, 6, 1));
       $code6 = intval(substr($code, 7, 1));
       $lat_width  = $lat_width / 8;
       $long_width = $long_width / 8;
   }

   if ($ncode >= 10) { # more than 3rd grid
       $code7 = intval(substr($code, 8, 1));
       $code8 = intval(substr($code, 9, 1));
       $lat_width = $lat_width / 10;
       $long_width = $long_width / 10;
   }

   if ($ncode >= 11) { # more than 4th grid
       $code9 = intval(substr($code, 10, 1));
       $lat_width = $lat_width / 20;
       $long_width = $long_width / 20;
   }

   if ($ncode >= 12) { # more than 5th grid
       $code10 = intval(substr($code, 11, 1));
       $lat_width = $lat_width / 40;
       $long_width = $long_width / 40;
   }

   if ($ncode >= 13) { # more than 6th grid
       $code11 = intval(substr($code, 12, 1));
       $lat_width = $lat_width / 80;
       $long_width = $long_width / 80;
   }

   # 0'th grid
   $z = $code0 % 2;
   $y = (($code0 - $z)/2) % 2;
   $x = ($code0 - 2*$y - $z)/4;

   if($ncode==6){ # 1st grid
     $lat0 = ($code12-$x+1) * 2 / 3;
     $long0 = ($code34+$y) + 100*$z;
     $lat0 = (1-2*$x)*$lat0;
     $long0 = (1-2*$y)*$long0;
     $dlat = 2/3;
     $dlong = 1;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0" => floatval($lat0), "long0" => floatval($long0), "lat1" => floatval($lat1), "long1" => floatval($long1));
     return($xx);
   }
   if($ncode==8) { # 2nd grid
     $lat0 = $code12 * 2 / 3;
     $long0 = $code34 + 100*$z;
     $lat0 = $lat0  + (($code5-$x+1) * 2 / 3) / 8;
     $long0 = $long0 +  ($code6+$y) / 8;
     $lat0 = (1-2*$x) * $lat0;
     $long0 = (1-2*$y) * $long0;
     $dlat = 2/3/8;
     $dlong = 1/8;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0" => floatval($lat0), "long0" => floatval($long0), "lat1" => floatval($lat1), "long1" => floatval($long1));
     return($xx);
   }
   if($ncode==10) { # 3rd grid
#    echo $code12;
#    echo $code34;
     $lat0 = $code12 * 2 / 3;
     $long0 = $code34 + 100*$z;
     $lat0 = $lat0  + ($code5 * 2 / 3) / 8;
     $long0 = $long0 +  $code6 / 8;
     $lat0 = $lat0  + (($code7-$x+1) * 2 / 3) / 8 / 10;
     $long0 = $long0 + ($code8+$y) / 8 / 10;
     $lat0 = (1-2*$x)*$lat0;
     $long0 = (1-2*$y)*$long0;
     $dlat = 2/3/8/10;
     $dlong = 1/8/10;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0"=>floatval($lat0), "long0"=>floatval($long0), "lat1"=>floatval($lat1), "long1"=>floatval($long1));
     return($xx);
   }
   # code 9
   #     N
   #   3 | 4
   # W - + - E
   #   1 | 2
   #     S
   if($ncode==11) { # 4th grid (11 digits)
     $lat0 = $code12 * 2 / 3;
     $long0 = $code34 + 100*$z;
     $lat0 = $lat0  + ($code5 * 2 / 3) / 8;
     $long0 = $long0 +  $code6 / 8;
     $lat0 = $lat0  + (($code7-$x+1) * 2 / 3) / 8 / 10;
     $long0 = $long0 + ($code8+$y) / 8 / 10;
     $lat0 = $lat0  + (floor(($code9-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2;
     $long0 = $long0 + (($code9-1)%2-$y) / 8 / 10 / 2;
     $lat0 = (1-2*$x)*$lat0;
     $long0 = (1-2*$y)*$long0;
     $dlat = 2/3/8/10/2;
     $dlong = 1/8/10/2;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0"=>floatval($lat0), "long0"=>floatval($long0), "lat1"=>floatval($lat1), "long1"=>floatval($long1));
     return($xx);
   }
   # code 10
   #     N
   #   3 | 4
   # W - + - E
   #   1 | 2
   #     S
   if($ncode==12) { # 5th grid (12 digits)
     $lat0 = $code12 * 2 / 3;
     $long0 = $code34 + 100*$z;
     $lat0 = $lat0  + ($code5 * 2 / 3) / 8;
     $long0 = $long0 + $code6 / 8;
     $lat0 = $lat0  + (($code7-$x+1) * 2 / 3) / 8 / 10;
     $long0 = $long0 +  ($code8+$y) / 8 / 10;
     $lat0 = $lat0  + (floor(($code9-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2;
     $long0 = $long0 + (($code9-1)%2-$y) / 8 / 10 / 2;
     $lat0 = $lat0  + (floor(($code10-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2 / 2;
     $long0 = $long0 + (($code10-1)%2-$y) / 8 / 10 / 2 / 2;
     $lat0 = (1-2*$x)*$lat0;
     $long0 = (1-2*$y)*$long0;
     $dlat = 2/3/8/10/2/2;
     $dlong = 1/8/10/2/2;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0"=>floatval($lat0), "long0"=>floatval($long0), "lat1"=>floatval($lat1), "long1"=>floatval($long1));
     return($xx);
   }
   # code 11
   #     N
   #   3 | 4
   # W - + - E
   #   1 | 2
   #     S
   if($ncode==13) { # 6rd grid (13 digits)
     $lat0 = $code12 * 2 / 3;
     $long0 = $code34 + 100*$z;
     $lat0 = $lat0  + ($code5 * 2 / 3) / 8;
     $long0 = $long0 + $code6 / 8;
     $lat0 = $lat0  + (($code7-$x+1) * 2 / 3) / 8 / 10;
     $long0 = $long0 + ($code8+$y) / 8 / 10;
     $lat0 = $lat0  + (floor(($code9-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2;
     $long0 = $long0 + (($code9-1)%2-$y) / 8 / 10 / 2;
     $lat0 = $lat0  + (floor(($code10-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2 / 2;
     $long0 = $long0 + (($code10-1)%2-$y) / 8 / 10 / 2 / 2;
     $lat0 = $lat0  + (floor(($code11-1)/2)+$x-1) * 2 / 3 / 8 / 10 / 2 / 2 / 2;
     $long0 = $long0 + (($code11-1)%2-$y) / 8 / 10 / 2 / 2 / 2;
     $lat0 = (1-2*$x)*$lat0;
     $long0 = (1-2*$y)*$long0;
     $dlat = 2/3/8/10/2/2/2;
     $dlong = 1/8/10/2/2/2;
     $lat1 = sprintf("%.8f", $lat0-$dlat);
     $long1 = sprintf("%.8f", $long0+$dlong);
     $lat0 = sprintf("%.8f", $lat0);
     $long0 = sprintf("%.8f", $long0);
     $xx = array("lat0"=>floatval($lat0), "long0"=>floatval($long0), "lat1"=>floatval($lat1), "long1"=>floatval($long1));
     return($xx);
   }

   $xx = array("lat0"=>floatval(99999), "long0"=>floatval(99999), "lat1"=>floatval(99999), "long1"=>floatval(99999));
   return($xx);
}

function meshcode_to_latlong($meshcode){
    $res = meshcode_to_latlong_grid($meshcode);
    $xx = array();
    $xx["lat"] = $res["lat0"];
    $xx["long"] = $res["long0"];
    return($xx);
}

function meshcode_to_latlong_NW($meshcode){
    $res = meshcode_to_latlong_grid($meshcode);
    $xx = array();
    $xx["lat"] = $res["lat0"];
    $xx["long"] = $res["long0"];
    return($xx);
}

function meshcode_to_latlong_SW($meshcode){
    $res = meshcode_to_latlong_grid($meshcode);
    $xx = array();
    $xx["lat"] = $res["lat1"];
    $xx["long"] = $res["long0"];
    return($xx);
}

function meshcode_to_latlong_NE($meshcode){
    $res = meshcode_to_latlong_grid($meshcode);
    $xx = array();
    $xx["lat"] = $res["lat0"];
    $xx["long"] = $res["long1"];
    return($xx);
}

function meshcode_to_latlong_SE($meshcode){
    $res = meshcode_to_latlong_grid($meshcode);
    $xx = array();
    $xx["lat"] = $res["lat1"];
    $xx["long"] = $res["long1"];
    return($xx);
}

function cal_meshcode6($latitude,$longitude){
   if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
    return("999999999999");
   }
   if($latitude < 0){
     $o = 4;
   } else {
     $o = 0;
   }
   if($longitude < 0){
     $o = $o + 2;
   }
   if(abs($longitude) >= 100){
     $o = $o + 1;
   }
   $z = $o % 2;
   $y = (($o - $z)/2) % 2;
   $x = ($o - 2*$y - $z)/4;
   #
   $o = $o + 1;
   #
   $latitude = (1-2*$x)*$latitude;
   $longitude = (1-2*$y)*$longitude;
   #
   $p = floor($latitude*60/40);
   $a = ($latitude*60/40-$p)*40;
   $q = floor($a/5);
   $b = ($a/5-$q)*5;
   $r = floor($b*60/30);
   $c = ($b*60/30-$r)*30;
   $s2u = floor($c/15);
   $d = ($c/15-$s2u)*15;
   $s4u = floor($d/7.5);
   $e = ($d/7.5-$s4u)*7.5;
   $s8u = floor($e/3.75);
   $u = floor($longitude-100*$z);
   $f = $longitude-100*$z-$u;
   $v = floor($f*60/7.5);
   $g = ($f*60/7.5-$v)*7.5;
   $w = floor($g*60/45);
   $h = ($g*60/45-$w)*45;
   $s2l = floor($h/22.5);
   $i = ($h/22.5-$s2l)*22.5;
   $s4l = floor($i/11.25);
   $j = ($i/11.25-$s4l)*11.25;
   $s8l = floor($j/5.625);
   $s2 = $s2u*2+$s2l+1;
   $s4 = $s4u*2+$s4l+1;
   $s8 = $s8u*2+$s8l+1;
   #
   if($u < 10){
     if($p < 10){
       $mesh = $o."00".$p."0".$u.$q.$v.$r.$w.$s2.$s4.$s8;
     }else{
       if($p < 100){
          $mesh = $o."0".$p."0".$u.$q.$v.$r.$w.$s2.$s4.$s8;
       }
       else{
         $mesh = $o.$p."0".$u.$q.$v.$r.$w.$s2.$s4.$s8;
       }
     }
   }
   else{
     if($p < 10){
       $mesh = $o."00".$p.$u.$q.$v.$r.$w.$s2.$s4.$s8;
     }else{
       if($p < 100){
         $mesh = $o."0".$p.$u.$q.$v.$r.$w.$s2.$s4.$s8;
       }
       else{
         $mesh = $o.$p.$u.$q.$v.$r.$w.$s2.$s4.$s8;
       }
     }
   }
   return($mesh);
}
function cal_meshcode($latitude,$longitude){
    return(cal_meshcode3($latitude,$longitude));
}
function cal_meshcode1($latitude,$longitude){
    if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
      return("999999");
    }
    return(substr(cal_meshcode6($latitude,$longitude),0,6));
}
function cal_meshcode2($latitude,$longitude){
    if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
     return("99999999");
    }
    return(substr(cal_meshcode6($latitude,$longitude),0,8));
}
function cal_meshcode3($latitude,$longitude){
    if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
      return("9999999999");
    }
    return(substr(cal_meshcode6($latitude,$longitude),0,10));
}
function cal_meshcode4($latitude,$longitude){
    if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
      return("99999999999");
    }
    return(substr(cal_meshcode6($latitude,$longitude),0,11));
}
function cal_meshcode5($latitude,$longitude){
    if ($latitude < -90 or $latitude >90 or $longitude < -180 or $longitude >180){
      return("999999999999");
    }
    return(substr(cal_meshcode6($latitude,$longitude),0,12));
}
?>
