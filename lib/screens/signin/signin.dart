import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/shared/configs/routes.dart';
import 'package:pre_techwiz/shared/utilities/common.dart';
import 'package:pre_techwiz/shared/utilities/translate.dart';
import 'package:pre_techwiz/shared/utilities/validate.dart';
import 'package:pre_techwiz/shared/widgets/app_button.dart';
import 'package:pre_techwiz/shared/widgets/my_text_input.dart';

class SignIn extends StatefulWidget {
  final dynamic from;
  const SignIn({Key? key, required this.from}) : super(key: key);

  @override
  State<SignIn> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _showPassword = false;
  String? _errorEmail;
  String? _errorPassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  void _forgotPassword() => Navigator.pushNamed(context, Routes.forgotPassword);

  ///On navigate sign up
  void _signUp() async {
    final result = await Navigator.pushNamed(context, Routes.signUp)
        as Map<String, String>?;
    if (result != null) {
      _emailController.text = result['email'] ?? '';
      _passwordController.text = result['password'] ?? '';
      _signIn();
    }
  }

  ///On login
  void _signIn() async {
    Utils.hiddenKeyboard(context);
    setState(() {
      _errorEmail = UtilValidator.validate(_emailController.text,
          type: ValidateType.email);
      _errorPassword = UtilValidator.validate(_passwordController.text);
    });
    if (_errorEmail == null && _errorPassword == null) {
      final result = await AppBloc.authenticateCubit.onLogin(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (result[0] == true) {
        AppBloc.messageBloc.add(MessageEvent(message: 'Sign In success'));
        Navigator.pop(context, widget.from);
      } else {
        if (result[1].toString().contains('User data not found')) {
          AppBloc.messageBloc.add(MessageEvent(message: 'User not found'));
        } else if (result[1]
            .toString()
            .contains('firebase_auth/invalid-credential')) {
          AppBloc.messageBloc.add(MessageEvent(message: 'Invalid credential'));
        } else {
          AppBloc.messageBloc
              .add(MessageEvent(message: 'Something went wrong'));
        }
      }
    }
  }

  Widget _buildEmailInput() {
    return MyTextInput(
      hintText: Translate.of(context).translate('email'),
      errorText: _errorEmail,
      controller: _emailController,
      focusNode: _focusEmail,
      textInputAction: TextInputAction.next,
      onChanged: (text) => setState(() {
        _errorEmail = UtilValidator.validate(text, type: ValidateType.email);
      }),
      onSubmitted: (_) =>
          Utils.fieldFocusChange(context, _focusEmail, _focusPassword),
    );
  }

  Widget _buildPasswordInput() {
    return MyTextInput(
      hintText: Translate.of(context).translate('password'),
      errorText: _errorPassword,
      textInputAction: TextInputAction.done,
      onChanged: (text) => setState(() {
        _errorPassword = UtilValidator.validate(text);
      }),
      onSubmitted: (_) => _signIn(),
      trailing: IconButton(
        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _showPassword = !_showPassword),
      ),
      obscureText: !_showPassword,
      controller: _passwordController,
      focusNode: _focusPassword,
    );
  }

  Widget _buildSignInButton() {
    return AppButton(
      Translate.of(context).translate('sign_in'),
      mainAxisSize: MainAxisSize.max,
      onPressed: _signIn,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          Translate.of(context).translate('forgot_password'),
          onPressed: _forgotPassword,
          type: ButtonType.text,
        ),
        AppButton(
          Translate.of(context).translate('sign_up'),
          onPressed: _signUp,
          type: ButtonType.text,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('sign_in')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildEmailInput(),
              const SizedBox(height: 8),
              _buildPasswordInput(),
              const SizedBox(height: 16),
              _buildSignInButton(),
              const SizedBox(height: 4),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
