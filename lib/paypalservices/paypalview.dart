import 'package:appmapas/paypal_integration.dart';
import 'package:flutter/material.dart';

class paypalview extends StatefulWidget {
  const paypalview({Key key}) : super(key: key);

  @override
  _paypalviewState createState() => _paypalviewState();
}

class _paypalviewState extends State<paypalview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('paypal Payment example'),

      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Paypal(onFinish: (number){
                    print('return'+number);
    },))
    );
    },
              child: Text('Pagar')
          )
        ],
      ),
    );
  }
}
