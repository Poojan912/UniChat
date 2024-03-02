import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unichat/models/model_model.dart';
import 'package:unichat/services/api_service.dart';
import 'package:unichat/widgets/text_widget.dart';

import '../constants/constant.dart';
import '../provider/models_provider.dart';

class ModelsDrowDownWidget extends StatefulWidget {
  const ModelsDrowDownWidget({Key? key});

  @override
  State<ModelsDrowDownWidget> createState() => _ModelsDrowDownWidgetState();
}

class _ModelsDrowDownWidgetState extends State<ModelsDrowDownWidget> {
  String ?currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }
        return DropdownButton(
          dropdownColor: scaffoldBackgroundColor,
          iconEnabledColor: Colors.white,
          items: List<DropdownMenuItem<String>>.generate(
            snapshot.data!.length,
                (index) => DropdownMenuItem(
              value: snapshot.data![index].id,
              child: TextWidget(
                label: snapshot.data![index].id,
                fontSize: 15,
              ),
            ),
          ),
          value: currentModel,
          onChanged: (value) {
            setState(() {
              currentModel = value.toString();
            });
            modelsProvider.setCurrentModel(value.toString(),);
          },
        );
      },
    );
  }
}
