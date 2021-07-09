// import 'dart:html';
// import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'Navigation Basics',
//     home: MyApp(),
//   ));
// }
// final Future<FirebaseApp> _initialization = Firebase.initializeApp();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'MyApp',
    home: MyApp(),
    theme: new ThemeData(backgroundColor: Colors.white),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _selectedIndex = 0;

  // FirebaseFirestore db = FirebaseFirestore.instance;
  // CollectionReference cities = db.collection("cities");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey[700],
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '오늘의 기도',
            icon: Icon(Icons.today),
          ),
          BottomNavigationBarItem(
            label: '나의 기도',
            icon: Icon(Icons.volunteer_activism_outlined),
          ),
          BottomNavigationBarItem(
            label: '중보자',
            icon: Icon(Icons.supervisor_account),
          ),
          BottomNavigationBarItem(
            label: '중보자 되기',
            icon: Icon(Icons.supervisor_account),
          ),
          BottomNavigationBarItem(
            label: '설정',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }

  List _widgetOptions = [_Page1(), _Page2(), _Page3(), _Page4(), _Page5()];
}

class _Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<_Page1> {
  var userNickname_fix = "Juo";
  final firestoreInstance = FirebaseFirestore.instance;

  List subscribeList = [];
  var sub_loadIdx = false;
  List _element = [];
  var loadMyIdx = false;
  var loadIdx = false;
  var loadNo;

  init() {
    // print(_element);
    // return lodingData();
    if (!loadMyIdx && !loadIdx)
      lodingMyData();
    else if (loadMyIdx && !loadIdx)
      lodingData();
    else if (loadMyIdx && loadIdx) return displayPrayListScreen();
  }

  lodingMyData() {
    firestoreInstance
        .collection("pray")
        .where("userNickname", isEqualTo: userNickname_fix)
        .get()
        .then((querySnapshot1) {
      if (querySnapshot1.docs.isNotEmpty) {
        querySnapshot1.docs.forEach((result1) {
          var prayTemp1 = result1.data();
          var tempList1 = {
            'pray': prayTemp1['pray'],
            'prayPrivate': prayTemp1['prayPrivate'],
            'userNickname': prayTemp1['userNickname'],
          };
          this._element.add(tempList1);
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        // print(_element);
        loadMyIdx = true;
      });
    });
  }

  lodingData() {
    var subscribeListTemp = [];
    firestoreInstance
        .collection("subscribe")
        .where("userNickname", isEqualTo: userNickname_fix)
        .get()
        .then((querySnapshot2) {
      if (querySnapshot2.docs.isNotEmpty) {
        querySnapshot2.docs.forEach((result2) {
          var _subscribeListTemp = result2.data();
          subscribeListTemp.add(_subscribeListTemp);

          firestoreInstance
              .collection("pray")
              .where("userNickname",
                  isEqualTo: _subscribeListTemp['sub_userNickname'])
              .get()
              .then((querySnapshot4) {
            if (querySnapshot4.docs.isNotEmpty) {
              querySnapshot4.docs.forEach((result4) {
                var prayTemp2 = result4.data();
                var tempList2 = {
                  'pray': prayTemp2['pray'],
                  'prayPrivate': prayTemp2['prayPrivate'],
                  'userNickname': prayTemp2['userNickname'],
                };
                this._element.add(tempList2);
              });
            }
          });
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        loadIdx = true;
      });
    });
  }

  displayPrayListScreen() {
    return Center(
        child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: GroupedListView<dynamic, String>(
              elements: _element,
              groupBy: (element) => "# " + element['userNickname'],
              order: GroupedListOrder.DESC,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 25, bottom: 15),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (c, element) {
                return Card(
                  elevation: 2.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                  child: Container(
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      title: Text(
                        element['pray'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 기도', style: TextStyle(color: Colors.black26)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: init(),
    );
  }
}

class _Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<_Page2> {
  var userNickname_fix = "Juo";
  final MaxPrayCount = 10;
  final firestoreInstance = FirebaseFirestore.instance;

  AppBar header() {
    return AppBar(
      title: Text('나의 기도', style: TextStyle(color: Colors.black26)),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  List data = [];
  var loadIdx = false;
  List selectedData = [];
  var selectedIdx = null;

  loadList() {
    if (selectedIdx == null) {
      if (!loadIdx) {
        data = [];
        firestoreInstance
            .collection("pray")
            .where("userNickname", isEqualTo: userNickname_fix)
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.forEach((result) {
              var datas = result.data();

              var tempList = {
                'userNickname': datas['userNickname'],
                'pray': datas['pray'],
                'prayPrivate': datas['prayPrivate'],
                'docId': result.id,
              };
              // print(tempList);
              this.data.add(tempList);
            });
          }
        }).whenComplete(() => setState(() {
                  // print(this.data);
                  loadIdx = true;
                }));
      } else {
        // print(data);
        return displayPrayListScreen();
        // return Text("123");
      }
    } else {
      return displayEditPrayScreen();
    }
  }

  selectLoding(var docID) {
    data = [];
    selectedData = [];
    firestoreInstance.collection("pray").doc(docID).get().then((querySnapshot) {
      var datas = querySnapshot.data();
      selectedData.add(datas);
    }).whenComplete(() => setState(() {
          // print(selectedData);
          selectedIdx = docID;
        }));
  }

  displayNoSearchResultScreen() {
    return Text("");
  }

  displayPrayListScreen() {
    // print("load");
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          return ((index < data.length)
              ? (Card(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(data[index]['pray']))),
                          Expanded(
                            flex: 3,
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      selectLoding(data[index]['docId']);
                                    })),
                          )
                        ],
                      ))))
              : ((data.length < MaxPrayCount)
                  ? (Card(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            data = [];
                                            loadIdx = false;
                                            selectedIdx = -1;
                                            selectedData = [];
                                          });
                                          // DeleteSubscribe(data[index]['subscribe'],
                                          // data[index]['userNickname']);
                                        })),
                              )
                            ],
                          ))))
                  : Text("")));
        });
  }

  displayEditPrayScreen() {
    // print(selectedData);
    TextEditingController prayTextEditController;
    var tempPray;

    if (selectedIdx != -1) {
      var privateIdx = selectedData[0]['prayPrivate'];

      prayTextEditController =
          new TextEditingController(text: selectedData[0]['pray']);
      return Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "기도제목",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      )),
                  Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: TextField(
                      controller: prayTextEditController,
                      onChanged: (text) {
                        // setState(() {
                        tempPray = text;
                        // print(text);
                        // print(tempPray);
                        // });
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 5,
                            child: Text(
                              "공개",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            )),
                        Expanded(
                            flex: 1,
                            child: Switch(
                              value: privateIdx,
                              onChanged: (value) {
                                privateIdx = value;
                                selectedData[0]['prayPrivate'] = privateIdx;
                                updateToggle(privateIdx);
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            )),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 6,
                            child: Text(
                              "삭제",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            )),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => {
                                setState(() {
                                  deletePray();
                                })
                              },
                            )),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: ElevatedButton(
                                  child: Text(
                                    "취소",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                  onPressed: () => {
                                    setState(() {
                                      data = [];
                                      loadIdx = false;
                                      selectedIdx = null;
                                      selectedData = [];
                                    })
                                  },
                                ))),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: ElevatedButton(
                                  child: Text(
                                    "저장",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                  onPressed: () => {updatePray(tempPray)},
                                ))),
                      ])),
                ],
              )));
    } else {
      var privateIdx = true;
      prayTextEditController = new TextEditingController();
      return Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "기도제목",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      )),
                  Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: TextField(
                      controller: prayTextEditController,
                      onChanged: (text) {
                        tempPray = text;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 5,
                            child: Text(
                              "공개",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            )),
                        Expanded(
                            flex: 1,
                            child: Switch(
                              value: privateIdx,
                              onChanged: (value) {
                                privateIdx = value;
                                selectedData[0]['prayPrivate'] = privateIdx;
                                updateToggle(privateIdx);
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            )),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 6,
                            child: Text(
                              "삭제",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            )),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => {
                                setState(() {
                                  deletePray();
                                })
                              },
                            )),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: ElevatedButton(
                                  child: Text(
                                    "취소",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                  onPressed: () => {
                                    setState(() {
                                      data = [];
                                      loadIdx = false;
                                      selectedIdx = null;
                                      selectedData = [];
                                    })
                                  },
                                ))),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: ElevatedButton(
                                  child: Text(
                                    "저장",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                  onPressed: () =>
                                      {addPray(tempPray, privateIdx)},
                                ))),
                      ])),
                ],
              )));
    }
  }

  updateToggle(var privateIdx) {
    // print(selectedIdx);
    // print(privateIdx);
    firestoreInstance
        .collection("pray")
        .doc(selectedIdx)
        .update({'prayPrivate': privateIdx}).whenComplete(() => setState(() {
              data = [];
              loadIdx = false;
              selectedIdx = null;
              selectedData = [];
            }));
  }

  updatePray(var pray) {
    // print(selectedIdx);
    // print(pray);
    firestoreInstance
        .collection("pray")
        .doc(selectedIdx)
        .update({'pray': pray}).whenComplete(() => setState(() {
              data = [];
              loadIdx = false;
              selectedIdx = null;
              selectedData = [];
            }));
  }

  addPray(var pray, var privateIdx) {
    // print(selectedIdx);
    // print(pray);
    firestoreInstance.collection("pray").add({
      'userNickname': userNickname_fix,
      'prayPrivate': privateIdx,
      'pray': pray
    }).whenComplete(() => setState(() {
          data = [];
          loadIdx = false;
          selectedIdx = null;
          selectedData = [];
        }));
  }

  deletePray() {
    // print(selectedIdx);
    // print(pray);
    firestoreInstance
        .collection("pray")
        .doc(selectedIdx)
        .delete()
        .whenComplete(() => setState(() {
              data = [];
              loadIdx = false;
              selectedIdx = null;
              selectedData = [];
            }));
  }

  addBtnShow() {
    return Card(child: Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: header(), body: loadList());
  }
}

class _Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<_Page3> {
  var userNickname_fix = "Juo";
  final firestoreInstance = FirebaseFirestore.instance;

  AppBar header() {
    return AppBar(
      title: Text('중보자', style: TextStyle(color: Colors.black26)),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  List data = [];

  loadList() {
    if (data.length == 0) {
      firestoreInstance
          .collection("subscribe")
          .where("userNickname", isEqualTo: userNickname_fix)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((result) {
            var temp = result.data();

            firestoreInstance
                .collection("user")
                .where("userNickname", isEqualTo: temp['sub_userNickname'])
                .get()
                .then((querySnapshot2) {
              if (querySnapshot2.docs.isNotEmpty) {
                querySnapshot2.docs.forEach((result2) {
                  var datas = result2.data();
                  var tempList = {
                    'userNickname': datas['userNickname'],
                    'userEmail': datas['userEmail'],
                    'userCode': datas['userCode'],
                    'subscribe': result.id
                  };
                  // print(tempList);
                  this.data.add(tempList);
                });
              }
            });
          });
        }
      }).whenComplete(() => setState(() {
                // this.data = [];
                // print(this.data);
              }));
    } else {
      return displayUserFoundScreen();
    }
  }

  displayNoSearchResultScreen() {
    return Text("");
  }

  displayUserFoundScreen() {
    // print("load");
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 7,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(data[index]['userNickname']))),
                Expanded(
                  flex: 3,
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            DeleteSubscribe(data[index]['subscribe'],
                                data[index]['userNickname']);
                          })),
                )
              ],
            ),
          ));
        });
  }

  DeleteSubscribe(var docID, var userNickname) {
    // print(docID);
    // print(userNickname);
    firestoreInstance.collection("subscribe").doc(docID).delete();
    setState(() {
      this.data = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: loadList(),
    );
  }
}

class _Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  var userNickname_fix = "Juo";
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController searchTextEditingController = TextEditingController();
  // Future<int> futureSearchResults;
  // var futureSearchResults = "123";

  AppBar searchPageHeader() {
    return AppBar(
      title: TextFormField(
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: '별명 / 이메일',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          filled: true,
          prefixIcon: Icon(Icons.person_pin, color: Colors.black54, size: 30),
          suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.black54),
              onPressed: emptyTheTextFormField()),
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 18, color: Colors.black54),
        onFieldSubmitted: controlSearching,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  List data = [];

  emptyTheTextFormField() {
    setState(() {
      // this.data = [];
      // print(this.data);
    });
    searchTextEditingController.clear();
  }

  controlSearching(str) {
    // print(str);
    firestoreInstance
        .collection("user")
        .where("userNickname", isEqualTo: str)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((result) {
          var datas = result.data();

          firestoreInstance
              .collection("subscribe")
              .where("userNickname", isEqualTo: userNickname_fix)
              .where("sub_userNickname", isEqualTo: datas['userNickname'])
              .get()
              .then((querySnapshot2) {
            if (querySnapshot2.docs.isNotEmpty) {
              querySnapshot2.docs.forEach((result2) {
                // print(result2.id);

                this.data = [
                  {
                    'userNickname': datas['userNickname'],
                    'userEmail': datas['userEmail'],
                    'userCode': datas['userCode'],
                    'subscribe': result2.id
                  }
                ];
                setState(() {
                  // print(this.data);
                });
              });
            } else {
              this.data = [
                {
                  'userNickname': datas['userNickname'],
                  'userEmail': datas['userEmail'],
                  'userCode': datas['userCode'],
                  'subscribe': false,
                }
              ];
              setState(() {
                // print(this.data);
              });
            }
          });
        });
      } else {
        this.data = [];
        setState(() {
          // print(this.data);
        });
      }
    });
  }

  AddSubscribe(var sub_userNickname) {
    // print(userCode);
    firestoreInstance.collection("subscribe").add({
      "userNickname": userNickname_fix,
      "sub_userNickname": sub_userNickname,
      "topFixIdx": "0",
      "setDate": "1/1/1/1/1/1/1",
      "order": "1"
    });

    controlSearching(sub_userNickname);
  }

  DeleteSubscribe(var docID, var userNickname) {
    // print(docID);
    firestoreInstance.collection("subscribe").doc(docID).delete();
    controlSearching(userNickname);
  }

  displayNoSearchResultScreen() {
    return Text("");
  }

  displayUserFoundScreen() {
    return ListView(padding: EdgeInsets.all(10), children: <Widget>[
      Card(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
                flex: 7,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(data[0]['userNickname']))),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: (data[0]['subscribe'] == false
                          ? Icon(Icons.add)
                          : Icon(Icons.clear)),
                      onPressed: () {
                        if (data[0]['subscribe'] == false)
                          AddSubscribe(data[0]['userNickname']);
                        else
                          DeleteSubscribe(
                              data[0]['subscribe'], data[0]['userNickname']);
                      })),
            )
          ],
        ),
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: data.length == 0
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),
    );
  }
}

class _Page5 extends StatefulWidget {
  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<_Page5> {
  var userNickname_fix = "Juo";
  final firestoreInstance = FirebaseFirestore.instance;
  var data;
  var pageNo = 0;
  var headerText = "설정";

  AppBar header() {
    return AppBar(
      title: Text(headerText, style: TextStyle(color: Colors.black26)),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  displaySettingListScreen() {
    firestoreInstance
        .collection("user")
        .where("userNickname", isEqualTo: userNickname_fix)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((result) {
          data = result.data();
          // print(data);
        });
      }
    });
    return Column(children: [
      Expanded(
          child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            leading: Icon(Icons.bookmark_add),
            title: Text(
              "공지사항",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text(
              "알람 설정",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () => {
              setState(() {
                headerText = "알람 설정";
                pageNo = 2;
              })
            },
          ),
        ],
      ))
    ]);
  }

  displaySettingAlarmScreen() {
    var hour = (int.parse(data['alarmTime']) / 100).round();
    var min = int.parse(data['alarmTime']) - (hour * 100);
    // print(hour);
    // print(min);
    String _selectedTime;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "시간",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: FlatButton(
                        child: Text(
                          hour.toString() + " : " + min.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          setState(() {
                            // _showTimePicker();
                          });
                        },
                      ),
                    ))
              ],
            )),
        Container(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        child: Text("뒤로가기"),
                        onPressed: () => {
                          setState(() {
                            settingHome();
                          })
                        },
                      ))),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        child: Text("저장"),
                        onPressed: () => {
                          setState(() {
                            // settingHome();
                          })
                        },
                      ))),
            ],
          ),
        )
      ],
    );
  }

  pageShow() {
    if (pageNo == 0) {
      return displaySettingListScreen();
    } else if (pageNo == 2) {
      return displaySettingAlarmScreen();
    }
  }

  settingHome() {
    headerText = "설정";
    pageNo = 0;
  }

  _showTimePicker() {
    // var initialTime = TimeOfDay.now();
    // print(initialTime);

    Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: pageShow(),
    );
  }
}
