import '../../model/usuario_model.dart';

class UsuarioController {
  // Lista para simular um banco de dados (substitua por uma implementação real)
  List<Usuario> _usuarios = [];

  // Método para criar um novo usuário
  void criarUsuario(Usuario usuario) {
    _usuarios.add(usuario);
    // Aqui você implementaria a lógica para salvar o usuário em um banco de dados
    print('Usuário criado com sucesso!');
  }

  // Método para obter todos os usuários
  List<Usuario> obterTodosUsuarios() {
    // Aqui você implementaria a lógica para buscar todos os usuários do banco de dados
    return _usuarios;
  }

  // Método para obter um usuário por ID (você precisaria adicionar um ID ao modelo Usuario)
  Usuario? obterUsuarioPorId(int id) {
  return _usuarios.firstWhere((usuario) => usuario.id == id);
}

  // Método para atualizar um usuário
  void atualizarUsuario(Usuario usuario) {
    // Encontre o usuário a ser atualizado e substitua seus dados
    int index = _usuarios.indexWhere((u) => u.email == usuario.email);
    if (index != -1) {
      _usuarios[index] = usuario;
      // Aqui você implementaria a lógica para atualizar o usuário no banco de dados
      print('Usuário atualizado com sucesso!');
    } else {
      print('Usuário não encontrado');
    }
  }

  // Método para deletar um usuário
  void deletarUsuario(int id) {
    // Implemente a lógica para deletar um usuário
    _usuarios.removeWhere((usuario) => usuario.id == id);
    print('Usuário deletado com sucesso!');
  }
}