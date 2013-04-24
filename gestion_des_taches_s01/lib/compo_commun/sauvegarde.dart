library ComposantesCommuns;

import 'dart:json';

import 'package:dartlero/dartlero.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';

String getConnectionOptionFileName(){
  return 'lib/compo_commun/connection.options';
}

ConnectionPool getConnectionPool() {

  OptionsFile options = new OptionsFile(getConnectionOptionFileName());
  print("Obtenir les critère de connexion");
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');
  return new ConnectionPool(
      host: host, port: port, user: user, password: password, db: db);
}