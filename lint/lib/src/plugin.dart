import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;

class LintPlugin extends ServerPlugin {
  LintPlugin({required super.resourceProvider});

  List<String> _contexts = [];
  List<String> _history = [];

  @override
  Future<void> afterNewContextCollection({
    required AnalysisContextCollection contextCollection,
  }) {
    _contexts.addAll(contextCollection.contexts.map((e) {
      return [e.contextRoot.optionsFile?.path.toString() ?? '-'].join(',');
    }));

    return super
        .afterNewContextCollection(contextCollection: contextCollection);
  }

  @override
  Future<void> analyzeFile(
      {required AnalysisContext analysisContext, required String path}) async {
    if (path.endsWith('test_function2.dart')) {
      final info = [
        'hashCode: $hashCode',
        'contexts: $_contexts',
        'analysisContext.contextRoot.root.path: ${analysisContext.contextRoot.root.path}',
        'analysisContext.contextRoot.optionsFile?.path ${analysisContext.contextRoot.optionsFile?.path}',
        'path: $path',
        'analysisContext.contextRoot.includedPaths: ${analysisContext.contextRoot.includedPaths.join(',')}\n',
      ];

      final message = info.join('\n');
      _history.add(message);

      channel.sendNotification(
        plugin.AnalysisErrorsParams(path, [
          AnalysisError(
            AnalysisErrorSeverity.INFO,
            AnalysisErrorType.STATIC_TYPE_WARNING,
            Location(path, 1, 1, 1, 1),
            _history.take(10).join('\n'),
            'code',
          )
        ]).toNotification(),
      );
    }
  }

  @override
  List<String> get fileGlobsToAnalyze => ['*.dart'];

  @override
  String get name => 'name';

  @override
  String get version => '1.0.0';
}
