class Images {
  static const String intro1 = "assets/images/intro_1.svg";
  static const String intro2 = "assets/images/intro_2.svg";
  static const String intro3 = "assets/images/intro_3.svg";
  static const String intro4 = "assets/images/intro_4.svg";
  static const String intro5 = "assets/images/intro_5.svg";
  static const String langVn = "assets/images/vn.png";
  static const String langEn = "assets/images/en.png";
  static const String langRu = "assets/images/ru.png";
  static const String langZh = "assets/images/zh.png";
  static const String logo = "assets/logo/logo.png";
  static const String slide = "assets/images/slide.png";
  static const String whatsapp = "assets/images/whatsapp.png";
  static const String telegram = "assets/images/telegram.png";
  static const String viber = "assets/images/viber.png";
  static const String facebook = "assets/images/facebook.png";
  static const String flickr = "assets/images/flickr.png";
  static const String google = "assets/images/google.png";
  static const String linkedin = "assets/images/linkedin.png";
  static const String pinterest = "assets/images/pinterest.png";
  static const String youtube = "assets/images/youtube.png";
  static const String twitter = "assets/images/twitter.png";
  static const String tumblr = "assets/images/tumblr.png";
  static const String instagram = "assets/images/instagram.png";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}