import 'dart:io';

void main(List<String> args) {
  String? type;
  String? name;
  String? fieldsStr;

  for (var arg in args) {
    if (arg.startsWith('--type=')) {
      type = arg.substring('--type='.length);
    } else if (arg.startsWith('--name=')) {
      name = arg.substring('--name='.length);
    } else if (arg.startsWith('--fields=')) {
      fieldsStr = arg.substring('--fields='.length);
    }
  }

  if (type == null || name == null) {
    print('[ERROR] Usage: dart run scaffold.dart --type=<model|repository> --name=<PascalCase> [--fields=id:String,name:String]');
    exit(1);
  }

  try {
    if (type == 'model') {
      _generateModel(name, fieldsStr);
    } else if (type == 'repository') {
      _generateRepository(name);
    } else {
      print('[ERROR] Unsupported type: $type. Supported: model, repository');
      exit(1);
    }
  } catch (e) {
    print('[ERROR] Failed to scaffold: ${e.toString()}');
    exit(1);
  }
}

String _toSnakeCase(String className) {
  return className.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
    if (match.start == 0) return match.group(0)!.toLowerCase();
    return '_${match.group(0)!.toLowerCase()}';
  });
}

void _generateModel(String name, String? fieldsStr) {
  final fileName = '${_toSnakeCase(name)}.dart';
  final dir = Directory('lib/domain/models');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  
  final file = File('${dir.path}/$fileName');

  // Parse fields
  List<Map<String, String>> fields = [];
  if (fieldsStr != null && fieldsStr.isNotEmpty) {
    final pairs = fieldsStr.split(',');
    for (var pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        fields.add({'name': parts[0].trim(), 'type': parts[1].trim()});
      }
    }
  }

  if (fields.isEmpty) {
    fields.add({'name': 'id', 'type': 'String'});
  }

  final keyField = fields.first['name']!;

  final buffer = StringBuffer();
  buffer.writeln('/// $name 도메인 모델');
  buffer.writeln('class $name {');
  
  for (var f in fields) {
    buffer.writeln('  final ${f['type']} ${f['name']};');
  }
  buffer.writeln('');
  
  buffer.writeln('  const $name({');
  for (var f in fields) {
    buffer.writeln('    required this.${f['name']},');
  }
  buffer.writeln('  });');
  buffer.writeln('');
  
  buffer.writeln('  @override');
  buffer.writeln('  String toString() => \'$name($keyField: \$$keyField)\';');
  buffer.writeln('');
  
  buffer.writeln('  @override');
  buffer.writeln('  bool operator ==(Object other) =>');
  buffer.writeln('      identical(this, other) ||');
  buffer.writeln('      other is $name &&');
  buffer.writeln('          runtimeType == other.runtimeType &&');
  buffer.writeln('          $keyField == other.$keyField;');
  buffer.writeln('');
  
  buffer.writeln('  @override');
  buffer.writeln('  int get hashCode => $keyField.hashCode;');
  buffer.writeln('');
  
  buffer.writeln('  $name copyWith({');
  for (var f in fields) {
    buffer.writeln('    ${f['type']}? ${f['name']},');
  }
  buffer.writeln('  }) {');
  buffer.writeln('    return $name(');
  for (var f in fields) {
    buffer.writeln('      ${f['name']}: ${f['name']} ?? this.${f['name']},');
  }
  buffer.writeln('    );');
  buffer.writeln('  }');
  
  buffer.writeln('}');

  file.writeAsStringSync(buffer.toString());
  print('[SUCCESS] Created ${file.path.replaceAll(r"\\", "/")}');
}

void _generateRepository(String name) {
  final snakeName = _toSnakeCase(name);
  final fileName = '${snakeName}_repository.dart';
  final dir = Directory('lib/data/repositories');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  
  final file = File('${dir.path}/$fileName');

  final buffer = StringBuffer();
  buffer.writeln('import \'package:flutter_pilot/domain/models/$snakeName.dart\';');
  buffer.writeln('');
  buffer.writeln('/// ${name}SearchResult 래퍼');
  buffer.writeln('class ${name}SearchResult {');
  buffer.writeln('  final List<$name> items;');
  buffer.writeln('  final int totalCount;');
  buffer.writeln('  const ${name}SearchResult({required this.items, required this.totalCount});');
  buffer.writeln('}');
  buffer.writeln('');
  buffer.writeln('/// $name 데이터 리포지토리 (Singleton)');
  buffer.writeln('class ${name}Repository {');
  buffer.writeln('  static final ${name}Repository _instance = ${name}Repository._internal();');
  buffer.writeln('  factory ${name}Repository() => _instance;');
  buffer.writeln('  ${name}Repository._internal() {');
  buffer.writeln('    _allItems = [];');
  buffer.writeln('  }');
  buffer.writeln('');
  buffer.writeln('  late final List<$name> _allItems;');
  buffer.writeln('');
  buffer.writeln('  ${name}SearchResult search() {');
  buffer.writeln('    return ${name}SearchResult(items: _allItems, totalCount: _allItems.length);');
  buffer.writeln('  }');
  buffer.writeln('}');

  file.writeAsStringSync(buffer.toString());
  print('[SUCCESS] Created ${file.path.replaceAll(r"\\", "/")}');
}
