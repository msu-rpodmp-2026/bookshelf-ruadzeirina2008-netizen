import 'dart:io';
import 'dart:convert';

// Задание 1: Структура данных каталога

// Псевдоним типа: книга — это словарь с полями
typedef Book = Map<String, Object?>;

// Каталог: 8 книг, 4 жанра, разные годы
final List<Book> library = [
  {
    'title': 'Основы Dart',
    'author': 'С. А. Чернышев',
    'year': 2024,
    'pages': 521,
    'genre': 'учебник',
    'read': true,
  },
  {
    'title': 'Flutter на практике',
    'author': 'Ф. Заметти',
    'year': 2020,
    'pages': 328,
    'genre': 'учебник',
    'read': false,
  },
  {
    'title': 'Мастер и Маргарита',
    'author': 'М. А. Булгаков',
    'year': 1967,
    'pages': 480,
    'genre': 'роман',
    'read': true,
  },
  {
    'title': 'Преступление и наказание',
    'author': 'Ф. М. Достоевский',
    'year': 1866,
    'pages': 671,
    'genre': 'роман',
    'read': false,
  },
  {
    'title': 'Война и мир',
    'author': 'Л. Н. Толстой',
    'year': 1869,
    'pages': 1274,
    'genre': 'роман',
    'read': true,
  },
  {
    'title': 'Дюна',
    'author': 'Ф. Герберт',
    'year': 1965,
    'pages': 800,
    'genre': 'фантастика',
    'read': true,
  },
  {
    'title': '1984',
    'author': 'Дж. Оруэлл',
    'year': 1949,
    'pages': 320,
    'genre': 'фантастика',
    'read': false,
  },
  {
    'title': 'Шерлок Холмс',
    'author': 'А. К. Дойл',
    'year': 1892,
    'pages': 450,
    'genre': 'детектив',
    'read': true,
  },
];

// Задание 6: Функции высшего порядка

// Псевдоним для функции-предиката
typedef BookPredicate = bool Function(Book book);

/// Универсальная фильтрация по предикату
List<Book> filter(List<Book> books, BookPredicate test) {
  return books.where(test).toList();
}

/// Возвращает замыкание-счётчик
Function makeCounter() {
  var count = 0;
  return () {
    count++;
    return count;
  };
}

/// Демонстрация filter с тремя анонимными функциями
void demoHigherOrder(List<Book> books) {
  print('');
  print('ДЕМОНСТРАЦИЯ ФУНКЦИЙ ВЫСШЕГО ПОРЯДКА');

  // 1. Толстые книги (больше 500 страниц)
  final thick = filter(books, (book) => (book['pages'] as int) > 500);
  print('');
  print('Толстые книги (> 500 стр.):');
  printAll(thick);

  // 2. Книги нового века (год >= 2000)
  final modern = filter(books, (book) => (book['year'] as int) >= 2000);
  print('');
  print('Книги нового века (год >= 2000):');
  printAll(modern);

  // 3. Непрочитанные книги жанра «роман»
  final unreadRomance = filter(
    books,
    (book) => book['read'] == false && book['genre'] == 'роман',
  );
  print('');
  print('Непрочитанные романы:');
  printAll(unreadRomance, emptyMessage: 'Все романы прочитаны.');
}

// Задание 3: Функции вывода, поиска, фильтрации, сортировки

/// Вывод списка книг с нумерацией и отметкой о прочтении.
void printAll(List<Book> books, {String emptyMessage = 'Ничего не найдено.'}) {
  if (books.isEmpty) {
    print(emptyMessage);
    return;
  }
  for (var i = 0; i < books.length; i++) {
    final book = books[i];
    final mark = (book['read'] == true) ? '[+]' : '[ ]';
    print('${i + 1}. $mark «${book['title']}» — ${book['author']}, '
        '${book['year']} г., ${book['pages']} стр., жанр: ${book['genre']}');
  }
}

/// Поиск по подстроке в указанном поле, без учёта регистра.
List<Book> searchByField(List<Book> books, String field, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];
  return books.where((book) {
    final value = book[field]?.toString().toLowerCase() ?? '';
    return value.contains(q);
  }).toList();
}

/// Фильтрация по признаку прочтения.
List<Book> filterByRead(List<Book> books, bool isRead) {
  return books.where((book) => book['read'] == isRead).toList();
}

/// Сортировка; направление задаётся именованным параметром.
/// Не изменяет исходный список — работает с копией.
List<Book> sortBy(List<Book> books, String field, {bool descending = false}) {
  final copy = [...books];
  copy.sort((a, b) {
    final va = a[field];
    final vb = b[field];
    int cmp;
    if (va is num && vb is num) {
      cmp = va.compareTo(vb);
    } else {
      cmp = (va?.toString() ?? '').compareTo(vb?.toString() ?? '');
    }
    return descending ? -cmp : cmp;
  });
  return copy;
}

// Задание 4: Статистика с методами Iterable

/// Выводит статистику по каталогу.
/// Все вычисления — через where, map, fold, reduce, any, every.
/// Без циклов for, кроме вывода.
void printStatistics(List<Book> books) {
  if (books.isEmpty) {
    print('Каталог пуст.');
    return;
  }

  // Общее количество книг
  final total = books.length;

  // Количество прочитанных
  final readCount = books.where((b) => b['read'] == true).length;

  // Суммарное количество страниц (fold)
  final totalPages = books.fold<int>(
    0,
    (sum, b) => sum + ((b['pages'] as int?) ?? 0),
  );

  // Среднее количество страниц
  final avgPages = totalPages / total;

  // Самая старая книга (min по году)
  final oldest = books.reduce(
    (a, b) => ((a['year'] as int) < (b['year'] as int)) ? a : b,
  );

  // Самая новая книга (max по году)
  final newest = books.reduce(
    (a, b) => ((a['year'] as int) > (b['year'] as int)) ? a : b,
  );

  // Самая объёмная книга
  final thickest = books.reduce(
    (a, b) => ((a['pages'] as int) > (b['pages'] as int)) ? a : b,
  );

  // Уникальные жанры (map → Set)
  final genres = books.map((b) => b['genre'].toString()).toSet().toList();

  // Количество книг по каждому жанру (Map<String, int>) — через fold, без for
  final byGenre = books.fold<Map<String, int>>(
    <String, int>{},
    (map, b) {
      final g = b['genre'].toString();
      map[g] = (map[g] ?? 0) + 1;
      return map;
    },
  );

  // Доля прочитанного в процентах
  final readPercent = (readCount / total) * 100;

  // Проверки any и every
  final hasModern = books.any((b) => (b['year'] as int) >= 2000);
  final allRead = books.every((b) => b['read'] == true);

  // Вывод
  print('');
  print('СТАТИСТИКА КАТАЛОГА');
  print('Всего книг: $total');
  print('Прочитано: $readCount (${readPercent.toStringAsFixed(1)}%)');
  print('Всего страниц: $totalPages');
  print('Среднее количество страниц: ${avgPages.toStringAsFixed(1)}');
  print('Самая старая: «${oldest['title']}» (${oldest['year']})');
  print('Самая новая: «${newest['title']}» (${newest['year']})');
  print('Самая объёмная: «${thickest['title']}» (${thickest['pages']} стр.)');
  print('Уникальные жанры: ${genres.join(', ')}');
  print('Книг по жанрам:');
  byGenre.forEach((g, count) {
    print('  $g: $count');
  });
  print('Есть книги новее 2000 года: $hasModern');
  print('Все книги прочитаны: $allRead');
}

// Задание 5: Добавление и удаление

/// Надёжный ввод целого числа с проверкой диапазона.
int askInt(String prompt, {int min = 0, int? max}) {
  int? value;
  do {
    stdout.write('$prompt: ');
    value = int.tryParse(stdin.readLineSync(encoding: utf8) ?? '');
    if (value == null || value < min || (max != null && value > max)) {
      print('Некорректное значение. Ожидается целое число'
          '${max == null ? ' не меньше $min' : ' от $min до $max'}.');
      value = null;
    }
  } while (value == null);
  return value;
}

/// Добавление новой книги в каталог.
void addBook(List<Book> books) {
  print('');
  print('ДОБАВЛЕНИЕ КНИГИ');

  stdout.write('Название: ');
  final title = (stdin.readLineSync(encoding: utf8) ?? '').trim();
  if (title.isEmpty) {
    print('Ошибка: название не может быть пустым.');
    return;
  }

  stdout.write('Автор: ');
  final author = (stdin.readLineSync(encoding: utf8) ?? '').trim();
  if (author.isEmpty) {
    print('Ошибка: автор не может быть пустым.');
    return;
  }

  final year = askInt('Год издания', min: 1000, max: 2100);
  final pages = askInt('Количество страниц', min: 1, max: 10000);

  stdout.write('Жанр: ');
  final genre = (stdin.readLineSync(encoding: utf8) ?? '').trim();
  if (genre.isEmpty) {
    print('Ошибка: жанр не может быть пустым.');
    return;
  }

  stdout.write('Прочитана? (1 - да, 0 - нет): ');
  final readAnswer =
      (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
  final read = readAnswer == 'да' ||
      readAnswer == '1' ||
      readAnswer == 'yes' ||
      readAnswer == 'y';

  books.add({
    'title': title,
    'author': author,
    'year': year,
    'pages': pages,
    'genre': genre,
    'read': read,
  });

  print('Книга «$title» добавлена. Всего книг: ${books.length}');
}

/// Удаление книги по номеру с подтверждением.
void deleteBook(List<Book> books) {
  if (books.isEmpty) {
    print('Каталог пуст — нечего удалять.');
    return;
  }

  print('');
  printAll(books);
  final index = askInt(
    'Введите номер книги для удаления (1..${books.length})',
    min: 1,
    max: books.length,
  );

  final book = books[index - 1];
  stdout.write('Удалить «${book['title']}»? (1 - да, 0 - нет): ');
  final answer =
      (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
  final confirm = answer == 'да' ||
      answer == '1' ||
      answer == 'yes' ||
      answer == 'y';

  if (confirm) {
    books.removeAt(index - 1);
    print('Книга удалена. Осталось книг: ${books.length}');
  } else {
    print('Удаление отменено.');
  }
}

// Задание 2: Главное меню

void main() {
  var running = true;
  final commandCounter = makeCounter(); // счётчик выполненных команд

  while (running) {
    printMenu();
    stdout.write('> ');
    final command = stdin.readLineSync(encoding: utf8)?.trim() ?? '';

    // увеличиваем счётчик при каждой команде, кроме выхода
    if (command != '0') {
      commandCounter();
    }

    switch (command) {
      case '1':
        printAll(library);
        break;

      case '2':
        stdout.write('Введите автора (подстрока): ');
        final authorQuery = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        printAll(
          searchByField(library, 'author', authorQuery),
          emptyMessage: 'По автору «$authorQuery» ничего не найдено.',
        );
        break;

      case '3':
        stdout.write('Введите название (подстрока): ');
        final titleQuery = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        printAll(
          searchByField(library, 'title', titleQuery),
          emptyMessage: 'По названию «$titleQuery» ничего не найдено.',
        );
        break;

      case '4':
        stdout.write('Введите жанр: ');
        final genre = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        printAll(
          searchByField(library, 'genre', genre),
          emptyMessage: 'Жанр «$genre» не найден.',
        );
        break;

      case '5':
        stdout.write('Показать прочитанные? (1 - да, 0 - нет): ');
        final answer =
            (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
        final isRead = answer == 'да' ||
            answer == '1' ||
            answer == 'yes' ||
            answer == 'y';
        printAll(
          filterByRead(library, isRead),
          emptyMessage: isRead
              ? 'Прочитанных книг нет.'
              : 'Непрочитанных книг нет.',
        );
        break;

      case '6':
        stdout.write('Сортировать по (title/author/year/pages): ');
        final field = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        stdout.write('По убыванию? (1 - да, 0 - нет): ');
        final descAnswer =
            (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
        final descending = descAnswer == 'да' ||
            descAnswer == '1' ||
            descAnswer == 'yes' ||
            descAnswer == 'y';
        printAll(sortBy(library, field, descending: descending));
        break;

      case '7':
        printStatistics(library);
        break;

      case '8':
        addBook(library);
        break;

      case '9':
        deleteBook(library);
        break;

      case '10':
        demoHigherOrder(library);
        break;

      case '0':
        running = false;
        break;

      default:
        print('Неизвестная команда. Повторите ввод.');
    }
  }

  // Вывод счётчика выполненных команд
  print('');
  print('Работа завершена. Выполнено команд: ${commandCounter() - 1}');
}

// Функция вывода меню
void printMenu() {
  print('');
  print('КАТАЛОГ BOOKSHELF');
  print('1. Показать весь каталог');
  print('2. Поиск по автору');
  print('3. Поиск по названию');
  print('4. Фильтр по жанру');
  print('5. Фильтр по признаку «прочитана»');
  print('6. Сортировка');
  print('7. Статистика каталога');
  print('8. Добавить книгу');
  print('9. Удалить книгу по номеру');
  print('10. Демонстрация функций высшего порядка');
  print('0. Выход');
}