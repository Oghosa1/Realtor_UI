import 'package:dio_request_inspector/dio_request_inspector.dart';

/// Compile-time flag controlling the activation of DioRequestInspector.
const bool isDioInspectorEnabled = bool.fromEnvironment(
  'ENABLE_DIO_INSPECTOR',
  defaultValue: false,
);

/// Singleton instance initialized only when [isDioInspectorEnabled] is true.
final DioRequestInspector? appDioInspector = isDioInspectorEnabled
    ? DioRequestInspector(
        isInspectorEnabled: isDioInspectorEnabled,
      )
    : null;
