enum Especie { cachorro, gato }
enum Sexo { macho, femea }
enum Porte { pequeno, medio, grande }
enum Temperamento { agressivo, brincalhao, curioso, hiperativo, quieto, medroso }

class Pet {
  final String nome;
  final int idade;
  final Sexo sexo;
  final Especie especie;
  final Porte porte;
  final Temperamento temperamento;
  final bool vacinado;
  final bool castrado;
  final bool sociavel;

  Pet({
    required this.nome,
    required this.idade,
    required this.sexo,
    required this.especie,
    required this.porte,
    required this.temperamento,
    required this.vacinado,
    required this.castrado,
    required this.sociavel,
  });

  // Representação textual do Pet
  String get descricao {
    return '$nome, $idade anos, $sexo, $especie, $porte, $temperamento, Vacinado: $vacinado, Castrado: $castrado, Sociável: $sociavel';
  }
}
