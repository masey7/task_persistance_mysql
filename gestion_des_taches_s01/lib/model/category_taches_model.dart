part of dartlero_category_tache;

class CategoryTachesModel extends ConceptModel {

  static final String category = 'Category';
  static final String personnel = 'Personnel';

  Map<String, ConceptEntities> newEntries() {
    var categories = new Categories();
    var personnels = new Personnels();

    var map = new Map<String, ConceptEntities>();
    map[category] = categories;
    map[personnel] = personnels;
    return map;
  }

  Categories get categories => getEntry(category);

  Personnels get personnels => getEntry(personnel);



  loadFromBD(){

    var pool = getConnectionPool();
    print("connection open");
    // create an example class

    //lire l'ensemble des personelle dans la BD


    pool.query('SELECT NOM_COMPLET, DEPARTEMENT'
        ' FROM personnel; '
        ).then((result) {
          for (var row in result){

            var personnel1 = new Personnel();
            personnel1.code = row[0];
            personnel1.departement = decodeUtf8(stringToCodepoints(row[1]));
            personnels.add(personnel1, insert:false);
          }
        }).then((x){

         print('Les membres du personnels suivant sont maintenant dans la '
                'mémoire de l\'ordinateur : ');
         int compteur = 1;

         for (var iterateurPersonnel in personnels.toList())
         {
           print("${compteur}. ${iterateurPersonnel.code} ");
           compteur = compteur + 1;
         }
    }).then((x){



      pool.query('SELECT Nom, Description'
          ' FROM categorie; '
      ).then((result) {
        for (var row in result){

          var categorie1 = new Category();
          categorie1.code = decodeUtf8(stringToCodepoints(row[0]));
          categorie1.description = decodeUtf8(stringToCodepoints(row[1]));
          categories.add(categorie1, BoolBDinsert:false);
        }
      }).then((x){

        print('Les catégories suivant sont maintenant dans la '
        'mémoire de l\'ordinateur : ');
        int compteur = 1;

        for (var iterateurCategorie in categories.toList())
        {
          print("${compteur}. ${iterateurCategorie.code} ");
          compteur = compteur + 1;
        }


    }).then((x){

      pool.query('SELECT NomTache, NomCategory, Description, Date '
          'FROM tache; ').then((result){
            for (var row in result){

            var tache1 = new Tache();
            tache1.code = decodeUtf8(stringToCodepoints(row[0]));
            var categoryTemporaire = row[1];
            tache1.description = decodeUtf8(stringToCodepoints(row[2]));
            tache1.date = row[3];

            for (var iterateurCategorie in categories.toList())
            {
              if (iterateurCategorie.code == categoryTemporaire)
              {
                tache1.category = iterateurCategorie;
                iterateurCategorie.taches.add(tache1, category:iterateurCategorie, BoolBDinsert:false);
              }
            }
            }
            print('Les taches suivantes sont maintenant dans la '
            'mémoire de l\'ordinateur : ');
            int compteur = 1;
            for (var iterateurCategorie in categories.toList())
            {
              for (var iterateurTache in iterateurCategorie.taches)
              {
                print("${compteur}. ${iterateurTache.code} dans la catégorie :  ${iterateurTache.category.code}");
                compteur = compteur + 1;
              }
            }
          });
          }
    ).then((x)
{

      pool.query('SELECT NomPersonnel, NomTache '
          'FROM personnelTache; ').then((result){
            for (var row in result){

              var NomPersonnelTemporaire = row[0];
              var NomTacheTemporaire = row[1];

              for (var iterateurCategorie in categories.toList())
              {
                for (var iterateurTache in iterateurCategorie.taches)
                {
                  if (iterateurTache.code == NomTacheTemporaire)
                  {
                    for (var iterateurPersonnel in personnels.toList())

                      if(iterateurPersonnel.code == NomPersonnelTemporaire)
                      {
                        iterateurTache.listeDePersonel.add(iterateurPersonnel, tache:iterateurTache, insert:false);
                      }
                  }
                }
              }
            }
            print('Les tachesPersonnes suivantes sont maintenant dans la '
            'mémoire de l\'ordinateur : ');
            int compteur = 1;
            for (var iterateurCategorie in categories.toList())
            {
              for (var iterateurTache in iterateurCategorie.taches)
              {
                for (var iterateurPersonnel in iterateurTache.listeDePersonel)
                {

                  print("${compteur}. ${iterateurPersonnel.code} dans la Tache :  ${iterateurTache.code}");
                  compteur = compteur + 1;

                }
              }
            }
          });
          }
    );
    }

  );

  }



  init() {

    var personnel1 = new Personnel();
    personnel1.code = 'Marie-Audrey';
    personnel1.departement = 'comptabilité';

    personnels.add(personnel1);

    var personnel2 = new Personnel();
    personnel2.code = 'Marc-Antoine Seyer';
    personnel2.departement = 'Système d\'information organisaionel';
    personnels.add(personnel2);

    var personnel3 = new Personnel();
    personnel3.code = 'Simon Cordeau';
    personnel3.departement = 'Philosophie';
    personnels.add(personnel3);

    var webCategory = new Category();
    webCategory.code = 'Études';
    webCategory.description = 'Relatif à mon MBA';
    categories.add(webCategory);

    var dartCategory = new Category();
    dartCategory.code = 'Travail';
    dartCategory.description = 'Relatif à mon emploi';
    categories.add(dartCategory);

    var plaisirCategory = new Category();
    plaisirCategory.code = 'Plaisir';
    plaisirCategory.description = 'Relatif à mon plaisir';
    categories.add(plaisirCategory);

//  Ajout d'une tâche

    var travailCoursArchitecture = new Tache();
    travailCoursArchitecture.code = 'Travail de Session';
    travailCoursArchitecture.description =
        'Travail en architecture sur cas ABC';
    travailCoursArchitecture.date = new DateTime(2013, 3, 19);

    travailCoursArchitecture.listeDePersonel.add(personnel1, tache:travailCoursArchitecture);
    travailCoursArchitecture.listeDePersonel.add(personnel2, tache:travailCoursArchitecture );

    var webCategoryTaches = webCategory.taches;
    webCategoryTaches.add(travailCoursArchitecture, category:webCategory, BoolBDinsert:true);

//  Ajout d'une tâche

    var examensArchitecture = new Tache();
    examensArchitecture.code = 'Examens de Mi-session';
    examensArchitecture.description =
        'Cet examens portera sur la méthode ADN.';
    examensArchitecture.date = new DateTime(2013, 3, 21);
    webCategoryTaches.add(examensArchitecture, category:webCategory);
    examensArchitecture.listeDePersonel.add(personnel1, tache:examensArchitecture);
    examensArchitecture.listeDePersonel.add(personnel2, tache:examensArchitecture);

//

//  Ajout d'une tâche

    var tacheDart3 = dartCategory.taches;
    var developperApplicationTachesCategory = new Tache();
    developperApplicationTachesCategory.code = 'Application Tâches';
    developperApplicationTachesCategory.description =
        'Développer une application permettant de gérer des tâches';
    developperApplicationTachesCategory.date = new DateTime(2013, 3, 30);
    tacheDart3.add(developperApplicationTachesCategory, category:dartCategory);
    developperApplicationTachesCategory.listeDePersonel.add(personnel1, tache:developperApplicationTachesCategory);
    developperApplicationTachesCategory.listeDePersonel.add(personnel2, tache:developperApplicationTachesCategory);



    var formerNouvelleRessource = new Tache();
    formerNouvelleRessource.code = 'Former nouvelle ressource';
    formerNouvelleRessource.description =
        'Former Ali, le nouveau de notre Direction.';
    formerNouvelleRessource.date = new DateTime(2013, 3, 25);
    tacheDart3.add(formerNouvelleRessource, category:dartCategory );

    formerNouvelleRessource.listeDePersonel.add(personnel1, tache:formerNouvelleRessource);
    formerNouvelleRessource.listeDePersonel.add(personnel2, tache:formerNouvelleRessource);

  }

  display() {
    print('Category Taches Model');
    print('====================');
    for (var category in categories) {
      print('  Category');
      print('  -----');
      print(category.toString());
      print('    Taches');
      print('    -----');
      for (var tache in category.taches) {
        print(tache.toString());
      }
    }
    print(
      '============= ============= ============= '
      '============= ============= ============= '
    );
  }

}
