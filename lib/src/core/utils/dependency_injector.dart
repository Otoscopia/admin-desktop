import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:admin/src/core/index.dart';
import 'package:admin/src/core/models/user_model.dart';

late final Logger logger;
late final Account account;
late final Databases database;
late final Storage storage;
late final Functions functions;
late final Realtime realtime;
late Map<String, dynamic> collectionIds;
late Map<String, dynamic> functionIds;
late Map<String, dynamic> storageIds;
late final Isar isar;
late final Directory appDir;
late final BaseDeviceInfo device;

class DependencyInjector {
  static final DependencyInjector _singleton = DependencyInjector._internal();

  factory DependencyInjector() {
    return _singleton;
  }

  DependencyInjector._internal();

  Future<void> init() async {
    if (!kIsWeb) {
      await loggerManager();
      logger.info("Initializing dependencies...");

      await desktopManager();
    }

    await appwriteManager();
    await isarManager();

    await deviceInfoManager();

    if (!kIsWeb) logger.info("Dependencies Initialized...");
  }

  Future<void> desktopManager() async {
    logger.info("Setting up desktop manager...");
    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
      size: Size(1000, 775),
      minimumSize: Size(1000, 775),
      title: "Otoscopia Admin",
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future<void> loggerManager() async {
    late final FileOutput fileOutput;
    const String dateTimeFormat = 'yyyy-MM-dd_HH-mm-ss';
    DateTime now = DateTime.now();
    final String fileName =
        'otoscopia-${DateFormat(dateTimeFormat).format(now)}.log';
    appDir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${appDir.path}/Otoscopia/logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final logFile = File('${logDir.path}/$fileName');
    fileOutput = FileOutput(file: logFile);

    logger = Logger(
      output: MultiOutput([ConsoleOutput(), fileOutput]),
      printer: PrettyPrinter(
        methodCount: 0,
        dateTimeFormat: DateTimeFormat.dateAndTime,
        printEmojis: false,
      ),
    );
  }

  Future<void> appwriteManager() async {
    if (!kIsWeb) logger.info("Setting up appwrite back-end connection...");

    final client = Client();
    client.setEndpoint(Env.appwriteClient).setProject(Env.appwriteProject);

    account = Account(client);
    database = Databases(client);
    storage = Storage(client);
    functions = Functions(client);
    realtime = Realtime(client);
  }

  Future<void> isarManager() async {
    const schemas = [UserModelSchema];

    if (!kIsWeb) logger.info("Setting up Isar storage...");

    if (kIsWeb) {
      await Isar.initialize();

      isar = Isar.open(
        schemas: schemas,
        directory: Isar.sqliteInMemory,
        engine: IsarEngine.sqlite,
      );
    } else {
      isar = await Isar.openAsync(
        schemas: schemas,
        directory: "${appDir.path}/Otoscopia",
        name: "Otoscopia",
      );
    }
  }

  Future<void> deviceInfoManager() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    device = await deviceInfo.deviceInfo;
  }
}

class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  final IOSink? _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  }) : _sink = file.openWrite(
         mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
         encoding: encoding,
       );

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      _sink?.writeln(line);
    }
  }

  void dispose() {
    _sink?.flush();
    _sink?.close();
  }
}
