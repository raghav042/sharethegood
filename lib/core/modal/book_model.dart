class BookModel {
  const BookModel({
    required this.bookName,
    required this.authorName,
    required this.numberOfBooks,
    required this.imagePath,
  });
  final String bookName;
  final String authorName;
  final int numberOfBooks;
  final String imagePath;
}
