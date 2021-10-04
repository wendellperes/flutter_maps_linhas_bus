import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'dart:convert'as convert;


class PaypalServices{
  String domain    = "https://api.sandbox.paypal.com";
  String clientId  = "AQ_Lledi12d3R4QcaJi41jCyptPNKxZd2Fw-Dre2FS8H1QujanjYJXczLAR8drEDGXYDK67zAWWjM9RE";
  String secret    = "EMxi6Fer43ZE2ZSGRZrxXMlOdOomFrHY55D80fLhZGgITDI4o-b_eyna8QTXXJc228hABpAup2xsS9z8";
  
  Future<String> getAcessToken() async {
    try{
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(Uri.parse('$domain/v1oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200){
        final body = convert.jsonDecode(response.body);
        return body['access_token'];
      }
    }catch (e){
      rethrow;
    }
  }
  Future<Map<String, String>>createPaypalPayment(transactions, accessToken)async{
    try{
      var response = await http.
      post(Uri.parse("$domain/v1/payments/payment"),
          headers: {
            'content-type': "application/json",
            'Authorization': "Bearer" + accessToken
          }
      );
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201){
        if(body['links'] != null && body['links'].length > 0 ){
          List links = body['links'];
          String executor  = '';
          String approvaUrl = '';

          final item = links.firstWhere((element) => element['rel'] == "approval_url", orElse: ()=>null);
          if(item !=null ){
            approvaUrl = item['href'];
          }
          final item1 = links.firstWhere((element) => element['rel'] == "execute", orElse: ()=>null);
          if(item !=null ){
            executor = item1['href'];
          }

          return {
            "executeUrl": executor,
            "approvalUrl": approvaUrl
          };
        }
        throw Exception("0");
      }else{
        throw Exception(body["message"]);
      }
    }catch(e){
      rethrow;
    }

  }

  Future<String> executePayment ( url, payerId, accessToken)async{
    try{
      var response = await http.post(url,
      body: convert.jsonEncode({'payer_id': payerId}),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer" + accessToken
        }
      );
      final body = convert.jsonDecode(response.body);
      if ( response.statusCode == 200){
        return body['id'];
      }
      return '0';
    }catch(e){
      rethrow;
    }
    
  }






}




