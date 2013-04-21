part of dartlero_category_tache;

class Tache extends ConceptEntity<Tache> {
  
  String _description;
  DateTime _date;
  Personnels listeDePersonel = new Personnels();
  Category category;

  set description(description){
    
    var oldDescription = _description;
    _description = description;
    
    if(oldDescription != null)
    {
    ConnectionPool pool = getConnectionPool();
    pool.query(
        'update tache '
        'SET '
        'Description = \'${codepointsToString(encodeUtf8(this.description))}\' '
        'where '
        '(NomTache = \'${codepointsToString(encodeUtf8(this.code))}\')'
    ).then((x) {
      print(
          'La description de la tache a été modifié: '
          'Nom: ${this.code}, '
          'description: ${this.description}, '
      );
    }, onError:(e) => print(
        'La description de la tache n\'a pas été modifié'
        'Une erreur a été rencontré : ${e} -- '
        'Nom: ${this.code}, '
        'description: ${this.description}, '
    ));   
    }    
    
  }
  
  String get description => _description;
  
  set date(date){
    
    var oldDate = _date;    
    _date = date;
    if(oldDate != null)
    {
    ConnectionPool pool = getConnectionPool();
    pool.query(
        'update tache '
        'SET '
        'Date = \'${this.getDateWithZero()}\' '
        'where '
        '(NomTache = \'${codepointsToString(encodeUtf8(this.code))}\')'
    ).then((x) {
      print(
          'La date de la tache a été modifiée: '
          'Nom: ${this.code}, '
          'Date: ${this.getDateWithZero()}, '
      );
    }, onError:(e) => print(
        'La date de la tache n\'a pas été modifiée'
        'Une erreur a été rencontré : ${e} -- '
        'Nom: ${this.code}, '
        'Date: ${this.getDateWithZero()}, '
    ));   
    }    
    
  }
  
  DateTime get date => _date;
  
  
  
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

  bool remove(Tache tache, {Category category, bool BoolBDRemove:true}) {
    if (super.remove(tache)) {
        if (BoolBDRemove && ?category) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'delete from tache '
              'where (tache.NomTache = \'${codepointsToString(encodeUtf8(tache.code))}\' and '
              'tache.NomCategory = \'${codepointsToString(encodeUtf8(category.code))}\')'
          ).then((x) {
            print(
                'La tache a été suprimé: '
                'Nom: ${tache.code}, '
                'description: ${tache.description}, '
            );
          }, onError:(e) => print(
              'La tache n\'a pas été supprimé'
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${tache.code}, '
              'description: ${tache.description}, '
          ));
        }
      return true;
    } else {
      print(
          'La tache n\'a pas été suprimé: '
          'Nom: ${tache.code}, '
          'description: ${tache.description}, '
      );
      return false;
    }
  }
  
  bool add(Tache tache, {Category category, bool BoolBDinsert:true}) {
    if (super.add(tache)) {
        if (BoolBDinsert && ?category) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'insert into tache '
              '(NomTache, NomCategory, Description, Date)'
              'values'
              '("${codepointsToString(encodeUtf8(tache.code))}", "${codepointsToString(encodeUtf8(category.code))}", "${codepointsToString(encodeUtf8(tache.description))}",'
              ' "${tache.getDateWithZero()}")'
          ).then((x) {
            print(
                'La tache a été ajouté à la BD: '
                'Nom: ${tache.code}, '
                'Description: ${tache.description}, '
                'Date : ${tache.getDateWithZero()}'
            );
          }, onError:(e) => print(
              'La tache n\'a pas été ajouté à la BD '
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${tache.code}, '
              'Description: ${tache.description}, '
          ));
        }
      return true;
    } else {
      print(
          'La tache n\'a pas été ajoutée: '
          'Nom: ${tache.code}, '
          'Description: ${tache.description}, '
      );
      return false;
    }
  }  
  
}

