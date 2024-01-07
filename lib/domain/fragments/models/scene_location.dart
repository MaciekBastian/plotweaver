enum SceneLocation {
  interior('interior'),
  exterior('exterior'),
  interiorToExterior('interior_to_exterior'),
  exteriorToInterior('exterior_to_interior');

  const SceneLocation(this.codeName);
  final String codeName;

  static SceneLocation fromCodeName(String codeName) => SceneLocation.values
      .firstWhere((element) => element.codeName == codeName);

  String get readable {
    switch (this) {
      case SceneLocation.interior:
        return 'INT.';
      case SceneLocation.exterior:
        return 'EXT.';
      case SceneLocation.interiorToExterior:
        return 'INT./EXT.';
      case SceneLocation.exteriorToInterior:
        return 'EXT./INT.';
    }
  }
}
