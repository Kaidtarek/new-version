import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class StockwithSearch extends StatefulWidget {
  @override
  _StockwithSearchState createState() => _StockwithSearchState();
}

class _StockwithSearchState extends State<StockwithSearch> {
  late Stream<QuerySnapshot> _productStream;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _productStream =
        FirebaseFirestore.instance.collection('Products').snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "المستودع :",
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: _productStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<Widget> productList =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                String docId = document.reference.id;
                print("This is doc ID: $docId");
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String productName = data['Product_name'];

                // Filter the product list based on search text
                if (_searchText.isNotEmpty &&
                    !productName
                        .toLowerCase()
                        .contains(_searchText.toLowerCase())) {
                  return SizedBox.shrink();
                }

                return Card(
                  color: Colors.grey[400],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text("المنتوج: $productName"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text("الكمية: ${data['Quantity']}"),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList();

              return ListView(children: productList);
            },
          ),
        ),
      ],
    );
  }
}

