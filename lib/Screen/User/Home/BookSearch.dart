import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';

class BookSearch extends StatefulWidget {
  BookSearch({Key? key, required this.books}) : super(key: key);
  List<dynamic> books;

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(0xfff5f3e8), child: BookCard(books: widget.books)));
  }
}

class BookCard extends StatelessWidget {
  BookCard({Key? key, required this.books}) : super(key: key);
  List<dynamic> books;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      // padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: books.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReviewPage(
                            bookInfo: {}, hasBook: false, hasSale: false)),
                  ),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          height: 200,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10), // Image border
                            child: Image.network(
                              books[index]['coverImage'],
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(books[index]['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  books[index]['author'],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]))
                    ],
                  ),
                ),
              ));
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisExtent: 290,
        ),
      ),
    );
  }
}
