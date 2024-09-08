import '../../model/usuario_model.dart';

class UsuarioController {
  List<Usuario> usuarios = [];

  void addUsuario(Usuario usuario) {
    usuarios.add(usuario);
  }
}