import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController {
  Future<Map<String, dynamic>?> fetchUserData() async {
    // Obter o usuário autenticado
    final user = Supabase.instance.client.auth.currentUser;

    // Verifica se o usuário está autenticado
    if (user == null) {
      return null;
    }

    // Converter os dados do usuário em um Map<String, dynamic>
    final Map<String, dynamic> userData = {
      'id': user.id,
      'email': user.email,
      'createdAt': user.createdAt.toString(),
      'updatedAt': user.updatedAt?.toString(),
      'appMetadata': user.appMetadata,
      'userMetadata': user.userMetadata,
      'lastSignInAt': user.lastSignInAt?.toString(),
      'role': user.role,
    };

    return userData;
  }
}
