import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Servidor falso con tres gastos fijos de dos categorías. No necesita el
/// backend ni el emulador.
class _Servidor implements HttpClientAdapter {
  final gastos = [
    {'id': 1, 'descripcion': 'Almuerzo', 'monto': 6.5, 'categoria': 'comida', 'fecha': '2026-10-08'},
    {'id': 2, 'descripcion': 'Taxi', 'monto': 3.25, 'categoria': 'transporte', 'fecha': '2026-10-08'},
    {'id': 3, 'descripcion': 'Cena', 'monto': 12.0, 'categoria': 'comida', 'fecha': '2026-10-09'},
  ];

  ResponseBody _json(Object cuerpo, [Map<String, List<String>> h = const {}]) =>
      ResponseBody.fromString(jsonEncode(cuerpo), 200,
          headers: {Headers.contentTypeHeader: ['application/json'], ...h});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    switch (o.path) {
      case '/usuarios/me':
        return _json({'id': 1, 'email': 'a@b.com'});
      case '/gastos/categorias':
        return _json({'categorias': ['comida', 'transporte', 'entretenimiento', 'otros'], 'limite_por_categoria': 500.0});
      case '/gastos/':
        return _json(gastos, {'x-total-count': ['${gastos.length}']});
    }
    return ResponseBody.fromString(jsonEncode({'detail': 'ruta no prevista en la prueba'}), 404,
        headers: {Headers.contentTypeHeader: ['application/json']});
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _esperar(bool Function() condicion) async {
  for (var i = 0; i < 200 && !condicion(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  testWidgets('al elegir «comida» solo se ven los gastos de comida', (tester) async {
    // Por qué: Dio y Hive hacen trabajo asíncrono real, que no avanza con el
    // reloj falso de `testWidgets`; por eso la sesión se prepara en `runAsync`.
    await tester.runAsync(() async {
      Get.reset();
      Get.testMode = true;
      await Hive.deleteFromDisk();
      FlutterSecureStorage.setMockInitialValues({'access_token': 'tok-a@b.com'});
      Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://prueba'))..httpClientAdapter = _Servidor()));
      final auth = Get.put(AuthController());
      await _esperar(() => auth.estaAutenticado);
      final gastos = Get.put(GastosController());
      await _esperar(() => gastos.gastos.length == 3 && gastos.estado.value.name == 'exito');
    });

    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('Taxi'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pump();
    expect(find.text('Taxi'), findsOneWidget);
  });
}
