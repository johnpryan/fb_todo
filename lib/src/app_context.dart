import 'services/auth_service.dart';
import 'services/todo_service.dart';

class AppContext {
  AuthService authService;
  TodoService todoService;
  AppContext(this.authService, this.todoService);
}