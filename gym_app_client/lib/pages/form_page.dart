import 'package:flutter/material.dart';
import 'package:gym_app_client/utils/components/common/back_leading_app_bar.dart';

class FormPage extends StatelessWidget {
  final String title;
  final Widget form;

  const FormPage({
    super.key,
    required this.title,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackLeadingAppBar(title: title, context: context),
      body: Center(
        child: SingleChildScrollView(
          child: form,
        ),
      ),
    );
  }
}
