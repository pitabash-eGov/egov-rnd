import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/widgets/atoms/digit_icon_button.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_components/widgets/digit_text_field.dart';
import 'package:digit_components/widgets/powered_by_digit.dart';
import 'package:digit_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../blocs/login/controllers/login_controllers.dart';
import '../../util/i18n_translations.dart';
import '../../widgets/utils/scrollable_header_widget.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  bool next = false;

  final FocusNode pinFocusNode = FocusNode();

  late LoginController loginController;
  @override
  void initState() {
    
    loginController = Get.find<LoginController>();
    loginController.passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // LoginController loginController = Get.find<LoginController>();
    final textTheme = DigitTheme.instance.mobileTheme.textTheme;
    return Scaffold(
      appBar: AppBar(
        // title: Text(AppTranslation.HOME_APP_BAR.tr),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: ScrollableContent(
        footer: const PoweredByDigit(),
        header: scrollableHeaderWidget(true, false),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // * Login Card
          DigitCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // AppTranslation.LOGIN.tr,
                  "OTP Verification",
                  style: textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Enter the otp sent to +91-${loginController.userNameController.text}",
                  style: textTheme.labelMedium,
                ),

               
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width < 720
                            ? MediaQuery.of(context).size.width - 50
                            : 350,
                        child: PinInputTextField(
                          pinLength: 6,
                          cursor: Cursor(
                            width: 2,
                            height: 20,
                            color: Colors.black,
                            radius: const Radius.circular(0.5),
                            enabled: true,
                          ),
                          decoration: BoxLooseDecoration(
                              textStyle: DigitTheme
                                  .instance.mobileTheme.textTheme.bodyLarge,
                              strokeColorBuilder: PinListenColorBuilder(
                                  DigitTheme.instance.colorScheme.primary,
                                  Colors.grey),
                              radius: Radius.zero),
                          controller: loginController.passwordController,
                          onChanged: (value) {
                            setState(() {
                              next = loginController
                                      .passwordController.text.length ==
                                  6;
                            });
                          },
                          autoFocus: true,
                          focusNode: pinFocusNode,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.phone,
                          enableInteractiveSelection: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9]+$'))
                          ],
                        ),
                      )),
                ),

                DigitIconButton(
                  //  iconText: AppTranslation.FORGOT_PASSWORD.tr,
                  iconText: "Resend OTP",
                  onPressed: () => loginController.sendOTP(context),
                ),
                // * Login Button
                Padding(
                  padding: const EdgeInsets.only(top: kPadding) * 2,
                  child: DigitElevatedButton(
                    child: Text(AppTranslation.LOGIN.tr),
                    onPressed: () => loginController.login(context),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}