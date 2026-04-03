import 'package:dio/dio.dart';

class ErrorParser {
  static String parse(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      if (data != null && data is Map) {
        if (data.containsKey('detail')) {
          final detail = data['detail'].toString();
          if (detail.toLowerCase().contains('not found')) return "Bunday ma'lumot topilmadi.";
          if (detail.toLowerCase().contains('invalid') || detail.toLowerCase().contains('credential')) return "Noto'g'ri login yoki parol kiritdingiz.";
          return detail;
        }
        if (data.containsKey('email')) {
           final emailErr = data['email'];
           if (emailErr is List && emailErr.isNotEmpty) {
             final msg = emailErr.first.toString().toLowerCase();
             if (msg.contains('exists') || msg.contains('already') || msg.contains('mavjud')) {
               return "Siz mavjud email kiritdingiz. Boshqa email ishlating yoki ushbu hisoblga kiring.";
             }
             return emailErr.first.toString();
           }
        }
        if (data.containsKey('password')) {
           return "Siz xato formatdagi parol kiritdingiz yoki parol noto'g'ri.";
        }
        if (data.containsKey('non_field_errors')) {
           final nonField = data['non_field_errors'];
           if (nonField is List && nonField.isNotEmpty) {
             final msg = nonField.first.toString().toLowerCase();
             if (msg.contains('incorrect') || msg.contains('invalid') || msg.contains('not found')) {
               return "Kiritilgan login yoki parol noto'g'ri.";
             }
             return nonField.first.toString();
           }
        }
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
        
        // Agar nomiga mos specific error key bo'lsa oxirgi chora sifatida:
        if (data.keys.isNotEmpty) {
           final firstValue = data[data.keys.first];
           if (firstValue is List && firstValue.isNotEmpty) {
              return "${data.keys.first}: ${firstValue.first.toString()}";
           }
        }
      }

      switch (statusCode) {
        case 400:
          return "Siz kiritgan ma'lumotlarda xatolik bor (400). Iltimos qayta tekshiring.";
        case 401:
          return "Noto'g'ri login yoki parol kiritdingiz (401).";
        case 403:
          return "Sizda ushbu amalni bajarish uchun huquq yo'q (403).";
        case 404:
          return "Ma'lumot topilmadi (404).";
        case 409:
          return "Ushbu ma'lumot allaqachon mavjud (409).";
        case 500:
          return "Serverda ichki xatolik yuz berdi (500). Biz buni tez orada to'g'rilaymiz.";
        case 502:
          return "Server xatosi (Bad Gateway 502).";
        case 503:
          return "Server vaqtincha xizmat ko'rsatmayapti (503).";
        case null:
          return "Internet aloqasini tekshiring yoki server javob bermayapti.";
        default:
          return "Noma'lum server xatoligi yuz berdi ($statusCode).";
      }
    }

    return error.toString().replaceFirst("Exception: ", "");
  }
}
