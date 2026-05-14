import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({required this.apiClient});

  Future<List<CategoryModel>> getCategories() async {
    return await apiClient.getCategories();
  }

  Future<List<CategoryModel>> getUserCategories() async {
    return await apiClient.getUserCategories();
  }

  Future<void> selectDefaultCategories(List<int> categoryIds) async {
    await apiClient.selectDefaultCategories(categoryIds);
  }
}
