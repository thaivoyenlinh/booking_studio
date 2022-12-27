import 'package:booking_app/src/blocs/user/user_event.dart';
import 'package:booking_app/src/blocs/user/user_state.dart';
import 'package:booking_app/src/repositories/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
 final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserLoadingState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try{
        final users = await _userRepository.getUsers();
        emit(UserLoadedState(users));
      } catch(e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}