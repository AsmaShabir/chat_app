

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import 'base_api_service.dart';


class NetworkApiService extends BaseApiService{
  @override
  Future getGetApiResponse(String url ) async{
    dynamic responseJson;
    try{
      final response =await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }
    //socket exception is basically no internet
    on SocketException{
      throw fetchDataException('no internet connection');

    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url,dynamic data) async{
    dynamic responseJson;
    try{
      Response response= await post(
          Uri.parse(url),
          body:data

      ).timeout(Duration(seconds: 10));

    }
    //socket exception is basically no internet
    on SocketException{
      throw fetchDataException('no internet connection');

    }
    return responseJson;
  }
  dynamic returnResponse (http.Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw badRequestException(response.statusCode.toString());
      case 404:
        throw unauthorizedException(response.statusCode.toString());
      default:
        throw fetchDataException('error occur while communicating with server'+'with status code' + response.statusCode.toString());
    }
  }

}