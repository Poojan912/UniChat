import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_consts.dart';
import '../models/chat_model.dart';
import '../models/model_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_Key'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response;
      if (modelId == "dall-e-3") {
        response = await http.post(
          Uri.parse("$BASE_URL/images/generations"),
          headers: {
            'Authorization': 'Bearer $API_Key',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "model": "dall-e-3",
              "prompt": message,
              "n": 1,
              "size": "1024x1024"
            },
          ),
        );
      } else {
        response = await http.post(
          Uri.parse("$BASE_URL/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_Key',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "model": modelId,
              // "messages": "what is flutter?",
              "messages": [
                {"role": "user", "content": message}
              ],
              "temperature": 0.7,
            },
          ),
        );
      }

      print("+++++++++++++++++++++=");
      print(response);
      print("+++++++++++++++++++++=");


      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<ChatModel> chatList = [];
      if (modelId == "dall-e-3") {
        if (jsonResponse["data"].length > 0) {
          chatList = List.generate(
            jsonResponse["data"].length,
                (index) => ChatModel(
              msg: jsonResponse["data"][index]["url"],
              chatIndex: 1,
                  isURL: 1,
            ),
          );
          // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["message"]}");
        }
      } else {
        if (jsonResponse["choices"].length > 0) {
          chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
              msg: jsonResponse["choices"][index]["message"]["content"],
              chatIndex: 1,
              isURL: 0,
            ),
          );
          // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["message"]}");
        }
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
