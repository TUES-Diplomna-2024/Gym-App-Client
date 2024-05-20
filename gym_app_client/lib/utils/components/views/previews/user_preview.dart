import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_preview_model.dart';
import 'package:gym_app_client/utils/components/fields/content/content_field.dart';
import 'package:gym_app_client/utils/components/fields/content/preview_field.dart';

class UserPreview extends StatelessWidget {
  final UserPreviewModel user;

  const UserPreview({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        gradient: LinearGradient(
          stops: const [0.03, 0.03],
          colors: [user.roleColor, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ContentField(
            isMultiline: true,
            fieldName: "Email",
            fieldValue: user.email,
            padding: const EdgeInsets.only(bottom: 15),
          ),
          PreviewField(
            fieldName: "Member Since",
            fieldValue: user.onCreated,
            padding: const EdgeInsets.only(bottom: 15),
          ),
        ],
      ),
    );
  }
}
