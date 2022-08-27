part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListStarted extends ListEvent {
  final int sort;

  const ListStarted(this.sort);
  @override
  // TODO: implement props
  List<Object> get props => [sort];
}
