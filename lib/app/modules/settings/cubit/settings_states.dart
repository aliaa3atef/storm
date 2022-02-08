abstract class SettingCubitStates {}

class SettingCubitInitState extends SettingCubitStates{}

class SettingCubitChangeThemeState extends SettingCubitStates{}

class SettingGetUserLoadingState extends SettingCubitStates{}

class SettingGetUserSuccessState extends SettingCubitStates{}

class SettingGetUserErrorState extends SettingCubitStates{
  final String error;

  SettingGetUserErrorState(this.error);
}


