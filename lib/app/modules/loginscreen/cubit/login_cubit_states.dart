abstract class SocialLoginStates {}

class SocialLoginInitState extends SocialLoginStates {}

class SocialLoginChangeVisPassState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {
  bool isDone = false;

  SocialLoginSuccessState(this.isDone);
}

class SocialLoginErrorState extends SocialLoginStates {}
