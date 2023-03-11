import 'package:flutter/material.dart';
import 'package:my_book/Screen/User/Hub/ReviewPage.dart';

class BookSearch extends StatefulWidget {
  const BookSearch({super.key});

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(color: Color(0xfff5f3e8), child: BookCard()));
  }
}

class BookCard extends StatelessWidget {
  const BookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: 6,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewPage(bookInfo: {}, hasBook: false, hasSale: false)),
                  ),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Image.asset(
                          'images/Conan.jpg',
                          fit: BoxFit.fill,
                        ),
                      )),
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ชื่อหนังสือ",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'รายละเอียด',
                                  style: TextStyle(
                                      fontSize: 18),
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
