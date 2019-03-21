//
// Copyright (c) 2015-2019 Research Institute for World Grid Squares 
// Aki-Hiro Sato
// All rights reserved. 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// java class to calculate the world grid square code.
// The world grid square code computed by this library is
// compatible to JIS X0410    
//
// Version 1.0: Released on 1 January 2019
//
// Written by Dr. Aki-Hiro Sato    
// Graduate School of Informatics, Kyoto University
// and 
// Japan Science and Technology Agency (JST)
//
// Contact:
// Address: Yoshida Honmachi, Sakyo-ku, Kyoto 606-8501 Japan
// E-mail: aki@i.kyoto-u.ac.jp
// TEL: +81-75-753-5515
//
// Two types of methods are defined in this class library.
// 1. calculate representative geographical position(s) (latitude, longitude) of a grid square from a grid square code
// 2. calculate a grid square code from a geographical position (latitude, longitude)
//
// 1.
//
// meshcode_to_latlong(meshcode)
// : calculate northen western geographic position of the grid (latitude, longitude) from meshcode
// meshcode_to_latlong_NW(meshcode)
// : calculate northen western geographic position of the grid (latitude, longitude) from meshcode
// meshcode_to_latlong_SW(meshcode)
// : calculate sourthern western geographic position of the grid (latitude, longitude) from meshcode
// meshcode_to_latlong_NE(meshcode)
// : calculate northern eastern geographic position of the grid (latitude, longitude) from meshcode
// meshcode_to_latlong_SE(meshcode)
// : calculate sourthern eastern geographic position of the grid (latitude, longitude) from meshcode
// meshcode_to_latlong_grid(meshcode)
// : calculate northern western and sourthern eastern geographic positions of the grid (latitude0, longitude0, latitude1, longitude1) from meshcode
// cal_meshcode(latitude,longitude)
//
// 2.
//
// : calculate a basic (1km) grid square code (10 digits) from a geographical position (latitude, longitude)
// cal_meshcode1(latitude,longitude)
// : calculate an 80km grid square code (6 digits) from a geographical position (latitude, longitude)
// cal_meshcode2(latitude,longitude)
// : calculate a 10km grid square code (8 digits) from a geographical position (latitude, longitude)
// cal_meshcode3(latitude,longitude)
// : calculate a 1km grid square code (10 digits) from a geographical position (latitude, longitude)
// cal_meshcode4(latitude,longitude)
// : calculate a 500m grid square code (11 digits) from a geographical position (latitude, longitude)
// cal_meshcode5(latitude,longitude)
// : calculate a 250m grid square code (12 digits) from a geographical position (latitude, longitude)
// cal_meshcode6(latitude,longitude)
// : calculate a 125m grid square code (13 digits) from a geographical position (latitude, longitude)
//
// Structure of the world grid square code with compatibility to JIS X0410
// A : area code (1 digit) A takes 1 to 8
// ABBBBB : 80km grid square code (40 arc-minutes for latitude, 1 arc-degree for longitude) (6 digits)
// ABBBBBCC : 10km grid square code (5 arc-minutes for latitude, 7.5 arc-minutes for longitude) (8 digits)
// ABBBBBCCDD : 1km grid square code (30 arc-seconds for latitude, 45 arc-secondes for longitude) (10 digits)
// ABBBBBCCDDE : 500m grid square code (15 arc-seconds for latitude, 22.5 arc-seconds for longitude) (11 digits)
// ABBBBBCCDDEF : 250m grid square code (7.5 arc-seconds for latitude, 11.25 arc-seconds for longitude) (12 digits)
// ABBBBBCCDDEFG : 125m grid square code (3.75 arc-seconds for latitude, 5.625 arc-seconds for longitude) (13 digits)

//Test Code 
//class TestWorldmesh{
//    public static void main(String args[]){
//	Worldmesh res = new Worldmesh();
//	long worldmeshcode = res.cal_meshcode(34.9773063,135.7402153);
//	System.out.println("worldmeshcode = " + worldmeshcode);
//      Worldmesh wm = res.meshcode_to_latlong(worldmeshcode);
//	System.out.println("lat0 = " + wm.lat0 + ", long0 = " + wm.long0);
//	System.out.println("lat1 = " + wm.lat1 + ", long1 = " + wm.long1);
//    }
//}

class Worldmesh{
  public double lat0;
  public double long0;
  public double lat1;
  public double long1;
  public double latitude;
  public double longitude;    
  public Worldmesh meshcode_to_latlong_grid(long meshcode){
    Worldmesh wm = new Worldmesh();
    int code0,code12,code34,code5,code6,code7,code8,code9,code10,code11;
    code0=0;
    code12=0;
    code34=0;
    code5=0;
    code6=0;
    code7=0;
    code8=0;
    code9=0;
    code10=0;
    code11=0;    
    double lat_width,long_width;
    lat_width=0.0; long_width=0.0;
    double dlat,dlong;
    dlat=0.0; dlong=0.0;
    String code = String.valueOf(meshcode);
    int ncode = code.length();
    if (ncode >= 6) { // more than 1st grid
	code0 = Integer.parseInt(code.substring(0, 0+1)); // code0 : 1 to 8
	code0 = code0 - 1; // transforming code0 from 0 to 7
	String s_code12 = code.substring(1, 1+3);
	if(s_code12.substring(0,0+2)=="00"){
            code12 = Integer.parseInt(code.substring(3, 3+1));
	}else{
            if(s_code12.substring(0,0+1)=="0"){
		code12 = Integer.parseInt(code.substring(2, 2+2));
            }
            else{
		code12 = Integer.parseInt(code.substring(1, 1+3));
            }
	}
	if(code.substring(4,4+1)=="0"){
            code34 = Integer.parseInt(code.substring(5, 5+1));
	}
	else{
            code34 = Integer.parseInt(code.substring(4, 4+2));
	}
	lat_width  = 2.0 / 3.0;
	long_width = 1.0;
    }
    else {
	return(null);
    }
    if (ncode >= 8) { // more than 2nd grid
	code5 = Integer.parseInt(code.substring(6, 6+1));
	code6 = Integer.parseInt(code.substring(7, 7+1));
	lat_width  = lat_width / 8.0;
	long_width = long_width / 8.0;
    }
    if (ncode >= 10) { // more than 3rd grid
	code7 = Integer.parseInt(code.substring(8, 8+1));
	code8 = Integer.parseInt(code.substring(9, 9+1));
	lat_width = lat_width / 10.0;
	long_width = long_width / 10.0;
    }
    
    if (ncode >= 11) { // more than 4th grid
	code9 = Integer.parseInt(code.substring(10, 10+1));
	lat_width = lat_width / 20.0;
	long_width = long_width / 20.0;
    }

    if (ncode >= 12) { // more than 5th grid
	code10 = Integer.parseInt(code.substring(11, 11+1));
	lat_width = lat_width / 40.0;
	long_width = long_width / 40.0;
    }
    
    if (ncode >= 13) { // more than 6th grid
	code11 = Integer.parseInt(code.substring(12, 12+1));
	lat_width = lat_width / 80.0;
	long_width = long_width / 80.0;
    }
    
    // 0'th grid
    int z = code0 % 2;
    int y = ((code0 - z)/2) % 2;
    int x = (code0 - 2*y - z)/4;

    switch(ncode){
    case 6: // 1st grid (6 digits)
	wm.lat0 = (code12-x+1) * 2.0 / 3.0;        
	wm.long0 = Double.valueOf((code34+y) + 100*z);
	wm.lat0 = Double.valueOf(1-2*x)*wm.lat0;        
	wm.long0 = Double.valueOf(1-2*y)*wm.long0;
	dlat = 2.0/3.0;
	dlong = 1.0;
	break;
    case 8: // 2nd grid (8 digits)
	wm.lat0 = Double.valueOf(code12) * 2.0 / 3.0;
	wm.long0 = Double.valueOf(code34 + 100*z);
	wm.lat0 = wm.lat0  + (Double.valueOf(code5-x+1) * 2.0 / 3.0) / 8.0; 
	wm.long0 = wm.long0 +  Double.valueOf(code6+y) / 8.0;
	wm.lat0 = Double.valueOf(1-2*x) * wm.lat0;
	wm.long0 = Double.valueOf(1-2*y) * wm.long0;
	dlat = 2.0/3.0/8.0;
	dlong = 1.0/8.0;
	break;
    case 10: // 3rd grid (10 digits)
	wm.lat0 = Double.valueOf(code12) * 2.0 / 3.0;  
	wm.long0 = Double.valueOf(code34 + 100*z);
	wm.lat0 = wm.lat0 + (Double.valueOf(code5) * 2.0 / 3.0) / 8.0; 
	wm.long0 = wm.long0 +  Double.valueOf(code6) / 8.0;
	wm.lat0 = wm.lat0 + (Double.valueOf(code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0;
	wm.long0 = wm.long0 + Double.valueOf(code8+y) / 8.0 / 10.0;
	wm.lat0 = Double.valueOf(1-2*x)*wm.lat0;
	wm.long0 = Double.valueOf(1-2*y)*wm.long0;
	dlat = 2.0/3.0/8.0/10.0;
	dlong = 1.0/8.0/10.0;
	break;
    case 11: // 4th grid (11 digits)
	// code 9
	//     N
	//   3 | 4
	// W - + - E
	//   1 | 2
	//     S
	wm.lat0 = Double.valueOf(code12) * 2.0 / 3.0;  
	wm.long0 = Double.valueOf(code34 + 100*z);
	wm.lat0 = wm.lat0 + (Double.valueOf(code5) * 2.0 / 3.0) / 8.0; 
	wm.long0 = wm.long0 + Double.valueOf(code6) / 8.0;
	wm.lat0 = wm.lat0  + (Double.valueOf(code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0;
	wm.long0 = wm.long0 + Double.valueOf(code8+y) / 8.0 / 10.0;
	wm.lat0 = wm.lat0  + (Math.floor(Double.valueOf((code9-1)/2+x-1))) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0;
	wm.long0 = wm.long0 + Double.valueOf((code9-1)%2-y) / 8.0 / 10.0 / 2.0;
	wm.lat0 = Double.valueOf(1-2*x)*wm.lat0;
	wm.long0 = Double.valueOf(1-2*y)*wm.long0;
	dlat = 2.0/3.0/8.0/10.0/2.0;
	dlong = 1.0/8.0/10.0/2.0;
	break;
    case 12 : // 5th grid (12 digits)
	// code 10
	//     N
	//   3 | 4
	// W - + - E
	//   1 | 2
	//     S
	wm.lat0 = Double.valueOf(code12) * 2.0 / 3.0;  
	wm.long0 = Double.valueOf(code34 + 100*z);
	wm.lat0 = wm.lat0  + (Double.valueOf(code5) * 2.0 / 3.0) / 8.0; 
	wm.long0 = wm.long0 + Double.valueOf(code6) / 8.0;
	wm.lat0 = wm.lat0  + (Double.valueOf(code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0;
	wm.long0 = wm.long0 +  Double.valueOf(code8+y) / 8.0 / 10.;
	wm.lat0 = wm.lat0 + (Math.floor(Double.valueOf((code9-1)/2)+x-1)) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0;
	wm.long0 = wm.long0 + Double.valueOf((code9-1)%2-y) / 8.0 / 10.0 / 2.0;
	wm.lat0 = wm.lat0  + (Math.floor(Double.valueOf((code10-1)/2+x-1))) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0;
	wm.long0 = wm.long0 + Double.valueOf((code10-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0;
	wm.lat0 = Double.valueOf(1-2*x)*wm.lat0;
	wm.long0 = Double.valueOf(1-2*y)*wm.long0;
	dlat = 2.0/3.0/8.0/10.0/2.0/2.0;
	dlong = 1.0/8.0/10.0/2.0/2.0;
	break;
    case 13: // 6rd grid (13 digits)	
	// code 11
	//     N
	//   3 | 4
	// W - + - E
	//   1 | 2
	//     S
	wm.lat0 = Double.valueOf(code12) * 2.0 / 3.0;  
	wm.long0 = Double.valueOf(code34 + 100*z);
	wm.lat0 = wm.lat0  + (Double.valueOf(code5) * 2.0 / 3.0) / 8.0; 
	wm.long0 = wm.long0 + Double.valueOf(code6) / 8.0;
	wm.lat0 = wm.lat0  + (Double.valueOf(code7-x+1) * 2.0 / 3.0) / 8.0 / 10.0;
	wm.long0 = wm.long0 + Double.valueOf(code8+y) / 8.0 / 10.0;
	wm.lat0 = wm.lat0  + (Math.floor(Double.valueOf((code9-1)/2+x-1))) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0;
        wm.long0 = wm.long0 + Double.valueOf((code9-1)%2-y) / 8.0 / 10.0 / 2.0;
	wm.lat0 = wm.lat0 + (Math.floor(Double.valueOf((code10-1)/2+x-1))) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0;
	wm.long0 = wm.long0 + Double.valueOf((code10-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0;
	wm.lat0 = wm.lat0 + (Math.floor(Double.valueOf((code11-1)/2+x-1))) * 2.0 / 3.0 / 8.0 / 10.0 / 2.0 / 2.0 / 2.0;
	wm.long0 = wm.long0 + Double.valueOf((code11-1)%2-y) / 8.0 / 10.0 / 2.0 / 2.0 / 2.0;
	wm.lat0 = Double.valueOf(1-2*x)*wm.lat0;
	wm.long0 = Double.valueOf(1-2*y)*wm.long0;
	dlat = 2.0/3.0/8.0/10.0/2.0/2.0/2.0;
	dlong = 1.0/8.0/10.0/2.0/2.0/2.0;
    }
    wm.lat1 = wm.myformat8(wm.lat0-dlat);  
    wm.long1 = wm.myformat8(wm.long0+dlong);
    wm.lat0 = wm.myformat8(wm.lat0);  
    wm.long0 = wm.myformat8(wm.long0);
    return wm;
  }

  private double myformat8(double v){
    String s = String.format("%20.20f",v);
    String ss;
    if(v > 100.0) ss = s.substring(0,3+8);
    else if(v > 10.0) ss = s.substring(0,2+8);
    else ss = s.substring(0,1+8);
    return(Double.parseDouble(ss));
  }

  public Worldmesh meshcode_to_latlong(long meshcode){
    Worldmesh res = new Worldmesh();
    res = this.meshcode_to_latlong_grid(meshcode);
    res.latitude = res.lat0;
    res.longitude = res.long0;
    return res;    
  }

  public Worldmesh meshcode_to_latlong_NW(long meshcode){
    Worldmesh res = new Worldmesh();
    res = this.meshcode_to_latlong_grid(meshcode);
    res.latitude = res.lat0;
    res.longitude = res.long0;
    return res;
  }

  public Worldmesh meshcode_to_latlong_SW(long meshcode){
    Worldmesh res = new Worldmesh();
    res = this.meshcode_to_latlong_grid(meshcode);
    res.latitude = res.lat1;
    res.longitude = res.long0;
    return res;
  }

  public Worldmesh meshcode_to_latlong_NE(long meshcode){
    Worldmesh res = new Worldmesh();
    res = this.meshcode_to_latlong_grid(meshcode);
    res.latitude = res.lat0;
    res.longitude = res.long1;
    return res;
  }

  public Worldmesh meshcode_to_latlong_SE(long meshcode){
    Worldmesh res = new Worldmesh();
    res = this.meshcode_to_latlong_grid(meshcode);
    res.latitude = res.lat1;
    res.longitude = res.long1;
    return res;
  }

  public long cal_meshcode6(double latitude, double longitude){
    String mesh;
    int o;
    int x,y,z;
    if(latitude < 0.0){
          o = 4;
    }
    else{
          o = 0;
    }
    if(longitude < 0.0){
          o = o + 2;
    }
    if(Math.abs(longitude) >= 100.0) o = o + 1;
    z = o % 2;
    y = ((o-z)/2) % 2;
    x = (o - 2*y - z)/4;
    o = o + 1;
    latitude = Double.valueOf(1-2*x)*latitude;
    longitude = Double.valueOf(1-2*y)*longitude;
    int p = (int)Math.floor(latitude*60/40);
    double a = (latitude*60/40-p)*40;
    int q = (int)Math.floor(a/5);
    double b = (a/5-q)*5;
    int r = (int)Math.floor(b*60/30);
    double c = (b*60/30-r)*30;
    int s2u = (int)Math.floor(c/15);
    double d = (c/15-s2u)*15;
    int s4u = (int)Math.floor(d/7.5);
    double e = (d/7.5-s4u)*7.5;
    int s8u = (int)Math.floor(e/3.75);
    int u = (int)Math.floor(longitude-100*z);
    double f = longitude-100*z-u;
    int v = (int)Math.floor(f*60/7.5);
    double g = (f*60/7.5-v)*7.5;
    int w = (int)Math.floor(g*60/45);
    double h = (g*60/45-w)*45;
    int s2l = (int)Math.floor(h/22.5);
    double i = (h/22.5-s2l)*22.5;
    int s4l = (int)Math.floor(i/11.25);
    double j = (i/11.25-s4l)*11.25;
    int s8l = (int)Math.floor(j/5.625);
    int s2 = s2u*2+s2l+1;
    int s4 = s4u*2+s4l+1;
    int s8 = s8u*2+s8l+1;
    if(u < 10){
       if(p < 10){
           mesh = String.valueOf(o)+"00"+String.valueOf(p)+"0"+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
       }else{
           if(p < 100){
               mesh = String.valueOf(o)+"0"+String.valueOf(p)+"0"+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
           }
           else{
               mesh = String.valueOf(o)+String.valueOf(p)+"0"+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
           }
       }
    }else{
       if(p < 10){
            mesh = String.valueOf(o)+"00"+String.valueOf(p)+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
       }else{
           if(p < 100){
                mesh = String.valueOf(o)+"0"+String.valueOf(p)+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
           }else{
                mesh = String.valueOf(o)+String.valueOf(p)+String.valueOf(u)+String.valueOf(q)+String.valueOf(v)+String.valueOf(r)+String.valueOf(w)+String.valueOf(s2)+String.valueOf(s4)+String.valueOf(s8);
           }
       }
    }
    return(Long.parseLong(mesh));
  }
// 
  public long cal_meshcode(double latitude, double longitude){
    return(cal_meshcode3(latitude,longitude));
  }
  public long cal_meshcode1(double latitude, double longitude){
    String mesh = String.valueOf(this.cal_meshcode6(latitude,longitude));
    return(Long.parseLong(mesh.substring(0,6)));
  }
  public long cal_meshcode2(double latitude, double longitude){
    String mesh = String.valueOf(this.cal_meshcode6(latitude,longitude));
    return(Long.parseLong(mesh.substring(0,8)));
  }
  public long cal_meshcode3(double latitude, double longitude){
    String mesh = String.valueOf(this.cal_meshcode6(latitude,longitude));
    return(Long.parseLong(mesh.substring(0,10)));
}
  public long cal_meshcode4(double latitude, double longitude){
    String mesh = String.valueOf(this.cal_meshcode6(latitude,longitude));
    return(Long.parseLong(mesh.substring(0,11)));
  }
  public long cal_meshcode5(double latitude, double longitude){
    String mesh = String.valueOf(this.cal_meshcode6(latitude,longitude));
    return(Long.parseLong(mesh.substring(0,12)));
  }
}
