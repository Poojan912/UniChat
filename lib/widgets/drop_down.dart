import 'package:flutter/material.dart';
import 'package:unichat/models/model_model.dart';
import 'package:unichat/services/api_service.dart';
import 'package:unichat/widgets/text_widget.dart';

import '../constants/constant.dart';

class ModelsDrowDownWidget extends StatefulWidget {
  const ModelsDrowDownWidget({Key? key});

  @override
  State<ModelsDrowDownWidget> createState() => _ModelsDrowDownWidgetState();
}

class _ModelsDrowDownWidgetState extends State<ModelsDrowDownWidget> {
  String currentModel = "gpt-4-vision-preview";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelsModel>>(
      future: ApiService.getModels(),
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
          },
        );
      },
    );
  }
}
