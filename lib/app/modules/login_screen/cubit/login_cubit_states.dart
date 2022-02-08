abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginChangeVisPassState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  bool isDone = false;

  LoginSuccessState(this.isDone);
}

class LoginErrorState extends LoginStates {}
