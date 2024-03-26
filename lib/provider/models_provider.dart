import 'package:flutter/cupertino.dart';
import 'package:unichat/services/api_service.dart';

import '../models/model_model.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelslist = [];

  List<ModelsModel> get getModelsList {
    return modelslist;
  }

  Future<List<ModelsModel>> getAllModels()async{
    modelslist = await ApiService.getModels();
    return modelslist;
  }
}
