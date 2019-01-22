import 'dart:io';

void main() async {
  print('version?');
  final version = stdin.readLineSync().trim();

  await updatePubspec(
      "built_bloc", (content) => updateVersion(content, version));
  await updatePubspec("built_bloc_generator", (content) {
    content = updateVersion(content, version);
    content = content.substring(0, content.indexOf("dependency_overrides:"));
    return updateDependency(content, "built_bloc", version);
  });

  print('Confirm publish ? (y/n)');
  if (stdin.readLineSync().trim() == 'y') {
    await publish("built_bloc");
    await publish("built_bloc_generator");
  }

  await updatePubspec("built_bloc_generator", (content) {
    return content +
        "dependency_overrides:\n  built_bloc:\n    path: ../built_bloc";
  });
}

Future updatePubspec(String folder, String update(String content)) async {
  final pubspec = File("$folder/pubspec.yaml");
  String pubspecContent;
  print("updating $pubspec...");
  pubspecContent = await pubspec.readAsString();
  pubspecContent = update.call(pubspecContent);
  await pubspec.writeAsString(pubspecContent);
}

Future publish(String folder) async {
  final result = await Process.run(
    'pub',
    ['publish', '-f'],
    workingDirectory: folder,
  );
  print(result.stdout);
  if (result.exitCode != 0) {
    print(result.stderr);
  }
}

String updateVersion(String content, String version) =>
    content.replaceAllMapped(
        RegExp("version:(\\s)*[^\\r\\n]+"), (m) => "version: $version");

String updateDependency(String content, String dependency, String version) =>
    content.replaceAllMapped(RegExp("$dependency:(\\s)*[^\\r\\n]+"),
        (m) => "$dependency: ^$version");
