part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListSuccess extends ListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortName;

  const ListSuccess(
      {required this.products, required this.sort, required this.sortName});
}

class ListError extends ListState {
  final AppException appException;

  const ListError(this.appException);
}
