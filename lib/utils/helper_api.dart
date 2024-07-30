import 'dart:convert';
import 'dart:io';

import 'package:aihealthcoaching_main/models/UserWeightModel.dart';
import 'package:aihealthcoaching_main/models/indices.dart';
import 'package:aihealthcoaching_main/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../common/config.dart';

class HelperApi with ChangeNotifier {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };

  Future<List<IndicesModel>> getIndicies(String token) async {
    List<IndicesModel> data = <IndicesModel>[];
    String url = Config.url + Config.indeices;
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      //print(result['data']);
      data = (result['data'] as List)
          .map(
            (i) => IndicesModel.fromJson(i),
          )
          .toList();
    }
    return data;
  }

  Future<List<PostModel>> getPostsForIndexs(int id, String token) async {
    List<PostModel> data = <PostModel>[];

    String url = Config.url + Config.indeices + "/" + id.toString();
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      data = (result['data'] as List)
          .map(
            (i) => PostModel.fromJson(i),
          )
          .toList();
    }

    return data;
  }

  Future<List<PostModel>> getPostsForIndexsSearch(
      int id, String title, String token) async {
    List<PostModel> data = <PostModel>[];

    Map<String, String> body = {
      'title': title,
    };

    String url = Config.url + Config.indeices + "/" + id.toString();
    http.Response response =
        await http.post(Uri.parse(url), body: body, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      ///print(result['data']);
      data = (result['data'] as List)
          .map(
            (i) => PostModel.fromJson(i),
          )
          .toList();
    }

    return data;
  }

  Future<bool> addWeight(String weight, String token) async {
    final url = Config.url + Config.addWeight;
    var result;

    Map<String, String> body = {
      'weight': weight,
    };

    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      result = apiResponse['status'];
      return apiResponse['status'];
    }

    if (response.statusCode == 401) {
      return false;
    }
    return result;
  }

  Future<bool> addNextGoal(dynamic nextMilestone, String token) async {
    final url = Config.url + Config.addNextGoal;
    var result;

    Map<String, dynamic> body = {
      'next_milestone': nextMilestone,
    };

    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      print(response.statusCode);
      result = apiResponse['status'];
      print(result);
      return apiResponse['status'];
    }

    if (response.statusCode == 401) {
      print(response.statusCode);
      return false;
    }
    return result;
  }

  Future getChartData(String token) async {
    List<UserWeightModel> data = <UserWeightModel>[];
    final url = Config.url + Config.charts;
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      for (Map<String, dynamic> i in result) {
        data.add(UserWeightModel.fromJson(i));
      }
    }
  }

  /*List<SalesData> chartData = [];

  Future<String> getJsonFromAssets() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future loadSalesData() async {
    final String jsonString = await getJsonFromAssets();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(SalesData.fromJson(i));
    }
  }*/

  Future<bool> updateProfile(Map<String, dynamic> map, String token) async {
    final url = Config.url + Config.updateProfile;

    final response = await http.post(Uri.parse(url), body: map, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      return apiResponse['status'];
    }

    if (response.statusCode == 401) {
      print(response.statusCode);
      return false;
    }
    return false;
  }

  Future<bool> uploadImage(
      filePath, String email, String image, String token) async {
    try {
      final url = Config.url + Config.uploadImage;

      String fileName = filePath.path.split("/").last;
      var data = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          filePath.path,
          filename: fileName,
        ),
        "email": email,
      });
      Dio dio = new Dio();
      var res = await dio.post(url,
          data: data,
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          }));

      print(email);

      print(res.data);
      print(res.statusCode);
      return res.statusCode == 200 ? true : false;
    } catch (ex) {
      print("uploadImage() " + ex.toString());
      return false;
    }
  }

  Future<bool> uploadVideo(
      filePath, String email, String image, String token) async {
    final url = Config.url + Config.uploadVideo;

    String fileName = filePath.path.split("/").last;
    //String base64 = base64Encode(filePath.readAsBytesSync());
    //print(base64);
    //print(fileName);
    /*Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'image/jpeg',
      'Content-Disposition': 'attachment; filename=$fileName',
    };

    List<int> imageBytes = File(filePath.path).readAsBytesSync();

    final request = http.Request('POST', Uri.parse(url));

    //print(request);

    request.headers.addAll(requestHeaders);
    request.body = '{email: ${email},image: ${filePath}';
    request.bodyBytes = imageBytes;
    var res = await request.send();*/
    var data = FormData.fromMap({
      "video": await MultipartFile.fromFile(
        filePath.path,
        filename: fileName,
      ),
      "email": email,
    });
    Dio dio = new Dio();
    var res = await dio.post(url,
        data: data,
        options: new Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        }));
    /*var data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: name,
      ),
    });*/
    /*{
      "email": email,
    "image": base64,
    }*/

    /*final response = await http.post(Uri.parse(url), body: , headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });*/
    //print(res.statusCode);

    /*var res = http.post(Uri.parse(url), body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });*/

    return res.statusCode == 200 ? true : false;
  }

  Future<bool> addReferral(int referralCounter, String token) async {
    final url = Config.url + Config.referral;

    Map<String, dynamic> body = {
      'referral_counter': referralCounter.toString(),
    };

    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      return apiResponse['status'];
    }

    if (response.statusCode == 401) {
      return false;
    }
    return false;
  }

  Future<bool> forgotPassword(String email) async {
    final url = Config.url + Config.forgotPassword;

    Map<String, dynamic> body = {
      'email': email,
    };

    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      return apiResponse['status'];
    }

    if (response.statusCode == 401) {
      return false;
    }
    return false;
  }
}
