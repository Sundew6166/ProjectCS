import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/ReviewController.dart';

class Recommendation {
  Future<List> getRecommend() async {
    var myBook = await BookController().getAllMyBook();
    var allBook = await BookController().getAllBookInLibrary("ADMIN");
    var output = [];

    myBook.forEach((elementMy) {
      allBook.removeWhere((elementAll) => elementAll!['isbn'] == elementMy!['isbn']);
    });

    for (var book in myBook) {
      var tmp = allBook.where((element) => element!['author'].toLowerCase() == book!['author'].toLowerCase());
      output.addAll(tmp);
      for (var element in tmp.toList()) {
        allBook.removeWhere((elementAll) => elementAll!['isbn'] == element!['isbn']);
      }
      
      tmp = allBook.where((element) => element!['publisher'].toLowerCase() == book!['publisher'].toLowerCase());
      output.addAll(tmp);
      for (var element in tmp.toList()) {
        allBook.removeWhere((elementAll) => elementAll!['isbn'] == element!['isbn']);
      }

      for (var type in book!['types']) {
        tmp = allBook.where((element) => element!['types'].contains(type));
        output.addAll(tmp);
        for (var element in tmp.toList()) {
          allBook.removeWhere((elementAll) => elementAll!['isbn'] == element!['isbn']);
        }
      }
    }

    if (output.isNotEmpty) {
      output.sort((a, b) => b!['updateDateTime'].compareTo(a!['updateDateTime']));
    } else {
      Map<String, dynamic> sumRating = {};
      await ReviewController().getAllReview().then((value) {
        for (var review in value) {
          if (sumRating.containsKey(review['ID_Book'])) {
            sumRating[review['ID_Book']][0] = sumRating[review['ID_Book']][0] + review['Rating'];
            sumRating[review['ID_Book']][1] = sumRating[review['ID_Book']][1] + 1;
          } else {
            sumRating[review['ID_Book']] = [review['Rating'], 1];
          }
        }
      });
      sumRating.forEach((key, value) {
        sumRating[key] = value[0] / value[1];
      });
      var listSumRating = sumRating.entries.toList();
      listSumRating.sort((a, b) => a.value.compareTo(b.value));
      for (var book in listSumRating) {
        var splitID = book.key.split('_');
        output.addAll(allBook.where((elementAll) => elementAll!['isbn'] == splitID[0] && elementAll['edition'] == splitID[1]));
        for (var element in output) {
          allBook.removeWhere((elementAll) => elementAll!['isbn'] == element!['isbn']);
        }
      }
      allBook.sort((a, b) => b!['updateDateTime'].compareTo(a!['updateDateTime']));
      output.addAll(allBook);
    }

    return output;
  }
}