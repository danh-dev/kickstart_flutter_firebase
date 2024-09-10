import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/models/model_gps.dart';
import 'package:pre_techwiz/shared/utilities/common.dart';
import 'package:pre_techwiz/shared/utilities/translate.dart';
import 'package:pre_techwiz/shared/utilities/validate.dart';
import 'package:pre_techwiz/shared/widgets/app_button.dart';
import 'package:pre_techwiz/shared/widgets/my_text_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _textNameController = TextEditingController();
  final _textPassController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _focusName = FocusNode();
  final _focusPass = FocusNode();
  final _focusEmail = FocusNode();
  final _focusAddress = FocusNode();

  bool _showPassword = false;
  String? _errorName;
  String? _errorPass;
  String? _errorEmail;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textNameController.dispose();
    _textPassController.dispose();
    _textEmailController.dispose();
    _textAddressController.dispose();
    _focusName.dispose();
    _focusPass.dispose();
    _focusEmail.dispose();
    _focusAddress.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarFile = File(image.path);
      });
    }
  }

  Future _getCurrLocation() async {
    GPSModel? location = await Utils.getLocations();
    List<Placemark>? placers = await placemarkFromCoordinates(
      location!.latitude,
      location.longitude,
    );
    _textAddressController.text =
        '${placers[0].subThoroughfare} ${placers[0].thoroughfare}, ${placers[0].locality}, ${placers[0].administrativeArea}, ${placers[0].country}';
  }

  ///On sign up
  void _signUp() async {
    Utils.hiddenKeyboard(context);
    setState(() {
      _errorName = UtilValidator.validate(_textNameController.text);
      _errorPass = UtilValidator.validate(_textPassController.text);
      _errorEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
    });
    if (_errorName == null && _errorPass == null && _errorEmail == null) {
      final result = await AppBloc.authenticateCubit.onRegister(
        name: _textNameController.text,
        email: _textEmailController.text,
        password: _textPassController.text,
        address: _textAddressController.text,
        avatarFile: _avatarFile,
      );

      if (!mounted) return;

      if (result[0] == true) {
        Navigator.pop(context);
        AppBloc.messageBloc.add(MessageEvent(message: 'Sign Up success'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result[1] as String)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('sign_up'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('Avatar'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _avatarFile != null ? FileImage(_avatarFile!) : null,
                      child: _avatarFile == null
                          ? const Icon(Icons.add_photo_alternate, size: 40)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                MyTextInput(
                  hintText: Translate.of(context).translate('input_email'),
                  labelText: Translate.of(context).translate('email'),
                  errorText: _errorEmail,
                  focusNode: _focusEmail,
                  onSubmitted: (text) {
                    _signUp();
                  },
                  onChanged: (text) {
                    setState(() {
                      _errorEmail = UtilValidator.validate(
                        _textEmailController.text,
                        type: ValidateType.email,
                      );
                    });
                  },
                  controller: _textEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                MyTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  labelText: Translate.of(context).translate('password'),
                  errorText: _errorPass,
                  onChanged: (text) {
                    setState(() {
                      _errorPass = UtilValidator.validate(
                        _textPassController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    Utils.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusEmail,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: !_showPassword,
                  controller: _textPassController,
                  focusNode: _focusPass,
                ),
                MyTextInput(
                  hintText: Translate.of(context).translate('full_name'),
                  labelText: Translate.of(context).translate('full_name'),
                  errorText: _errorName,
                  controller: _textNameController,
                  focusNode: _focusName,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _errorName =
                          UtilValidator.validate(_textNameController.text);
                    });
                  },
                  onSubmitted: (text) {
                    Utils.fieldFocusChange(context, _focusName, _focusEmail);
                  },
                ),
                MyTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_address',
                  ),
                  labelText: Translate.of(context).translate('address'),
                  onSubmitted: (text) {
                    Utils.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusEmail,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      setState(() {
                        _getCurrLocation();
                      });
                    },
                    child: const Icon(Icons.location_on),
                  ),
                  controller: _textAddressController,
                  focusNode: _focusAddress,
                ),
                const SizedBox(height: 16),
                AppButton(
                  Translate.of(context).translate('sign_up'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _signUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
