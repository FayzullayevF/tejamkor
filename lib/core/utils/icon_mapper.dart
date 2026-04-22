class IconMapper {
  static String getTejamkorIcon(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('oziq-ovqat') || lowerName.contains('oziq ovqat')) {
      return "assets/icons/tejamkor_oziq-ovqat.svg";
    }
    if (lowerName.contains('kiyim') || lowerName.contains('kiyinish')) {
      return "assets/icons/tejamkor_kiyinish.svg";
    }
    if (lowerName.contains('transport')) {
      return "assets/icons/tejamkor_transport.svg";
    }
    if (lowerName.contains('taksi') || lowerName.contains('taxi')) {
      return "assets/icons/tejamkor_taksi.svg";
    }
    if (lowerName.contains('sayohat')) {
      return "assets/icons/tejamkor_sayohatlar.svg";
    }
    if (lowerName.contains('xizmatlar')) {
      return "assets/icons/tejamkor_xizmatlar.svg";
    }
    if (lowerName.contains('ish-haqi') || lowerName.contains('ish haqi')) {
      return "assets/icons/tejamkor_ish-haqi.svg";
    }
    if (lowerName.contains('sport')) {
      return "assets/icons/tejamkor_sport.svg";
    }
    if (lowerName.contains('bolalar')) {
      return "assets/icons/tejamkor_bolalar.svg";
    }
    if (lowerName.contains('pensiya')) {
      return "assets/icons/tejamkor_pensiya.svg";
    }
    if (lowerName.contains('yoqilgi')) {
      return "assets/icons/tejamkor_yoqilgi.svg";
    }
    if (lowerName.contains('kongilochar')) {
      return "assets/icons/tejamkor_kongilochar.svg";
    }
    if (lowerName.contains('mashina')) {
      return "assets/icons/tejamkor_mashina.svg";
    }
    if (lowerName.contains('otkazma')) {
      return "assets/icons/tejamkor_otkazmalar.svg";
    }
    if (lowerName.contains('ijara')) {
      return "assets/icons/tejamkor_ijara.svg";
    }
    if (lowerName.contains('omonat')) {
      return "assets/icons/tejamkor_omonatlar.svg";
    }
    if (lowerName.contains('keshbek')) {
      return "assets/icons/tejamkor_keshbek.svg";
    }
    if (lowerName.contains('kosmetika')) {
      return "assets/icons/tejamkor_kosmetika.svg";
    }
    if (lowerName.contains('avans')) {
      return "assets/icons/tejamkor_avans.svg";
    }
    if (lowerName.contains('internet')) {
      return "assets/icons/tejamkor_internet.svg";
    }
    if (lowerName.contains('oyinlar') || lowerName.contains('o\'yinlar')) {
      return "assets/icons/tejamkor_oyinlar.svg";
    }
    if (lowerName.contains('kredit')) {
      return "assets/icons/tejamkor_kredit.svg";
    }
    if (lowerName.contains('jarimalar')) {
      return "assets/icons/tejamkor_jarimalar.svg";
    }
    if (lowerName.contains('salomatlik') || lowerName.contains('sog\'liq')) {
      return "assets/icons/tejamkor_salomatlik.svg";
    }
    if (lowerName.contains('invest')) {
      return "assets/icons/tejamkor_invetitsiya.svg";
    }
    if (lowerName.contains('ovqatlanish')) {
      return "assets/icons/tejamkor_ovqatlanish.svg";
    }
    if (lowerName.contains('xayriya')) {
      return "assets/icons/tejamkor_xayriya.svg";
    }
    if (lowerName.contains('qoshimcha') || lowerName.contains('qo\'shimcha')) {
      return "assets/icons/tejamkor_qoshimcha.svg";
    }
    
    // Default fallback
    return "assets/icons/tejamkor_qoshimcha.svg";
  }
}
