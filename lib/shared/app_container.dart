import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/authentication/authentication_cubit.dart';
import 'package:pre_techwiz/blocs/authentication/authentication_state.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/screens/account/account.dart';
import 'package:pre_techwiz/shared/configs/routes.dart';
import 'package:pre_techwiz/models/model_notification.dart';
import 'package:pre_techwiz/screens/demo/demo1.dart';
import 'package:pre_techwiz/screens/demo/demo2.dart';
import 'package:pre_techwiz/screens/demo/demo3.dart';
import 'package:pre_techwiz/screens/demo/demo4.dart';
import 'package:pre_techwiz/screens/demo/demo5.dart';
import 'package:pre_techwiz/shared/utilities/translate.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;
  StreamSubscription? _connectivity;
  StreamSubscription? _message;
  StreamSubscription? _messageOpenedApp;
  String? _lastConnectivity;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupConnectivity();
    _setupFirebaseMessaging();
  }

  void _setupConnectivity() {
    _connectivity = Connectivity().onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
  }

  void _setupFirebaseMessaging() {
    _message = FirebaseMessaging.onMessage.listen(_notificationHandle);
    _messageOpenedApp =
        FirebaseMessaging.onMessageOpenedApp.listen(_notificationHandle);
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    if (result.isNotEmpty && _lastConnectivity != result.last.toString()) {
      _lastConnectivity = result.last.toString();
      String title = 'no_internet_connection';
      IconData icon = Icons.wifi_off;
      Color color = Colors.red;
      if (result.last != ConnectivityResult.none) {
        title = 'internet_connected';
        icon = Icons.wifi;
        color = Colors.green;
      }
      AppBloc.messageBloc.add(
        MessageEvent(
          message: title,
          icon: Icon(icon, color: color),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _message?.cancel();
    _messageOpenedApp?.cancel();
    _connectivity?.cancel();
    super.dispose();
  }

  void _notificationHandle(RemoteMessage message) {
    try {
      final notification = NotificationModel.fromJson(message);
      if (notification.target != null) {
        Navigator.pushNamed(
          context,
          notification.target!,
          arguments: notification.item,
        );
      }
    } catch (e) {
      print("Error handling notification: $e");
    }
  }

  Future<void> _onItemTapped(int index) async {
    setState(() => _isLoading = true);
    try {
      if (AppBloc.userCubit.state == null && _requireAuth(index)) {
        final result = await Navigator.pushNamed(
          context,
          Routes.signIn,
          arguments: index,
        );
        if (result != null) {
          setState(() => _selectedIndex = result as int);
        }
      } else {
        setState(() => _selectedIndex = index);
      }
    } catch (e) {
      print("Error changing tab: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _listenAuthenticateChange(
      AuthenticationState authentication) async {
    if (authentication == AuthenticationState.fail) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: _selectedIndex,
      );
      if (result != null) {
        setState(() {
          _selectedIndex = result as int;
        });
      } else {
        setState(() {
          _selectedIndex = 0;
        });
      }
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Demo1();
      case 1:
        return const Demo2();
      case 2:
        return const Demo3();
      case 3:
        return const Demo4();
      case 4:
        return const Account();
      default:
        return const Demo1();
    }
  }

  bool _requireAuth(int index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
        return false;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, authentication) async {
        await _listenAuthenticateChange(authentication);
      },
      child: Scaffold(
        body: Stack(
          children: [
            _getPage(_selectedIndex),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: Translate.of(context).translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.location_on_outlined),
              label: Translate.of(context).translate('discovery'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.featured_play_list_outlined),
              label: Translate.of(context).translate('blog'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_outline),
              label: Translate.of(context).translate('wish_list'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle_outlined),
              label: Translate.of(context).translate('account'),
            ),
          ],
          selectedFontSize: 12,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
