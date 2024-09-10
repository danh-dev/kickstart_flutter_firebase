import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pre_techwiz/shared/app_builder.dart';
import 'package:pre_techwiz/shared/app_container.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/application/application_cubit.dart';
import 'package:pre_techwiz/blocs/application/application_state.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/shared/configs/language.dart';
import 'package:pre_techwiz/shared/configs/routes.dart';
import 'package:pre_techwiz/shared/utilities/translate.dart';

import '../screens/loading/loading.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    AppBloc.applicationCubit.onSetup();
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, application) {
          Widget container = const LoadingScreen();
          Locale language = AppLanguage.defaultLanguage;
          ThemeState theme = ThemeState.fromDefault();
          if (application is ApplicationStateSuccess) {
            theme = application.theme;
            language = application.language;
            container = const AppContainer();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            onGenerateRoute: Routes.generateRoute,
            locale: language,
            localizationsDelegates: const [
              Translate.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.supportLanguage,
            home: Scaffold(
              body: BlocListener<MessageBloc, MessageState?>(
                listener: (context, message) {
                  if (message != null && message.value.isNotEmpty) {
                    final snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: message.duration,
                      content: Row(
                        children: [
                          message.icon,
                          Expanded(
                            child: Text(
                              Translate.of(context).translate(message.value),
                            ),
                          ),
                        ],
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: container,
              ),
            ),
            builder: (context, child) {
              return AppBuilder.build(context, child);
            },
          );
        },
      ),
    );
  }
}
