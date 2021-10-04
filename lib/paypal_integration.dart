import 'package:appmapas/paypalservices/paypalservices.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
class Paypal extends StatefulWidget {
  final Function onFinish;
  const Paypal({Key key, this.onFinish}) : super(key: key);

  @override
  _PaypalState createState() => _PaypalState();
}

class _PaypalState extends State<Paypal> {
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAcessToken();
        final transactions = getOrderParams();
        final res  =  await services.createPaypalPayment(transactions, accessToken);
        if(res != null){
          setState(() {
            checkoutUrl = res['approvalUrl'];
            executeUrl = res['executeUrl'];
          });
        }
      }catch (e){
        print('exeception:'+e.toString());
      }
    });
  }
  String returnUrl = "return.example.com";
  String cancelUrl = "cancel.example.com";
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "BRL",
    "decimalDigints": 2,
    "symbolBeforeTheNumber": true,
    "currency": "BRL"
  };
  bool isEnableShipping = false;
  bool isEnableAddress = false;

  Map<String, dynamic>getOrderParams() {
    List items =  [
      {
        "name" : 'pao com ovo',
        "quantity":1,
        "price": "45.00",
      "currency": defaultCurrency["currency"]
      }
    ];
    //checkou invoice details
    String totalAmount = '45.00';
    String subTotalAmount = '45.00';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'wendell';
    String userLastName = 'Peres';
    String addressCity = 'Manaus';
    String addressStreet = 'Rua Alvinopolis';
    String addressZipCode = '69028020';
    String addressCountry = 'Brasil';
    String addressState = 'Amazonas';
    String addressPhoneNumber = '+5597988036412';


    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer" : {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal" : subTotalAmount,
              "shipping" : shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "the payment transaction description",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list":{
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address":{
              "recipient_name": userFirstName + ' ' + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              }
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your onder.",
      "redirect_urls": {"return_url": returnUrl, "cancel_url": cancelUrl}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if(checkoutUrl != null )
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: WebView(
        initialUrl: checkoutUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request){
          if(request.url.contains(returnUrl)){
            final uri = Uri.parse(request.url);
            final payerID = uri.queryParameters['PayerID'];
            if(payerID != null){
              services.executePayment(executeUrl, payerID, accessToken).then((id){
                widget.onFinish(id);
                Navigator.pop(context);
              });
            }else{
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('nao deu certo'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('não foi')
          ],
        ),
      ),
    );
  }
}
