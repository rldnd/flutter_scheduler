import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scheduler/database/drift_database.dart';
import 'package:scheduler/screens/home_screen.dart';

const DEFAULT_COLORS = [
  'F44336',
  'FF9800',
  'FFEB3B',
  'FCAF50',
  '2196F3',
  '3F51B5',
  '9C27B0'
];

void main() async {
  // 플러터가 준비될 때까지 기다릴 수 있음
  // runApp 실행하기 이전에 코드를 실행하기 때문에 ( default로 실행은 됨 )
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜와 관련된 intl 사용 가능
  await initializeDateFormatting();

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(hexCode: Value(hexCode)),
      );
    }
  }

  print('----- GET COLORS --------');
  print(await database.getCategoryColors());

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen()));
}
