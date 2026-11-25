import 'reading_status.dart';
import 'library_item.dart';

// Задание 5: Миксины
mixin Rateable {
  double _totalRating = 0;
  int _votes = 0;

  double get averageRating => _votes == 0 ? 0 : _totalRating / _votes;

  void vote(double rating) {
    _totalRating += rating;
    _votes++;
  }
}

mixin Loggable {
  void log(String message) {
    final now = DateTime.now();
    print('[${now.hour}:${now.minute}:${now.second}] $message');
  }
}

mixin Borrowable on Book {
  DateTime? _dueDate;

  bool get isBorrowed => _dueDate != null && _dueDate!.isAfter(DateTime.now());

  void borrow(int days) {
    _dueDate = DateTime.now().add(Duration(days: days));
    print('Книга «$title» выдана до ${_dueDate.toString().split(' ')[0]}');
  }

  void giveBack() {
    _dueDate = null;
    print('Книга «$title» возвращена.');
  }
}

// Задание 4: Интерфейсы
abstract interface class Searchable {
  bool matches(String query);
}

abstract interface class Exportable {
  Map<String, dynamic> toJson();
}

// Задание 2 + 6: Класс Book
class Book extends LibraryItem 
    with Rateable, Loggable 
    implements Searchable, Exportable, Comparable<Book> {
  
  @override
  final String title;
  final String author;
  final int year;
  final int pages;
  final Set<String> genres;
  ReadingStatus status;
  double? _rating;

  Book({
    required this.title,
    required this.author,
    this.year = 0,
    this.pages = 0,
    Set<String>? genres,
    this.status = ReadingStatus.planned,
    double? rating,
  })  : genres = genres ?? {},
        _rating = rating {
    if (rating != null && (rating < 0 || rating > 5)) {
      throw ArgumentError('Оценка должна быть от 0 до 5');
    }
  }

  // Геттеры
  String get shortTitle => title.length > 20 ? '${title.substring(0, 17)}...' : title;
  double get readingHours => pages / 50;
  int get age => DateTime.now().year - year;
  bool get isRated => _rating != null;

  double? get rating => _rating;
  
  set rating(double? value) {
    if (value != null && (value < 0 || value > 5)) {
      throw ArgumentError('Оценка должна быть от 0 до 5');
    }
    _rating = value;
  }

  // Задание 4: реализация интерфейсов
  @override
  bool matches(String query) {
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        author.toLowerCase().contains(q) ||
        genres.any((g) => g.toLowerCase().contains(q));
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': runtimeType.toString(),
        'title': title,
        'author': author,
        'year': year,
        'pages': pages,
        'genres': genres.toList(),
        'status': status.name,
        'rating': _rating,
      };

  @override
  String describe() => '«$title» — $author, $year г., $pages стр.';

  // Задание 6: Специальные методы
  @override
  String toString() => 'Book($title, $author, $year)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          author == other.author &&
          year == other.year;

  @override
  int get hashCode => Object.hash(title, author, year);

  @override
  int compareTo(Book other) => title.compareTo(other.title);

  Book copyWith({
    String? title,
    String? author,
    int? year,
    int? pages,
    Set<String>? genres,
    ReadingStatus? status,
    double? rating,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      rating: rating ?? _rating,
    );
  }
}

// Задание 3: Иерархия наследников

class PaperBook extends Book with Borrowable {
  final String shelf;
  bool isBorrowed;

  PaperBook({
    required super.title,
    required super.author,
    super.year,
    super.pages,
    super.genres,
    super.status,
    super.rating,
    required this.shelf,
    this.isBorrowed = false,
  });

  @override
  String describe() => '«$title» [Печатная] — $author, полка: $shelf';
}

class EBook extends Book {
  final String format;
  final double sizeMb;

  EBook({
    required super.title,
    required super.author,
    super.year,
    super.pages,
    super.genres,
    super.status,
    super.rating,
    required this.format,
    required this.sizeMb,
  });

  @override
  String describe() => '«$title» [Электронная] — $author, $format, $sizeMb МБ';
}

class AudioBook extends Book {
  final Duration duration;
  final String narrator;

  AudioBook({
    required super.title,
    required super.author,
    super.year,
    super.pages,
    super.genres,
    super.status,
    super.rating,
    required this.duration,
    required this.narrator,
  });

  @override
  double get readingHours => duration.inMinutes / 60;

  @override
  String describe() => '«$title» [Аудио] — $author, читает $narrator, ${duration.inMinutes} мин.';
}