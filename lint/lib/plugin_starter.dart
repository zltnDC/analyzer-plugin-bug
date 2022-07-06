import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:lint/src/plugin.dart';

void start(List<String> args, SendPort sendPort) {
  ServerPluginStarter(
          LintPlugin(resourceProvider: PhysicalResourceProvider.INSTANCE))
      .start(sendPort);
}
