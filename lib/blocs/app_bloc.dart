import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_techwiz/blocs/application/application_cubit.dart';
import 'package:pre_techwiz/blocs/authentication/authentication_cubit.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/blocs/user/user_cubit.dart';

class AppBloc {
  static final applicationCubit = ApplicationCubit();
  static final userCubit = UserCubit();
  static final authenticateCubit = AuthenticationCubit();
  static final messageBloc = MessageBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(
      create: (context) => applicationCubit,
    ),
    BlocProvider<AuthenticationCubit>(
      create: (context) => authenticateCubit,
    ),
    BlocProvider<UserCubit>(
      create: (context) => userCubit,
    ),
    BlocProvider<MessageBloc>(
      create: (context) => messageBloc,
    ),
  ];

  static void dispose() {
    applicationCubit.close();
    userCubit.close();
    authenticateCubit.close();
    messageBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
