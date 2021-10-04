import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
class MercadoPago extends StatefulWidget {
  const MercadoPago({Key key}) : super(key: key);

  @override
  _MercadoPagoState createState() => _MercadoPagoState();
}

class _MercadoPagoState extends State<MercadoPago> {
  String mpTESTPublickey = 'TEST-542ceb1a-8a88-43dd-a7df-a9692426cf7c';
  String mpTESTAcessToken = 'TEST-3229739285312798-021114-11bbba6fe16e24e8122f7fbe0b95422f-181774435';

  String mpPublickey = 'APP_USR-1c23ee5a-fe48-47d5-aa6e-9f987d544bba';
  String mpAcessToken = 'APP_USR-3229739285312798-021114-dce4828db711fedcf4c68013a2728b0d-181774435';

  String mpClientID = '3229739285312798';
  String mpClientSecret = 'QcpanZdLpFaQ3Ks5nSkoYX0oNkIzNUwe';

  var preferenceID;

  Future<Map<String, dynamic>> criarPreferencia() async {
    var mp = MP(mpClientID,  mpClientSecret);
    var preference = {
      "items": [
        {
          "title": "pao com ovo",
          "description": "pao com manteiga e ovo",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": 80
        }
      ],"payer": {
        "email": 'wendel.peres@hotmail.com',
        "name": 'wendell peres',
      }
    };

    var result = await mp.createPreference(preference);

    return result;
  }
  Future<void> executarmercadopago() async{
    criarPreferencia().then((resultado) {
      if (resultado != null){
        preferenceID = resultado['response']['id'];
        print(preferenceID);
        print('RESULTADO VINDO DA API${resultado.toString()}');
      }
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: pagamento'),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  executarmercadopago();
                },
                child: Text("Pagar Teste"),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  PaymentResult result =
                  await MercadoPagoMobileCheckout.startCheckout(
                    'APP_USR-1c23ee5a-fe48-47d5-aa6e-9f987d544bba',
                    preferenceID,
                  );
                  print('Resultado do teste de pagamento${result.toString()}');
                 },
                child: Text("Pagar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
