part of dartlero_category_tache;

class Personnel extends ConceptEntity<Personnel> {
  
  String departement;

  Personnel newEntity() => new Personnel();

  String toString() {
    return '    {\n '
           '      ${super.toString()}, \n '
           '      departement: ${departement}\n'         
           '    }\n';
  }

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['departement'] = departement;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    departement = entityMap['departement'];
  }

  bool get onProgramming =>
      departement.contains('programming') ? true : false;

}

class Personnels extends ConceptEntities<Personnel> {

  Personnels newEntities() => new Personnels();
  Personnel newEntity() => new Personnel();

}

