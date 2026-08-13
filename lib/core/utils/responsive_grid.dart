import 'package:flutter/widgets.dart';

/// Ekran genişliğine göre bir büyütme katsayısı döner. Poster grid'leri
/// dışında (yana kayan "gündem" şeritleri, arama sonucu listesi vb.)
/// posterleri orantılı büyütmek için de kullanılır.
///
/// Sabit piksel boyutları masaüstünde pencere büyütüldüğünde aynı kalır;
/// bu da geniş ekranlarda posterlerin gereğinden küçük görünmesine ve
/// altta/sağda boşluk kalmasına yol açar. Bu fonksiyon genişlik arttıkça
/// ölçeği de artırır.
double posterScaleFactor(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return switch (width) {
    >= 1920 => 2.0,
    >= 1600 => 1.8,
    >= 1200 => 1.55,
    >= 900 => 1.3,
    >= 600 => 1.15,
    _ => 1.0,
  };
}

/// Yana kayan poster şeritleri (Tamamlandı/Favoriler önizlemesi, Keşfet
/// gündem şeridi) için [posterScaleFactor]'a göre daha ölçülü bir büyüme
/// katsayısı döner. Bu şeritler [posterScaleFactor] ile birebir
/// büyütülünce PC'de gereğinden fazla büyüyüp altındaki içeriği aşağı
/// itiyordu; büyümenin yaklaşık %60'ı kadarı uygulanır.
double posterStripScaleFactor(BuildContext context) {
  final rawScale = posterScaleFactor(context);
  return 1 + (rawScale - 1) * 0.6;
}

/// Poster grid'lerinde (kütüphane, tamamlandı/favoriler sekmesi, keşfet
/// grid'i vb.) kullanılan
/// `SliverGridDelegateWithMaxCrossAxisExtent.maxCrossAxisExtent` değerini
/// ekran genişliğine göre hesaplar.
///
/// Sabit bir değer (ör. 120) kullanıldığında masaüstünde pencere
/// büyütüldüğünde sadece sütun sayısı artar, kartlar aynı küçük boyutta
/// kalır. Bu fonksiyon genişlik arttıkça posterlerin de büyümesini sağlar.
double responsivePosterExtent(
  BuildContext context, {
  double base = 120,
}) {
  return base * posterScaleFactor(context);
}