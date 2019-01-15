import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';
import 'package:built_bloc_generator/src/bloc_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

final String pkgName = 'pkg';

final Builder builder = PartBuilder([BlocGenerator()], ".g.dart");

Future<String> generate(String source) async {
  final srcs = <String, String>{
    '$pkgName|lib/example.dart': source,
  };

  final writer = InMemoryAssetWriter();
  await testBuilder(builder, srcs, rootPackage: pkgName, writer: writer);
  return String.fromCharCodes(
      writer.assets[AssetId(pkgName, 'lib/example.g.dart')] ?? []);
}

void main() {
  group('A group of tests', () {
    test('suggests to import part file', () async {
      expect(await generate('''
import 'package:built_bloc/built_bloc.dart';

part 'example.g.dart';

@bloc
abstract class _ExampleBloc extends Bloc {
  _ExampleBloc();

  // Stream examples

  // Sink examples


  @sink
  void add3(int value) {
    print("Add: \$value");
  }
}
'''), contains("1. Import generated part: part 'value.g.dart';"));
    });
  });
}