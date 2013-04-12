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

  init() {
    
    
    var personnel1 = new Personnel();    
    personnel1.code = 'Marie';
    personnel1.departement = 'comptabilité';
    personnels.add(personnel1);    
    
    var personnel2 = new Personnel();    
    personnel2.code = 'Marc';
    personnel2.departement = 'SIO';
    personnels.add(personnel2);     
    
    
    var webCategory = new Category();
    webCategory.code = 'Etudes';
    webCategory.description = 'Relatif à mon MBA';
    categories.add(webCategory);

    var webCategoryTaches = webCategory.taches;
    var travailCoursArchitecture = new Tache();
    travailCoursArchitecture.code = 'Travail de Session';
    travailCoursArchitecture.description =
        'Travail en architecture sur cas ABC';
    travailCoursArchitecture.date = new DateTime(2013, 3, 19);
    travailCoursArchitecture.listeDePersonel.add(personnel1);
    travailCoursArchitecture.listeDePersonel.add(personnel2);   
    webCategoryTaches.add(travailCoursArchitecture);

    var examensArchitecture = new Tache();
    examensArchitecture.code = 'Examens de Mi-session';
    examensArchitecture.description =
        'Cet examens portera sur la méthode ADN.';
    examensArchitecture.date = new DateTime(2013, 3, 21);
    examensArchitecture.listeDePersonel.add(personnel1);
    examensArchitecture.listeDePersonel.add(personnel2);     
    webCategoryTaches.add(examensArchitecture);

    var dartCategory = new Category();
    dartCategory.code = 'Travail';
    dartCategory.description = 'Relatif à mon emploi';
    categories.add(dartCategory);

    var tacheDart3 = dartCategory.taches;
    var developperApplicationTachesCategory = new Tache();
    developperApplicationTachesCategory.code = 'Application Tâches';
    developperApplicationTachesCategory.description =
        'Développer une application permettant de gérer des tâches';
    developperApplicationTachesCategory.date = new DateTime(2013, 3, 30);
    developperApplicationTachesCategory.listeDePersonel.add(personnel1);
    developperApplicationTachesCategory.listeDePersonel.add(personnel2);     
    
    tacheDart3.add(developperApplicationTachesCategory);

    var formerNouvelleRessource = new Tache();
    formerNouvelleRessource.code = 'Former nouvelle ressource';
    formerNouvelleRessource.description =
        'Former Ali, le nouveau de notre Direction.';
    formerNouvelleRessource.date = new DateTime(2013, 3, 25);
    
    formerNouvelleRessource.listeDePersonel.add(personnel1);
    formerNouvelleRessource.listeDePersonel.add(personnel2);        
    tacheDart3.add(formerNouvelleRessource);
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
