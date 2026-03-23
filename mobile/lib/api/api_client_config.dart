// Openapi Generator last run: : 2026-03-23T22:52:47.168363
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  additionalProperties: AdditionalProperties(
    pubName: 'api_client',
    pubAuthor: 'Riva Software',
  ),
  inputSpec: InputSpec(path: 'swagger.json'),
  generatorName: Generator.dio,
  outputDirectory: 'lib/api/generated',
)
class ApiClientConfig {}