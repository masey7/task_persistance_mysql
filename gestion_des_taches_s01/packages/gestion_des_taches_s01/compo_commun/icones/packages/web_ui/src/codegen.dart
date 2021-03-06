// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/** Collects common snippets of generated code. */
library codegen;

import 'info.dart';
import 'utils.dart';

/** Header with common imports, used in every generated .dart file. */
String header(String filename, String libraryName) {
  var lib = libraryName != null ? '\nlibrary $libraryName;\n' : '';
  return """
// Auto-generated from $filename.
// DO NOT EDIT.
$lib
import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;
import 'package:web_ui/observe/observable.dart' as __observe;
""";
}

/**
 * The code that will be used to bootstrap the application, this is inlined in
 * the main.html.html output file.
 */
String bootstrapCode(String userMainImport, bool useObservers) => """
library bootstrap;

import 'package:web_ui/watcher.dart' as watcher;
import '$userMainImport' as userMain;

main() {
  watcher.useObservers = $useObservers;
  userMain.main();
  userMain.init_autogenerated();
}
""";
