import 'dart:io';
import 'dart:convert';

void main() {
  stdout.encoding = utf8;
  stderr.encoding = utf8;

  //1 задание
  const String projectName = 'bookshelf';
  print('Проект: $projectName');
  print('Версия Dart: ${Platform.version}');
  print('Операционная система: ${Platform.operatingSystem}');

  // 2 задание 
  stdout.write('Название: ');
  final String title = stdin.readLineSync(encoding: utf8) ?? '';
  if (title.trim().isEmpty) {
    print('Ошибка: название книги не может быть пустым.');
    return;
  }

  stdout.write('Автор: ');
  final String author = stdin.readLineSync(encoding: utf8) ?? 'неизвестен';

  stdout.write('Год издания: ');
  final int? yearParsed = int.tryParse(stdin.readLineSync(encoding: utf8) ?? '');
  if (yearParsed == null) {
    print('Ошибка: год должен быть целым числом.');
    return;
  }
  final int year = yearParsed;

  stdout.write('Количество страниц: ');
  final int? pagesParsed = int.tryParse(stdin.readLineSync(encoding: utf8) ?? '');
  if (pagesParsed == null || pagesParsed <= 0) {
    print('Ошибка: количество страниц должно быть целым числом больше нуля.');
    return;
  }
  final int pages = pagesParsed;

  stdout.write('Оценка (0-5): ');
  final double? ratingParsed = double.tryParse(stdin.readLineSync(encoding: utf8) ?? '');
  if (ratingParsed == null || ratingParsed < 0 || ratingParsed > 5) {
    print('Ошибка: оценка должна быть числом от 0 до 5.');
    return;
  }
  final double rating = ratingParsed;

  stdout.write('Прочитана (1 - да, 0 - нет): ');
  final String readInput = (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();

  final bool isRead;
  if (readInput == 'да' || readInput == 'yes' || readInput == 'y' || readInput == '1') {
    isRead = true;
  } else if (readInput == 'нет' || readInput == 'no' || readInput == 'n' || readInput == '0') {
    isRead = false;
  } else {
    print('Ошибка: введите «да» или «нет».');
    return;
  }

  //3 задание
  final String category = pages < 150
      ? 'брошюра'
      : (pages < 400 ? 'книга' : 'том');

  final double readingHours = pages / 50;
  final String readingTime = readingHours.toStringAsFixed(1);

  final int currentYear = DateTime.now().year;
  final int age = currentYear - year;

  final List<String> authorWords = author.split(' ');
  final String initials = authorWords
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}.')
      .join(' ');
  print('');
  print('=' * 44);
  print(' «$title»');
  print(' Автор: $author');
  print(' Инициалы: $initials');
  print(' Год: $year (возраст: $age лет)');
  print(' Страниц: $pages ($category)');
  print(' Время чтения: ~$readingTime ч');
  print(' Оценка: ${rating.toStringAsFixed(1)} / 5');
  print(' Прочитана: ${isRead ? "да" : "нет"}');
  print('=' * 44);

  // Задание 4
  final List<String> shelf = [
    'Мастер и Маргарита',
    'Преступление и наказание',
    'Война и мир',
    'Анна Каренина',
    'Тихий Дон',
  ];

  print('');
  print('Список книг: $shelf');
  print('Длина списка: ${shelf.length}');
  print('Первая книга: ${shelf.first}');
  print('Последняя книга: ${shelf.last}');

  shelf.insert(0, 'Евгений Онегин');     
  shelf.add('Герой нашего времени');       
  print('После добавления в начало и конец: $shelf');

  shelf.remove('Война и мир');            
  print('После удаления «Война и мир»: $shelf');
  stdout.write('Введите жанры через запятую: ');
  final String genresInput = stdin.readLineSync(encoding: utf8) ?? '';
  final List<String> genresList = genresInput
      .split(',')
      .map((g) => g.trim())
      .where((g) => g.isNotEmpty)
      .toList();
  final Set<String> genres = genresList.toSet();

  print('Введено жанров (с повторами): ${genresList.length}');
  print('Уникальных жанров (Set): ${genres.length}');
  print('Список жанров: $genres');

  final Map<String, int> pagesByBook = {
    'Мастер и Маргарита': 480,
    'Преступление и наказание': 671,
    'Война и мир': 1274,
    'Анна Каренина': 864,
    'Тихий Дон': 1600,
  };

  print('');
  print('Пары «книга — страницы»:');
  pagesByBook.forEach((book, p) {
    print('  $book: $p стр.');
  });
  String maxBook = '';
  int maxPages = 0;
  pagesByBook.forEach((book, p) {
    if (p > maxPages) {
      maxPages = p;
      maxBook = book;
    }
  });
  print('Самая толстая книга: $maxBook ($maxPages стр.)');
  final int totalPages = pagesByBook.values.reduce((a, b) => a + b);
  final double avgPages = totalPages / pagesByBook.length;
  print('Всего страниц: $totalPages');
  print('Среднее количество: ${avgPages.toStringAsFixed(1)}');
  final List<String> extraBooks = ['Обломов', 'Отцы и дети'];
  final bool includeExtra = true;

  final List<String> all = [
    ...shelf,
    if (includeExtra) ...extraBooks,
    for (final book in pagesByBook.keys) book,
  ];
  print('Объединённый список all (${all.length} элементов):');
  print(all);
  // Задание 5
  print('1) Арифметические операторы:');
  print('7 / 2  = ${7 / 2}');   
  print('7 ~/ 2 = ${7 ~/ 2}');  
  print('7 % 2  = ${7 % 2}');   
  print('2) Ленивое вычисление операторов && и ||');

  bool isPositive(int x) {
    print('Число $x положительное?');
    return x > 0;
  }

  bool isEven(int x) {
    print('Число $x чётное?');
    return x % 2 == 0;
  }

  print('Проверка &&:');
  final bool andResult = isPositive(-5) && isEven(-5);
  print('  Результат: $andResult ');
  print('Проверка ||:');
  final bool orResult = isPositive(5) || isEven(5);
  print('  Результат: $orResult ');
  print('3) Операторы ?., ??, ??=:');
   String? nullableName;
  print('Оператор (?.): ${nullableName?.length}');
  print('Оператор (??): ${nullableName ?? "без имени"}');
  nullableName ??= 'Книга';
  print('Оператор (??=):  $nullableName');               
  print('Результат: $nullableName');
  print('4) Окончательный / Постоянный:');
  final List<String> finalList = ['A', 'B'];
  finalList.add('C');
  print('Итоговый список после добавления: $finalList');
  const List<String> constList = ['X', 'Y'];
  print('Постоянный список: $constList');
  print('5) Каскадный оператор:');

  final StringBuffer buffer = StringBuffer()
    ..write('Книга: ')
    ..write('Мастер и Маргарита')
    ..write(', ')
    ..write('автор: ')
    ..write('Булгаков');

  print('Строка обмена: $buffer');
}
