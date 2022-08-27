import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoginMode;
  final IAuthReposoitory authReposoitory;
  AuthBloc(this.authReposoitory, {this.isLoginMode = true})
      : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthButtonClicked) {
        emit(AuthLoading(isLoginMode));
        try {
          if (isLoginMode) {
            await authReposoitory.login(event.username, event.password);
            await cartRepository.count();
            emit(AuthSuccess(isLoginMode));
          } else {
            await authReposoitory.register(event.username, event.password);
            emit(AuthSuccess(isLoginMode));
          }
        } catch (e) {
          emit(AuthError(AppException(e.toString()), isLoginMode));
        }
      }
      if (event is AuthModeChangedClicked) {
        isLoginMode = !isLoginMode;
        emit(AuthInitial(isLoginMode));
      }
    });
  }
}
