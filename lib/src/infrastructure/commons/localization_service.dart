import 'package:get/get.dart';

import '../../../generated/locales.g.dart' as generated_locales;

class LocalizationService extends Translations {
  Map<String, String> fa = {}, en = {};

  LocalizationService() {
    fa.addAll(generated_locales.Locales.fa_IR);
    en.addAll(generated_locales.Locales.en_US);
  }

  @override
  Map<String, Map<String, String>> get keys => {'fa': fa, 'en': en};
}
