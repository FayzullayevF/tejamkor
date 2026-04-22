import 'package:dio/dio.dart';
import '../models/statistics_model.dart';

class StatisticsApiSource {
  final Dio _dio;

  StatisticsApiSource(this._dio);

  Future<StatisticsModel> getStatistics({String? filterType}) async {
    try {
      final response = await _dio.get(
        '/api/more/statistics/',
        queryParameters: filterType != null ? {'filter_type': filterType} : null,
      );

      if (response.statusCode == 200) {
        return StatisticsModel.fromJson(response.data);
      } else {
        throw Exception('Statistikalarni yuklashda xatolik yuz berdi: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException error) {
    if (error.response?.data != null && error.response?.data is Map) {
      return error.response?.data['message'] ?? 'Serverda xatolik yuz berdi';
    }
    return 'Tarmoqda xatolik yuz berdi';
  }
}
