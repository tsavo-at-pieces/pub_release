#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */



import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:settings_yaml/settings_yaml.dart';

void main(List<String> args) {
  final parser = ArgParser()..addFlag('dry-run');

  final parsed = parser.parse(args);

  final dryrun = parsed['dry-run'] as bool;

  final project = DartProject.fromPath('.');

  final pathToSettings = join(
      project.pathToProjectRoot, 'tool', 'post_release_hook', 'settings.yaml');
  final settings = SettingsYaml.load(pathToSettings: pathToSettings);
  final username = settings['username'] as String?;
  final apiToken = settings['apiToken'] as String?;
  final owner = settings['owner'] as String?;
  final repository = settings['repository'] as String?;

  if (!dryrun) {
    'github_release -u $username --apiToken $apiToken --owner $owner '
            '--repository $repository'
        .start(workingDirectory: project.pathToProjectRoot);
  } else {
    print('Skipping github_release due to --dry-run');
  }
}
