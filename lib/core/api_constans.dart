// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://your-api-base-url.com'; // O'z API URLingizni qo'ying
  static const String transactions = '/api/transactions/transactions/';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}