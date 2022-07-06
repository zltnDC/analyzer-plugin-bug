import 'dart:isolate';

import 'package:lint/plugin_starter.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
