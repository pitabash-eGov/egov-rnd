import 'package:digit_components/theme/digit_theme.dart';
import 'package:digit_components/widgets/atoms/digit_dropdown.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_components/widgets/powered_by_digit.dart';
import 'package:digit_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_tracker_app/data/hive_service.dart';
import 'package:vehicle_tracker_app/models/mdms/mdms_hive/mdms_hive_model.dart';

import '../../blocs/login/controllers/login_controllers.dart';
import '../../constants.dart';
import '../../data/secure_storage_service.dart';
import '../../router/routes.dart';
import '../../util/i18n_translations.dart';
import '../../widgets/utils/scrollable_header_widget.dart';

class CitySelectPage extends StatefulWidget {
  const CitySelectPage({super.key});

  @override
  State<CitySelectPage> createState() => _CitySelectPageState();
}

class _CitySelectPageState extends State<CitySelectPage> {
  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find<LoginController>();
    final textTheme = DigitTheme.instance.mobileTheme.textTheme;

    var data = HiveService.getMdmsData();

    List<CityHiveModel> s = data.first.cityHive;

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
                  "Please Select City",
                  style: textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Provide mobile number and validate with OTP sent to you through SMS",
                  style: textTheme.titleLarge,
                ),

                //* City Dropdown
                DigitDropdown<CityHiveModel>(
                  value: s.first,
                  label: AppTranslation.CITY.tr,
                  menuItems: s,
                  onChanged: (value) => SecureStorageService.write(
                      CITYCODE, value!.cityCode),
                  valueMapper: (value) => value.cityName,
                ),

                // * Login Button
                Padding(
                  padding: const EdgeInsets.only(top: kPadding) * 2,
                  child: DigitElevatedButton(
                    child: Text(AppTranslation.CONTINUE.tr),
                   // onPressed: () => loginController.sendOTP(context),
                    onPressed: () async {
                      final data= await SecureStorageService.read(CITYCODE);
                      if(data ==null){
                      await  SecureStorageService.write(
                      CITYCODE, s.first.cityCode);
                      Get.offAllNamed(HOME);
                      }else{
                      Get.offAllNamed(HOME);}
                      },
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
