class ImageNetworks {
  static const String langVn = "https://cdn.gtranslate.net/flags/24/vi.png";
  static const String langEn = "https://cdn.gtranslate.net/flags/24/en.png";
  static const String langRu = "https://cdn.gtranslate.net/flags/24/ru.png";
  static const String langZh = "https://cdn.gtranslate.net/flags/24/zh-CN.png";

  ///Singleton factory
  static final ImageNetworks _instance = ImageNetworks._internal();

  factory ImageNetworks() {
    return _instance;
  }

  ImageNetworks._internal();
}
