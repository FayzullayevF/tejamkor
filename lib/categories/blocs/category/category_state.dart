import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';

part 'category_state.freezed.dart';

enum CategoryStatus { idle, loading, success, error }

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState({
    required CategoryStatus status,
    required List<CategoryModel> categories,
    String? errorMessage,
  }) = _CategoryState;

  factory CategoryState.initial() {
    return const CategoryState(
      status: CategoryStatus.idle,
      categories: [],
      errorMessage: null,
    );
  }
}
