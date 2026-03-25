class Validators {
  static String? email(String? v) {
    if (v == null || v.isEmpty) return "Email kiriting";
    if (!v.contains("@")) return "Noto‘g‘ri email";
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.length < 6) return "Parol kamida 6 ta";
    return null;
  }
}
