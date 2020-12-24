//RaisedButton(
//              child: Text("Write data"),
//              onPressed: () {
//                writeData();
//              },
//            ),
//            RaisedButton(
//              child: Text("Read data"),
//              onPressed: () {
//                readData();
//              },
//            ),
//            RaisedButton(
//              child: Text("Update data"),
//              onPressed: () {
//                updateData();
//              },
//            ),
//            RaisedButton(
//              child: Text("Delete data"),
//              onPressed: () {
//                deleteData();
//              },
//            ),

//  void writeData() {
//    referenceDatabase.child("1").set({
//      'id': 'ID1',
//      'data': 'This is a sample Data',
//    });
//  }
//
//  void readData() {
//    referenceDatabase.once().then((DataSnapshot dataSnapshot) {
//      print(dataSnapshot.value);
//    });
//  }
//
//  void updateData() {
//    referenceDatabase.child("1").update({
//      'data': 'This is a update Data',
//    });
//  }
//
//  void deleteData() {
//    referenceDatabase.child("1").remove();
//  }
//}

//class Item {
//String key;
//String title;
//String body;
//
//Item(this.title, this.body);
//
//Item.fromSnapshot(DataSnapshot snapshot)
//    : key = snapshot.key,
//title = snapshot.value["title"],
//body = snapshot.value["body"];
//
//toJson() {
//return {
//"title": title,
//"body": body,
//};
//}
