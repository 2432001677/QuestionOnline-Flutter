import 'dart:convert';
import 'package:http/http.dart' as http;

const PREFIX = "http://192.168.1.103:8080";

httpGetRequest(String url) async {
  var client = http.Client();
  final response = await client.get(Uri.parse(PREFIX + url));
  return utf8.decode(response.bodyBytes);
}

const Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

httpPostRequest(String url, Map<String, String> params) async {
  var client = http.Client();
  final response = await client.post(
    Uri.parse(PREFIX + url),
    body: json.encode(params),
    headers: headers,
  );
  return utf8.decode(response.bodyBytes);
}
//httpGetRequest(String url) async {
//  var dy;
//  HttpClient httpClient = HttpClient();
//  try {
//    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//    HttpClientResponse response = await request.close();
//    if (response.statusCode == HttpStatus.ok) {
//      var plain = await response.transform(utf8.decoder).join();
//      dy = jsonDecode(plain);
//      print(dy);
//      return dy;
//    } else {
//      throw Exception();
//    }
//  } catch (e) {
//    print(e);
//  } finally {
//    httpClient.close();
//  }
//}
