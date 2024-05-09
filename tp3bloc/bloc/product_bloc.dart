import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productRepository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<FetchProductDetail>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await productRepository.fetchProductDetail(event.id);
        emit(ProductDetailLoaded(product));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
