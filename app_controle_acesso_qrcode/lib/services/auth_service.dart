import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fazer login com email e senha
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Tratar erros específicos do Firebase Auth
      throw Exception("Erro ao fazer login: ${e.message}");
    } catch (e) {
      // Tratar outros tipos de exceções
      throw Exception("Erro desconhecido ao fazer login: $e");
    }
  }

  // Criar conta com email e senha
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Tratar erros específicos do Firebase Auth
      throw Exception("Erro ao criar conta: ${e.message}");
    } catch (e) {
      // Tratar outros tipos de exceções
      throw Exception("Erro desconhecido ao criar conta: $e");
    }
  }

  // Fazer logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Erro ao sair: $e");
    }
  }

  // Obter usuário atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Verificar se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }
}
