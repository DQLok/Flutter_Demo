import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class HomePage extends StatelessWidget {

  Future<void>  _signOut(BuildContext context) async{
    final auth=Provider.of<AuthBase>(context,listen: false);
    try{
    await auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async{
    final didRequestSignOut = await showAlertDialog(context, title: 'Logout', content: 'Are you sure that you want to logout?', defaultActionText: 'Logout',cancelActionText: 'Cancel');
    if(didRequestSignOut==true) _signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white70),
              ),
              onPressed: ()=>_confirmSignOut(context),
              ),
        ],
      ),
    );
  }
}
