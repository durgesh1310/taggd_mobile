import 'package:flutter/material.dart';
import 'package:ouat/data/models/message.dart';
import '../size_config.dart';

class MessageScreen extends StatelessWidget {
  List<Message>? message;
  MessageScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: message!.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          if(message![index].msgType == "ERROR"){
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5
              ),
              child: ListTile(
                minLeadingWidth: 10,
                tileColor: Color(0xfffad7da),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10
                ),
                leading: Image.asset(
                  "assets/image/Key_red.jpg",
                  height: 20,
                ),
                title: Text(
                  "${message![index].msgText}",
                  style: TextStyle(
                      fontSize: 1.5*SizeConfig.textMultiplier,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            );
          }
          else if(message![index].msgType == "WARNING"){
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3
              ),
              child: ListTile(
                minLeadingWidth: 10,
                tileColor: Color(0xfffff3cd),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10
                ),
                leading: Image.asset(
                  "assets/image/key_Yellow.jpg",
                  height: 20,
                ),
                title: Text(
                  "${message![index].msgText}",
                  style: TextStyle(
                      fontSize: 1.5*SizeConfig.textMultiplier,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            );
          }
          else{
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3
              ),
              child: ListTile(
                minLeadingWidth: 10,
                tileColor: Colors.green[100],
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10
                ),
                leading: Image.asset(
                  "assets/image/Key_green.jpg",
                  height: 20,
                ),
                title: Text(
                  "${message![index].msgText}",
                  style: TextStyle(
                      fontSize: 1.5*SizeConfig.textMultiplier,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}
