// Задание 2. Абстрактный класс
abstract class LibraryItem {
  String get title;
  String describe();
  
  void printCard() {
    print('------------------------------------');
    print(describe());
    print('------------------------------------');
  }
}