abstract class RegisterStates{}

class RegisterInitalState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{
  bool isDone = false;

  RegisterSuccessState(this.isDone);
}

class RegisterErrorState extends RegisterStates{}

class RegisterChangeVisPassState extends RegisterStates{}

