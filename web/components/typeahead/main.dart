import 'package:angular2/platform/browser.dart';

import 'typeahead_demo.dart';

main() async {
  var appRef = await bootstrap(TypeaheadDemo);
  enableDebugTools(appRef);
}
