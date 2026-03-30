import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({required this.apiClient});

  Future<List<CategoryModel>> getCategories() async {
    try {
      return await apiClient.getCategories();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
