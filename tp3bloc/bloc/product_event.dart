import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class FetchProductDetail extends ProductEvent {
  final int id;

  const FetchProductDetail(this.id);

  @override
  List<Object> get props => [id];
}
