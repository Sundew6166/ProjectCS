import 'package:my_book/Service/BookController.dart';
import 'package:my_book/Service/PostController.dart';
import 'package:my_book/Service/SaleController.dart';

class SearchController {
  Future<List<dynamic>> getPosts(String item) async {
    List<dynamic> allPost = await PostController().getPostAll();
    item = item.toLowerCase();

    List<dynamic> output = [];

    for (var element in allPost) {
      if (element['Detail_Post'].toLowerCase().contains(item)) {
        output.add(element);
      }
    }
    return output;
  }

  Future<List<dynamic>> getBooks(String item) async {
    List<dynamic> allBook = await BookController().getAllBookInLibrary('ADMIN');
    item = item.toLowerCase();

    List<dynamic> output = [];

    for (var element in allBook) {
      if (element['title'].toLowerCase().contains(item) ||
          element['author'].toLowerCase().contains(item) ||
          element['synopsys'].toLowerCase().contains(item) ||
          element['publisher'].toLowerCase().contains(item)) {
        output.add(element);
      } else {
        for (var data in element['types']) {
          if (data.toLowerCase().contains(item)) {
            output.add(element);
          }
        }
      }
    }
    // print(output);
    return output;
  }

  Future<List<dynamic>> getSales(String item) async {
    List<dynamic> allBook = await SaleController().getAllSale();
    item = item.toLowerCase();

    List<dynamic> output = [];

    for (var element in allBook) {
      // print('>>>>>> ${element}');
      if (element['book']['title'].toLowerCase().contains(item) ||
          element['book']['author'].toLowerCase().contains(item) ||
          element['book']['publisher'].toLowerCase().contains(item) ||
          element['book']['synopsys'].toLowerCase().contains(item) ||
          element['detail'].toLowerCase().contains(item)) {
        output.add(element);
      } else {
        for (var data in element['book']['types']) {
          if (data.toLowerCase().contains(item)) {
            output.add(element);
          }
        }
      }
    }
    // print(output);
    return output;
  }
}
