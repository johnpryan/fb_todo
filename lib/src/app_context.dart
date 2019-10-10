import 'services/services.dart';

class AppContext {
  final AuthService authService;
  final TodoService todoService;

  AppContext(this.authService, this.todoService);
}