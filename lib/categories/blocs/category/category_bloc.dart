import 'package:bloc/bloc.dart';
import 'package:tejamkor/categories/blocs/category/category_event.dart';
import 'package:tejamkor/categories/blocs/category/category_state.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repo;

  CategoryBloc({required CategoryRepository repo})
      : _repo = repo,
        super(CategoryState.initial()) {
    on<CategoriesFetched>(_onFetched);
  }

  Future<void> _onFetched(
    CategoriesFetched event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading, errorMessage: null));
    try {
      final categories = await _repo.getCategories();
      emit(state.copyWith(
        status: CategoryStatus.success,
        categories: categories,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
