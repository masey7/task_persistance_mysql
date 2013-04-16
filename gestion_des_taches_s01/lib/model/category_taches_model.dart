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
    
    Completer c = new Completer();
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
    
    travailCoursArchitecture.listeDePersonel.add(personnel1);
    travailCoursArchitecture.listeDePersonel.add(personnel2);   
    
    var webCategoryTaches = webCategory.taches;
    webCategoryTaches.add(travailCoursArchitecture);

//  Ajout d'une tâche
  
    var examensArchitecture = new Tache();
    examensArchitecture.code = 'Examens de Mi-session';
    examensArchitecture.description =
        'Cet examens portera sur la méthode ADN.';
    examensArchitecture.date = new DateTime(2013, 3, 21);
    examensArchitecture.listeDePersonel.add(personnel1);
    examensArchitecture.listeDePersonel.add(personnel2);     
    webCategoryTaches.add(examensArchitecture);
//

//  Ajout d'une tâche

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
