# World mesh code
[世界メッシュ研究所](https://www.fttsus.jp/worldgrids/en/library/)が公開しているライブラリのコピーです。
最新の情報は上記のサイトで確認してください。

## 対応言語
* R言語 (Version 1.4 : Released on 19 December 2015)
* Javascript (Version 1.01 : Released on 6 February 2017)
* PHP (Version 1.0 : Released on 7 February 2017)
* Python (Version 1.2 : Released on 10 December 2018)
* Java (Version 1.0 : Released on 1 January 2019)

## 含まれる関数一覧
* meshcode_to_latlong(meshcode)
    * メッシュコードmeshcodeからメッシュ北西端の位置(latitude,longitude)を計算します
* meshcode_to_latlong_NW(meshcode)
    * メッシュコードmeshcodeからメッシュ北西端の位置(latitude,longitude)を計算します
* meshcode_to_latlong_SW(meshcode)
    * メッシュコードmeshcodeからメッシュ南西端の位置(latitude, longitude)を計算します
* meshcode_to_latlong_NE(meshcode)
    * メッシュコードmeshcodeからメッシュ北東端の位置(latitude, longitude)を計算します
* meshcode_to_latlong_SE(meshcode)
    * メッシュコードmeshcodeからメッシュ南東端の位置(latitude, longitude)を計算します
* meshcode_to_latlong_grid(meshcode)
    * メッシュコードmeshcodeからメッシュの四隅に対応する緯度と経度(latitude0, longitude0, latitude1, longitude1)を計算します
* cal_meshcode(latitude,longitude)
    * 位置(latitude,longitude)から3次(1km)メッシュコードを計算します
* cal_meshcode1(latitude,longitude)
    * 位置(latitude,longitude)から1次(80km)メッシュコードを計算します
* cal_meshcode2(latitude,longitude)
    * 位置(latitude,longitude)から2次(10km)メッシュコードを計算します
* cal_meshcode3(latitude,longitude)
    * 位置(latitude,longitude)から3次(1km)メッシュコードを計算します
* cal_meshcode4(latitude,longitude)
    * 位置(latitude,longitude)から4次(500m)メッシュコードを計算します
* cal_meshcode5(latitude,longitude)
    * 位置(latitude,longitude)から5次(250m)メッシュコードを計算します
* cal_meshcode6(latitude,longitude)
    * 位置(latitude,longitude)から6次(125m)メッシュコードを計算します