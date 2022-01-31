abstract class SocialRegisterStates{}

class SocialRegisterInitalState extends SocialRegisterStates{}

class SocialRegisterLoadingState extends SocialRegisterStates{}

class SocialRegisterSuccessState extends SocialRegisterStates{
  bool isDone = false;

  SocialRegisterSuccessState(this.isDone);
}

class SocialRegisterErrorState extends SocialRegisterStates{}

class SocialRegisterChangeVisPassState extends SocialRegisterStates{}

