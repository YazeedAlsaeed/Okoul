import 'package:flutter/material.dart';
import 'package:okoul_project/utils/constants.dart';
import 'package:okoul_project/utils/layouts.dart';
import 'package:okoul_project/utils/main_text.dart';

class ThekerPage extends StatefulWidget {
  const ThekerPage({super.key});

  @override
  State<ThekerPage> createState() => _ThekerPageState();
}

class _ThekerPageState extends State<ThekerPage>
    with AutomaticKeepAliveClientMixin<ThekerPage> {
  List<List<dynamic>> thekerMap = [
    ["سبحان لله", false, 0],
    ["لا اله الا الله", false, 0],
    ["الله اكبر", false, 0],
    ["استغفرالله", false, 0],
    ["لا اله الا الله", false, 0],
  ];

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Layouts.size15),
        child: Container(),
      ),
      backgroundColor: Constants.backgroundColor,
      body: ListView.builder(
          shrinkWrap: false,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: thekerMap.length,
          itemBuilder: (context, index) {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Layouts.size45),
                  ),
                  color: Colors.white,
                ),
                margin: EdgeInsets.all(Layouts.size15),
                padding: EdgeInsets.fromLTRB(Layouts.size45, Layouts.size15,
                    Layouts.size10, Layouts.size15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: Layouts.size75),
                          child: MainText(
                            text: thekerMap[index][0],
                            textAlignment: TextAlign.end,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              thekerMap[index][1] = !thekerMap[index][1];
                              reArrangeList();
                            });
                          },
                          icon: Icon(
                            thekerMap[index][1]
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            color: Constants.alterColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Layouts.size35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, Layouts.size10, 0),
                                  onPressed: () {
                                    setState(() {
                                      thekerMap[index][2] =
                                          ((thekerMap[index][2] - 1) < 0
                                              ? 0
                                              : (thekerMap[index][2] - 1));
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_circle_rounded,
                                    size: Layouts.size45,
                                    color: Constants.mainColor,
                                  ),
                                ),
                                SizedBox(
                                  width: Layouts.size25,
                                ),
                                MainText(
                                  text: thekerMap[index][2].toString(),
                                  textAlignment: TextAlign.center,
                                ),
                                SizedBox(
                                  width: Layouts.size25,
                                ),
                                IconButton(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, Layouts.size10, 0),
                                  onPressed: () {
                                    setState(() {
                                      thekerMap[index][2] += 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add_circle_rounded,
                                    size: Layouts.size45,
                                    color: Constants.mainColor,
                                  ),
                                ),
                              ]),
                        ),
                        // SizedBox(
                        //   width: Layout.size45,
                        // ),
                        Container(
                          margin: EdgeInsets.only(left: Layouts.size45),
                          child: IconButton(
                            padding:
                                EdgeInsets.fromLTRB(0, 0, Layouts.size25, 0),
                            onPressed: () {
                              setState(() {
                                thekerMap[index][2] = 0;
                              });
                            },
                            icon: Icon(
                              Icons.refresh,
                              size: Layouts.size45,
                              color: Constants.alterColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  void reArrangeList() {
    List<List<dynamic>> L = [];
    for (int i = 0; i < thekerMap.length; i++) {
      if (thekerMap[i][1]) {
        L.add(thekerMap[i]);
      }
    }
    for (int i = 0; i < thekerMap.length; i++) {
      if (!thekerMap[i][1]) {
        L.add(thekerMap[i]);
      }
    }
    thekerMap = L;
  }
}
