import 'dart:io';
import 'dart:convert';
import 'package:bookshelf_console/models/book.dart';
import 'package:bookshelf_console/models/library.dart';
import 'package:bookshelf_console/models/reading_status.dart';

void main() {
  final library = Library<Book>();

  library.add(Book(title: 'Основы Dart', author: 'С. А. Чернышев', year: 2024, pages: 521, genres: {'учебник'}, status: ReadingStatus.reading));
  library.add(PaperBook(title: 'Мастер и Маргарита', author: 'М. А. Булгаков', year: 1967, pages: 480, genres: {'роман'}, status: ReadingStatus.finished, shelf: 'A1'));
  library.add(EBook(title: 'Дюна', author: 'Ф. Герберт', year: 1965, pages: 800, genres: {'фантастика'}, format: 'PDF', sizeMb: 2.5));
  library.add(AudioBook(title: '1984', author: 'Дж. Оруэлл', year: 1949, pages: 320, genres: {'фантастика'}, duration: Duration(hours: 10, minutes: 30), narrator: 'Иван Иванов'));

  var running = true;
  while (running) {
    printMenu();
    stdout.write('> ');
    final command = stdin.readLineSync(encoding: utf8)?.trim() ?? '';

    switch (command) {
      case '1':
        for (final item in library.items) {
          item.printCard();
        }
        break;
      case '2':
        stdout.write('Поиск: ');
        final query = stdin.readLineSync(encoding: utf8) ?? '';
        final results = library.search(query);
        if (results.isEmpty) print('Ничего не найдено.');
        for (final item in results) {
          print(item.describe());
        }
        break;
      case '3':
        final sorted = library.items.toList()..sort();
        for (final b in sorted) {
          print(b.describe());
        }
        break;
      case '4':
        print('\n--- ДЕМОНСТРАЦИЯ ООП ---');
        print('Статус книги: ${ReadingStatus.finished.label}');
        print('Это конец чтения? ${ReadingStatus.finished.isDone}');

        final demoBook = PaperBook(title: 'Тестовая', author: 'Автор', shelf: 'B2', status: ReadingStatus.reading);
        print('\nСоздана книга: ${demoBook.describe()}');
        
        try {
          demoBook.rating = 6.0; 
        } catch (e) {
          print('Ошибка сеттера: $e');
        }
        demoBook.rating = 4.5;
        print('Рейтинг: ${demoBook.rating}');

        demoBook.log('Книга создана');
        demoBook.vote(5.0);
        demoBook.vote(4.0);
        print('Средний рейтинг: ${demoBook.averageRating}');
        
        demoBook.borrow(14);
        print('Выдана?: ${demoBook.isBorrowed}');
        demoBook.giveBack();
        
        final copyBook = demoBook.copyWith(title: 'Копия');
        print('\nКопия: ${copyBook.title}');
        
        final b1 = Book(title: 'Тест', author: 'Автор', year: 2000);
        final b2 = Book(title: 'Тест', author: 'Автор', year: 2000);
        print('b1 == b2: ${b1 == b2}');
        print('Размер Set (должен быть 1): ${{b1, b2}.length}');
        break;
      case '0':
        running = false;
        break;
      default:
        print('Неизвестная команда');
    }
  }
}

void printMenu() {
  print('\nБИБЛИОТЕКА (ООП)');
  print('1. Показать все');
  print('2. Поиск');
  print('3. Сортировка по названию');
  print('4. Демонстрация ООП');
  print('0. Выход');
}