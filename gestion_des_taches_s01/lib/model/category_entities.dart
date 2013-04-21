part of dartlero_category_tache;

class Category extends ConceptEntity<Category> {

  String _description;
  Taches taches = new Taches();

  Category newEntity() => new Category();

  String get description => _description;

  set description(String description) {
    var oldDescription = _description;
    _description = description;
    
    if(oldDescription != null)
    {
    ConnectionPool pool = getConnectionPool();
    pool.query(
        'update categorie '
        'SET '
        'Description = \'${codepointsToString(encodeUtf8(this.description))}\' '
        'where '
        '(Nom = \'${codepointsToString(encodeUtf8(this.code))}\')'
    ).then((x) {
      print(
          'La description de la catégorie a été modifié: '
          'Nom: ${this.code}, '
          'description: ${this.description}, '
      );
    }, onError:(e) => print(
        'La description de la catégorie n\'a pas été modifié'
        'Une erreur a été rencontré : ${e} -- '
        'Nom: ${this.code}, '
        'description: ${this.description}, '
    ));   
    }
    }  
  
  
  String toString() {
    return '  {\n '
           '    ${super.toString()}, \n '
           '    description: ${_description}\n'
           '  }\n';
  }
  
  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['description'] = _description;
    entityMap['taches'] = taches.toJson();
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    _description = entityMap['description'];
    taches.fromJson(entityMap['taches']);
  }

  bool get onProgramming =>
      _description.contains('programming') ? true : false;

}

class Categories extends ConceptEntities<Category> {

  Categories newEntities() => new Categories();
  Category newEntity() => new Category();

  bool remove(Category category, {bool BoolBDRemove:true}) {
    if (super.remove(category)) {
        if (BoolBDRemove) {
          ConnectionPool pool = getConnectionPool();
          
          //suprimer les occurences personneTaches de cette catégorie
          //suprimer les taches de cette catégorie
          
         // if()
          //category.taches.remove(category, BoolBDRemove)(category.taches.)
          //get tache ID
          
          //'delete from personnelTache'
          
          pool.query(
              'delete from categorie '
              'where (categorie.Nom = '
              '\'${codepointsToString(encodeUtf8(category.code))}\')'
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
  
  bool add(Category category, {bool BoolBDinsert:true}) {
    if (super.add(category)) {
        if (BoolBDinsert) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'insert into categorie '
              '(Nom, Description)'
              'values'
              '("${codepointsToString(encodeUtf8(category.code))}", '
              '"${codepointsToString(encodeUtf8(category.description))}")'
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
