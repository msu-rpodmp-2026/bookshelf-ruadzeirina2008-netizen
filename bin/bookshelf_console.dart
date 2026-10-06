import 'dart:io';
import 'dart:convert';

void main() {
  // 1 задание (2.2): сведения о среде
  const String projectName = 'bookshelf';
  print('Проект: $projectName');
  print('Версия Dart: ${Platform.version}');
  print('Операционная система: ${Platform.operatingSystem}');

  // 2 задание (2.3): ввод данных о книге
  stdout.write('Название: ');
  final String title = stdin.readLineSync(encoding: utf8) ?? '';
  if (title.trim().isEmpty) {
    print('Ошибка: название книги не может быть пустым.');
    return;
  }

  stdout.write('Автор: ');
  final String author = stdin.readLineSync(encoding: utf8) ?? 'неизвестен';

  stdout.write('Год издания: ');
  final int? yearParsed = int.tryParse(
    stdin.readLineSync(encoding: utf8) ?? '',
  );
  if (yearParsed == null) {
    print('Ошибка: год должен быть целым числом.');
    return;
  }
  final int year = yearParsed;

  stdout.write('Количество страниц: ');
  final int? pagesParsed = int.tryParse(
    stdin.readLineSync(encoding: utf8) ?? '',
  );
  if (pagesParsed == null || pagesParsed <= 0) {
    print('Ошибка: количество страниц должно быть целым числом больше нуля.');
    return;
  }
  final int pages = pagesParsed;

  stdout.write('Оценка (0-5): ');
  final double? ratingParsed = double.tryParse(
    stdin.readLineSync(encoding: utf8) ?? '',
  );
  if (ratingParsed == null || ratingParsed < 0 || ratingParsed > 5) {
    print('Ошибка: оценка должна быть числом от 0 до 5.');
    return;
  }
  final double rating = ratingParsed;

  stdout.write('Прочитана (1 - да, 0 - нет): ');
  final String readInput = (stdin.readLineSync(encoding: utf8) ?? '')
      .trim()
      .toLowerCase();

  final bool isRead;
  if (readInput == 'да' ||
      readInput == 'yes' ||
      readInput == 'y' ||
      readInput == '1') {
    isRead = true;
  } else if (readInput == 'нет' ||
      readInput == 'no' ||
      readInput == 'n' ||
      readInput == '0') {
    isRead = false;
  } else {
    print('Ошибка: введите «да» или «нет».');
    return;
  }

  // 3 задание (2.4): вычисляемые характеристики
  // Категория книги по объёму
  final String category = pages < 150
      ? 'брошюра'
      : (pages < 400 ? 'книга' : 'том');

  // Время чтения при скорости 50 страниц/час
  final double readingHours = pages / 50;
  final String readingTime = readingHours.toStringAsFixed(1);

  // Возраст издания
  final int currentYear = DateTime.now().year;
  final int age = currentYear - year;

  // Инициалы автора (первая буква каждого слова + точка)
  final List<String> authorWords = author.split(' ');
  final String initials = authorWords
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}.')
      .join(' ');

  // Вывод карточки книги
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

  // 4 задание (2.5): коллекции

  // 4.1. List — список книг
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

  shelf.insert(0, 'Евгений Онегин'); // добавить в начало
  shelf.add('Герой нашего времени'); // добавить в конец
  print('После добавления в начало и конец: $shelf');

  shelf.remove('Война и мир'); // удалить по значению
  print('После удаления «Война и мир»: $shelf');

  // 4.2. Set — множество жанров (дубликаты отбрасываются)
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

  // 4.3. Map — пары «книга — страницы»
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

  // Поиск книги с максимальным числом страниц
  String maxBook = '';
  int maxPages = 0;
  pagesByBook.forEach((book, p) {
    if (p > maxPages) {
      maxPages = p;
      maxBook = book;
    }
  });
  print('Самая толстая книга: $maxBook ($maxPages стр.)');

  // Сумма и среднее
  final int totalPages = pagesByBook.values.reduce((a, b) => a + b);
  final double avgPages = totalPages / pagesByBook.length;
  print('Всего страниц: $totalPages');
  print('Среднее количество: ${avgPages.toStringAsFixed(1)}');

  // 4.4. Объединённый список с раскрытием, if и for
  final List<String> extraBooks = ['Обломов', 'Отцы и дети'];
  final bool includeExtra = true;

  final List<String> all = [
    ...shelf,
    if (includeExtra) ...extraBooks,
    for (final book in pagesByBook.keys) book,
  ];
  print('Объединённый список all (${all.length} элементов):');
  print(all);

  // 5 задание (2.6): операторы

  // 5.1. Различие /, ~/ и %
  //   /  — обычное деление (всегда double)
  //   ~/ — целочисленное деление (отбрасывает дробную часть)
  //   %  — остаток от деления
  print('');
  print('1) Арифметические операторы:');
  print('7 /  2 = ${7 / 2}   // обычное деление');
  print('7 ~/ 2 = ${7 ~/ 2}     // целочисленное');
  print('7 %  2 = ${7 % 2}     // остаток');

  // 5.2. Ленивое вычисление && и ||
  // Если результат уже ясен по левому операнду, правый НЕ вычисляется.
  print('');
  print('2) Ленивое вычисление && и ||');

  bool isPositive(int x) {
    print('   -> isPositive($x) вызвана');
    return x > 0;
  }

  bool isEven(int x) {
    print('   -> isEven($x) вызвана');
    return x % 2 == 0;
  }

  print('Проверка &&:');
  final bool andResult = isPositive(-5) && isEven(-5);
  print('  Результат: $andResult  // isEven не вызвана');

  print('Проверка ||:');
  final bool orResult = isPositive(5) || isEven(5);
  print('  Результат: $orResult  // isEven не вызвана');

  // 5.3. Операторы ?., ??, ??=
  //   ?.  — безопасный доступ (null вместо ошибки)
  //   ??  — «если null, то...»
  //   ??= — «присвоить, если null»
  print('');
  print('3) Операторы ?., ??, ??=');

  String? getNull() =>
      null; // прячем null за функцией, чтобы компилятор не предсказал

  String? nullableName = getNull();
  print('Оператор (?.): ${nullableName?.length}');
  print('Оператор (??): ${nullableName ?? "без имени"}');
  nullableName ??= 'Книга';
  print('Оператор (??=): $nullableName');

  // 5.4. final vs const
  //   final — переменную нельзя переприсвоить, содержимое списка менять можно
  //   const — нельзя ни переприсвоить, ни изменить содержимое
  print('');
  print('4) final vs const:');

  final List<String> finalList = ['A', 'B'];
  finalList.add('C');
  print('final: $finalList  // содержимое изменили успешно');

  const List<String> constList = ['X', 'Y'];
  try {
    constList.add('Z');
    print('const: $constList');
  } catch (e) {
    print('const: $constList  // изменение невозможно: $e');
  }

  // 5.5. Каскадный оператор ..
  // Позволяет вызывать методы на одном объекте по цепочке.
  print('');
  print('5) Каскадный оператор ..:');

  final StringBuffer buffer = StringBuffer()
    ..write('Книга: ')
    ..write('Мастер и Маргарита')
    ..write(', автор: ')
    ..write('Булгаков');

  print('$buffer');
}
