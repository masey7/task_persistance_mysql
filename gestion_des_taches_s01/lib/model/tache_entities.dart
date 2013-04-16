part of dartlero_category_tache;

class Tache extends ConceptEntity<Tache> {
  
  String description;
  DateTime date;
  Personnels listeDePersonel = new Personnels();
  Category category;

  
  Tache newEntity() => new Tache();

  String toString() {
    return '    {\n '
           '      ${super.toString()}, \n '
           '      description: ${description}\n'
           '      listeDePersonel: ${listeDePersonel}\n'
           '      date: ${date}\n'           
           '    }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    
    entityMap['description'] = description;
    entityMap['date'] = date.toString();
    entityMap['listeDePersonel'] = listeDePersonel.toJson();
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    description = entityMap['description'];
    date = DateTime.parse(entityMap['date']);
    listeDePersonel.fromJson(entityMap['listeDePersonel']);
  }

  bool get onProgramming =>
      description.contains('programming') ? true : false;

  String getDateWithZero(){
    StringBuffer dateString = new StringBuffer();

    
    //Année
    String stringAMesure = date.year.toString();
    if(stringAMesure.length == 1){
      dateString.write("0");
      dateString.write(date.year.toString());
    }
    else{
      dateString.write(date.year.toString());
    }
    dateString.write("-");
    stringAMesure = "";
    
    //Mois
    stringAMesure = date.month.toString();
    if(stringAMesure.length == 1){
      dateString.write("0");
      dateString.write(date.month.toString());
    }
    else{
      dateString.write(date.month.toString());
    }
    dateString.write("-");
    stringAMesure = "";
    
    //Jour
    stringAMesure = date.day.toString();
    if(stringAMesure.length == 1){
      dateString.write("0");
      dateString.write(date.day.toString());
    }
    else{
      dateString.write(date.day.toString());
    }
    stringAMesure = "";
    return(dateString.toString());
  }
  
}

class Taches extends ConceptEntities<Tache> {

  Taches newEntities() => new Taches();
  Tache newEntity() => new Tache();
  Category category;

  bool remove(Tache tache, {bool BoolBDRemove:true}) {
    if (super.remove(tache)) {
        if (BoolBDRemove) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'delete from tache '
              'where (categorie.Nom = '
              '\'${category.code}\')'
          ).then((x) {
            print(
                'La catégorie a été suprimé: '
                'Nom: ${category.code}, '
                'description: ${category.description}, '
            );
          }, onError:(e) => print(
              'La catégorie n\'a pas été supprimé'
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${category.code}, '
              'description: ${category.description}, '
          ));
        }
      return true;
    } else {
      print(
          'La catégorie n\'a pas été suprimé: '
          'Nom: ${category.code}, '
          'departement: ${category.description}, '
      );
      return false;
    }
  }
  
  bool add(Tache tache, {bool BoolBDinsert:true}) {
    if (super.add(category)) {
        if (BoolBDinsert) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'insert into tache '
              '(Nom, Description)'
              'values'
              '("${category.code}", "${category.description}")'
          ).then((x) {
            print(
                'La catégorie a été ajouté à la BD: '
                'Nom: ${category.code}, '
                'Description: ${category.description}, '
            );
          }, onError:(e) => print(
              'La catégorie n\'a pas été ajouté à la BD '
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${category.code}, '
              'Description: ${category.description}, '
          ));
        }
      return true;
    } else {
      print(
          'La catégorie n\'a pas été ajoutée: '
          'Nom: ${category.code}, '
          'Description: ${category.description}, '
      );
      return false;
    }
  }  
  
}

