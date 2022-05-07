import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/connect.dart';
import '../pages/login.dart';
List items = [];
class done extends StatefulWidget {
  const done({Key? key}) : super(key: key);

  @override
  _doneState createState() => _doneState();
}

class _doneState extends State<done> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItems();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await CoolAlert.show(
          barrierDismissible: false,
          context: context,
          type: CoolAlertType.loading,
          text: "جاري التحميل"
      );

    });
  }
  late SharedPreferences prefs;
  late String token3;
  Future getItems() async {

    prefs = await SharedPreferences.getInstance();
    token3 = prefs.getString('token') ?? "";
    var url = Uri.parse(Apis.Api + 'items.php?token=' + token3 + '&stat=واصل');

    http.Response response = await http.get(url);
    var  data = json.decode(response.body);
    print(data);
    setState(() {

      items = data;

    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return  Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(

          body: Container(

            child: (items.isEmpty)? const Padding(


              padding: EdgeInsets.only(top: 40),
              child: Text("..."),
            ) : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i){
                  return Padding(padding:  EdgeInsets.all(10)
                    ,child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(

                          color: Colors.green,
                          borderRadius:  BorderRadius.all(
                              Radius.circular(10.0))
                      ),
                      child: Column(
                        children:  [

                          Text(items[i]['number'] + "#" , style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children:  [
                              Text("المحافظة : " + items[i]['city'] ,style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("المنطقة : " + items[i]['address'] , style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),

                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children:  [
                              Text("المبلغ الكلي : " + items[i]['total'] ,style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("المبلغ الصافي : " + items[i]['price'] , style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),

                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children:  [
                              Text("الهاتف : " + items[i]['phone'] ,style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("التاريخ : " + items[i]['date'] , style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),

                            ],
                          ),


                        ],
                      ),

                    ),

                  );

                }),
          ),

        )
    );
  }
}
