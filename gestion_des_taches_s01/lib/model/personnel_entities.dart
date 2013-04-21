part of dartlero_category_tache;

class Personnel extends ConceptEntity<Personnel> {
  
  String _departement;
  

  Personnel newEntity() => new Personnel();  
  
  String get departement => _departement;

  set departement(String departement) {
    var oldDepartement = _departement;
    _departement = departement;
    
    if (oldDepartement != null){
      ConnectionPool pool = getConnectionPool();
      pool.query(
          'update personnel '
          'SET '
          'DEPARTEMENT = \'${codepointsToString(encodeUtf8(this.departement))}\' '
          'where '
          '(NOM_COMPLET = \'${codepointsToString(encodeUtf8(this.code))}\')'
      ).then((x) {
        print(
            'Le membre du personnel a été modifié: '
            'Nom: ${this.code}, '
            'departement: ${this.departement}, '
        );
      }, onError:(e) => print(
          'Le membre du personnel n\'a pas été modifié'
          'Une erreur a été rencontré : ${e} -- '
          'Nom: ${this.code}, '
          'departement: ${this.departement}, '
      ));
    }
   }
  
  String toString() {
    return '    {\n '
           '      ${super.toString()}, \n '
           '      departement: ${_departement}\n'         
           '    }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['departement'] = _departement;
    return entityMap;
  }
       
              
  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    _departement = entityMap['departement'];
  }

  bool get onProgramming =>
      _departement.contains('programming') ? true : false;

}

class Personnels extends ConceptEntities<Personnel> {

  Personnels newEntities() => new Personnels();
  Personnel newEntity() => new Personnel();
  


  
  
  
  bool remove(Personnel personnel, {Tache tache, bool BoolRemove:true}) {
    if (super.remove(personnel)) {
        if (BoolRemove) {
          ConnectionPool pool = getConnectionPool();
          
          if(BoolRemove && ?tache){
            pool.query(
                'delete from personneltache '
                'where (NomPersonnel = \'${codepointsToString(encodeUtf8(personnel.code))}\' and '
                'NomTache = \'${codepointsToString(encodeUtf8(tache.code))}\')'
            ).then((x) {
              print(
                  'Le membre du personnelTache a été supprimé: '
                  'Nom: ${personnel.code}, '
                  'tache: ${tache.code}, '
                  return true;
                  
              );}, onError:(e) => print(
                  'Le membre du personnelTache n\'a pas été suprimé'
                  'Une erreur a été rencontré : ${e} -- '
                  'Nom: ${personnel.code}, '
                  'tache: ${tache.code}, ')
            );
          }  

          pool.query(
              'delete from personnel '
              'where (personnel.NOM_COMPLET = '
              '\'${codepointsToString(encodeUtf8(personnel.code))}\')'
          ).then((x) {
            print(
                'Le membre du personnel a été suprimé: '
                'Nom: ${personnel.code}, '
                'departement: ${personnel.departement}, '                
            );
          }, onError:(e) => print(
              'Le membre du personnel n\'a pas été supprimé'
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${personnel.code}, '
              'departement: ${personnel.departement}, '
          ));
        }
      return true;
    } else {
      print(
          'Le membre du personnel n\'a pas été suprimé: '
          'Nom: ${personnel.code}, '
          'departement: ${personnel.departement}, '
      );
      return false;
    }
  }
  
  bool add(Personnel personnel, {Tache tache, bool insert:true}) {
    if (super.add(personnel)) {

      
      if (insert) {
          ConnectionPool pool = getConnectionPool();
          pool.query(
              'insert into personnel '
              '(NOM_COMPLET, DEPARTEMENT)'
              'values'
              '("${codepointsToString(encodeUtf8(personnel.code))}", '
              '"${codepointsToString(encodeUtf8(personnel.departement))}")'
          ).then((x) {
            print(
                'Le membre du personnel a été ajouté: '
                'Nom: ${personnel.code}, '
                'departement: ${personnel.departement}, ');
                if(insert && ?tache){
                  pool.query(
                      'insert into personneltache '
                      '(NomPersonnel, NomTache)'
                      'values'
                      '("${codepointsToString(encodeUtf8(personnel.code))}", '
                      '"${codepointsToString(encodeUtf8(tache.code))}")'
                  ).then((x) {
                    print(
                        'Le membre du personnelTache a été ajouté: '
                        'Nom: ${personnel.code}, '
                        'tache: ${tache.code}, '
                    
                  );}, onError:(e) => print(
                      'Le membre du personnelTache n\'a pas été ajouté'
                      'Une erreur a été rencontré : ${e} -- '
                      'Nom: ${personnel.code}, '
                      'tache: ${tache.code}, ')
                  );
                }  
                
            ;
          }, onError:(e) => print(
              'Le membre du personnel n\'a pas été ajouté'
              'Une erreur a été rencontré : ${e} -- '
              'Nom: ${personnel.code}, '
              'departement: ${personnel.departement}, '
          ));
        }
      return true;
    } else {
      print(
          'Le membre du personnel n\'a pas été ajouté: '
          'Nom: ${personnel.code}, '
          'departement: ${personnel.departement}, '
      );
      return false;
    }
  }
  
  
}