# 場所情報コード（国土交通省国土地理院）対応関数
世界メッシュコード研究所が提供する場所情報コード対応関数群

https://www.fttsus.jp/worldgrids/ja/our_library

## オリジナルサイトより
国土交通省国土地理院が提案している場所情報コード（ITU-T H.642勧告に基づくucode
に準拠)から世界メッシュコードを計算するための関数群の開発を行っています。場所情
報コードの詳細については国土交通省国土地理院場所情報コードのページを参照してく
ださい。

## 対応言語
* R言語(Version 1.1 : Released on 19 December 2015)
* Javascript(Version 1.0 : Released on 11 April 2017)
* PHP(Version 1.0 : Released on 11 April 2017)
* Python(Version 1.0 : Released on 17 March 2017)

## 含まれる関数一覧
* latlong_to_ucode(latitude, longitude)
    * 位置(latitude, longitude)から場所情報コード(ITU-T H.642勧告準拠)を計算します
* extract_latlong_from_ucode(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から位置(latitude,longitude)を抽出します(0.1秒の解像度まで)
* ucode_to_meshcode(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から3次(1km)メッシュコードを計算します
* ucode_to_meshcode1(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から1次(80km)メッシュコードを計算します
* ucode_to_meshcode2(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から2次(10km)メッシュコードを計算します
* ucode_to_meshcode3(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から3次(1km)メッシュコードを計算します
* ucode_to_meshcode4(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から4次(500m)メッシュコードを計算します
* ucode_to_meshcode5(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から5次(250m)メッシュコードを計算します
* ucode_to_meshcode6(ucode)
    * 場所情報コード(ITU-T H.642勧告準拠)から6次(125m)メッシュコードを計算します