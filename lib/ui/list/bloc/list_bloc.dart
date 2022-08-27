import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/product_reopsitory.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final IProductRepository productRepository;
  ListBloc(this.productRepository) : super(ListLoading()) {
    on<ListEvent>((event, emit) async {
      if (event is ListStarted) {
        emit(ListLoading());
        try {
          final data = await productRepository.getProducts(event.sort);
          emit(ListSuccess(
              products: data, sort: event.sort, sortName: ProductSort.names));
        } catch (e) {
          emit(ListError(AppException('خطا در دریافت اطلاعات')));
        }
      }
    });
  }
}
