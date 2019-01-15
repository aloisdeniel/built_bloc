import 'package:build/build.dart';

import 'package:built_bloc_generator/built_bloc_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder built_bloc(BuilderOptions _) => SharedPartBuilder([BlocGenerator()], 'built_bloc');