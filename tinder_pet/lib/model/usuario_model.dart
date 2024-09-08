enum TamanhoCasa { pequena, media, grande }
enum TipoMoradia { casa, condominio }

class Usuario {
  String nome;
  DateTime dataNascimento;
  String endereco;
  String email;
  String senha;
  bool temOutrosPets;
  bool temCriancas;
  TipoMoradia tipoMoradia;
  // enum horasEmCasa;

  Usuario({
    // comum a ong
    required this.nome,
    required this.email,
    required this.senha,
    required this.endereco,
    // específicos a pessoa adotante
    required this.dataNascimento,
    required this.temOutrosPets,
    required this.temCriancas,
    required this.tipoMoradia,
  });
}
