import 'dart:json';
import 'package:dartlero/dartlero.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'dart:async';
import 'package:gestion_des_taches_s01/dartlero_categorie_taches.dart';


class Example {
  ConnectionPool pool;
  CategoryTachesModel categoryTachesModel;

  Example(this.pool);

  Future createdb() {
    var completer = new Completer();
    // create tables
    createTables().then((x) {
      print("created tables");
      // add some data
      return addData();
    }).then((x) {
      // and read it back out
      return readData();
    }).then((x) {
      completer.complete(null);
    });
    return completer.future;
  }

  Future run() {
    var completer = new Completer();
    // drop the tables if they already exist
    dropTables().then((x) {
      print("dropped tables");
      // then recreate the tables
      return createTables();
    }).then((x) {
      print("created tables");


      // add some data
      return addData();
    }).then((x) {
      // and read it back out
      return readData();
    }).then((x) {
      completer.complete(null);
    });
    return completer.future;
  }

  Future dropTables() {
    print("dropping tables");
    var dropper = new TableDropper(pool, ['personnelTache', 'tache', 'personnel', 'categorie']);
    return dropper.dropTables();
  }

  Future createTables() {
    print("Création des tables pour 'Gestion des Taches'");
    var querier = new QueryRunner(pool, ['CREATE  TABLE `personnel` ('
                                        '  `NOM_COMPLET` VARCHAR(45) NOT NULL ,'
                                        '  `DEPARTEMENT` VARCHAR(45) DEFAULT NULL ,'
                                        '  PRIMARY KEY (`NOM_COMPLET`) ,'
                                        '  UNIQUE KEY `new_tablecol_UNIQUE` (`NOM_COMPLET`) );' ,

                                        'CREATE  TABLE `categorie` ('
                                        '  `Nom` VARCHAR(45) NOT NULL , '
                                        '  `Description` VARCHAR(45) DEFAULT NULL , '
                                        '  PRIMARY KEY (`Nom`) , '
                                        '  UNIQUE KEY `Nom_UNIQUE` (`Nom`) );'  ,

                                        'CREATE TABLE `tache` ('
                                        '    `NomTache` varchar(45) NOT NULL, '
                                        '    `NomCategory` varchar(45) DEFAULT NULL, '
                                        '    `Description` varchar(200) DEFAULT NULL, '
                                        '    `Date` datetime DEFAULT NULL, '
                                        '   PRIMARY KEY (`NomTache`), '
                                        '   KEY `NomCategory_idx` (`NomCategory`), '
                                        '   CONSTRAINT `NomCategory` FOREIGN KEY (`NomCategory`) REFERENCES `categorie` (`Nom`) ON DELETE NO ACTION ON UPDATE NO ACTION'
                                        '); ' ,

                                        'CREATE TABLE `personnelTache` ('
                                        '    `NomPersonnel` varchar(45) NOT NULL, '
                                        '    `NomTache` varchar(45) NOT NULL, '
                                        '    PRIMARY KEY (`NomPersonnel`, `NomTache`), '
                                        '    KEY `NomPersonnel_idx` (`NomPersonnel`), '
                                        '    KEY `NomTache_idx` (`NomTache`), '
                                        '    CONSTRAINT `tache` FOREIGN KEY (`NomTache`) REFERENCES `tache` (`NomTache`) ON DELETE NO ACTION ON UPDATE NO ACTION, '
                                        '    CONSTRAINT `personne` FOREIGN KEY (`NomPersonnel`) REFERENCES `personnel` (`NOM_COMPLET`) ON DELETE NO ACTION ON UPDATE NO ACTION); '

  ]);

    print("executing queries");
    return querier.executeQueries();
  }

  Future addData() {


    var categoryTachesModel = new CategoryTachesModel();
    categoryTachesModel.init();

    var completer = new Completer();
    completer.complete(null);

    return completer.future;
  }

  Future readData() {
    var completer = new Completer();
    completer.complete(null);

    return completer.future;
  }
}

void main() {

  OptionsFile options = new OptionsFile('lib/compo_commun/connection.options');

  //lire les données du fichier de connexion
  String user = options.getString('user');
  String password = options.getString('password');
  int port = options.getInt('port', 3306);  //Prendre le port 3306 si aucun pour n'
                                            //n'est configuré
  String db = options.getString('db');
  String host = options.getString('host', 'localhost');  //Predre localhost si aucun
                                                         //host n'est configuré


  // create a connection
  print("opening connection");
  var pool = new ConnectionPool(host: host, port: port, user: user, password: password, db: db);
  print("connection open");
  // create an example class

  var example = new Example(pool);

  // create db
  /*
  print("running example");
  example.createdb().then((x) {
    // finally, close the connection
    print("traitement (createdb) exécuté!");
    pool.close();
  });
  */

  // run the example
  print("running example");
  example.run().then((x) {
    // finally, close the connection
    print("traitement exécuté!");
    pool.close();
  });
}
