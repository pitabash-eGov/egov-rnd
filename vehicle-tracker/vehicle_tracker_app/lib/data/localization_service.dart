// ignore_for_file: prefer_conditional_assignment

import 'dart:developer';

import 'package:vehicle_tracker_app/data/hive_service.dart';
import 'package:vehicle_tracker_app/data/http_service.dart';
import 'package:vehicle_tracker_app/util/i18n_translations.dart';

import '../constants.dart';
import '../models/localization/localization_hive/localization_hive_model.dart';
import '../models/localization/localiztion_model/localization_model.dart';

class LocalizationService {
  static Map<String, String> englishMap = {};

  static Future<void> fetchLocalizationData() async {
    await HiveService.deleteLocalization();

    List<LocalizationHiveModel> localizationList = [];

    // Checks local storage
    var localizationHiveList = HiveService.getLocalization();
    if (localizationHiveList.isEmpty) {
      //  Call API
      log("Calling API for localization");
      final localizations = await getLocalicationFromAPI();
      if (localizations == null) {
        log("Error fetching localization from API");
        return;
      }

      // Store in local storage
      log("Storing localizations in local storage");
      localizationList = await HiveService.storeLocalization(localizations);
    } else {
      // If not empty, store in local variable
      log("Fetching localizations from local storage");
      localizationList = localizationHiveList;
    }

    // Map english localization
    englishMapper(localizationList);
  }

  static englishMapper(List<LocalizationHiveModel> localizationList) {
    for (var item in AppTranslation.englishValues.keys) {
      int index = localizationList.indexWhere((element) => element.code == item);
      if (index != -1) {
        englishMap[item] = localizationList[index].message;
      }
    }
  }

  // parse localization
  static List<LocalizationMessageModel> parseLocalization(dynamic localizations) {
    List<LocalizationMessageModel> localizationList = [];

    for (var localization in localizations) {
      localizationList.add(LocalizationMessageModel.fromJson(localization));
    }

    return localizationList;
  }

  // get localization from API
  static Future<List<LocalizationMessageModel>?> getLocalicationFromAPI() async {
    final url = "${localizationUrl}locale=en_IN&tenantId=pb&_=1683277829758";

    Map<String, dynamic> body = {
      "RequestInfo": {
        "apiId": "Rainmaker",
        "authToken": "e89ab88c-031c-482f-a950-36b278bde855",
        "msgId": "1683277829758|en_IN",
        "plainAccessRequest": {}
      }
    };

    // http request
    final response = await HttpService.postRequestWithoutToken(url, body);
    if (response.statusCode == 200) {
      final parsed = response.body["messages"] as List<dynamic>;
      final localizationList = parseLocalization(parsed);
      return localizationList;
    } else {
      log(response.statusCode.toString());
      log(response.body.toString());
      return null;
    }
  }
}
