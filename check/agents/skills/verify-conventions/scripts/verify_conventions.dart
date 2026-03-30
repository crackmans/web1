import 'dart:io';

void main() async {
  print('=========================================');
  print('Running Idempotency Conventions Check...');
  print('=========================================');
  bool hasError = false;
  int filesChecked = 0;

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('[Error] lib/ directory not found. Please run this script from the project root.');
    exit(1);
  }

  final files = libDir.listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  for (final file in files) {
    filesChecked++;
    final content = file.readAsStringSync();
    final relativePath = file.path.replaceAll('\\', '/');
    final fileName = file.uri.pathSegments.last;
    
    // 1. Check relative imports (warn for '../')
    if (content.contains(RegExp(r"import\s+'\.\./"))) {
      print('[Error] $relativePath: Relative import (`../`) detected. Use package import (`package:flutter_pilot/...`) instead.');
      hasError = true;
    }

    // 2. Check File Naming (must be isolated snake_case.dart)
    if (fileName != fileName.toLowerCase()) {
      print('[Error] $relativePath: File name must be lowercase snake_case.');
      hasError = true;
    }

    // 3. Domain Model checks
    if (relativePath.contains('domain/models/')) {
      if (content.contains('class ')) {
        if (!content.contains('copyWith')) {
          print('[Error] $relativePath: Domain model must implement copyWith().');
          hasError = true;
        }
        if (!content.contains('operator ==') || !content.contains('hashCode')) {
          print('[Error] $relativePath: Domain model must override == and hashCode.');
          hasError = true;
        }
        if (!content.contains('toString')) {
          print('[Error] $relativePath: Domain model must override toString().');
          hasError = true;
        }
      }
    }

    // 4. Repository checks (Singleton)
    if (relativePath.contains('repositories/') && fileName.endsWith('_repository.dart')) {
      if (!content.contains('static final') || !content.contains('_instance') || !content.contains('factory')) {
        print('[Error] $relativePath: Repository should follow the strict Singleton pattern (_instance/factory).');
        hasError = true;
      }
    }
  }

  print('Checked $filesChecked files.');

  if (hasError) {
    print('\n[RESULT] ❌ Verification FAILED.');
    print('Please fix the idempotency / convention issues above and run the check again.');
    exit(1);
  } else {
    print('\n[RESULT] ✅ Verification PASSED. All patterns match the conventions!');
    exit(0);
  }
}
