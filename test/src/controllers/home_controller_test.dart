import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list/src/controllers/home_controller.dart';
import 'package:todo_list/src/models/todo_model.dart';
import 'package:todo_list/src/repositories/todo_repository.dart';

class TodoRepositoryMock extends Mock implements TodoRepository {}

void main() {
  final repository = TodoRepositoryMock();
  final controller = HomeController(repository);

  tearDown(() {
    controller.state.value = HomeState.start;
  });

  test('deve preencher variavel todos', () async {
    when(() => repository.fetchTodos()).thenAnswer((_) async => [TodoModel()]);
    expect(controller.state.value, HomeState.start);
    await controller.start();
    expect(controller.state.value, HomeState.success);
    expect(controller.todos.isNotEmpty, true);
  });

  test('deve modificar o estado para error se a requisição falhar', () async {
    when(() => repository.fetchTodos()).thenThrow(Exception());
    expect(controller.state.value, HomeState.start);
    await controller.start();
    expect(controller.state.value, HomeState.error);
  });
}
