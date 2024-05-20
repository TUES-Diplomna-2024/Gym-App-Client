import 'package:flutter/material.dart';
import 'package:gym_app_client/db_api/models/user/user_preview_model.dart';
import 'package:gym_app_client/db_api/services/user_service.dart';
import 'package:gym_app_client/utils/components/views/previews/user_preview.dart';

class AdminPanelUsersPage extends StatefulWidget {
  const AdminPanelUsersPage({super.key});

  @override
  State<AdminPanelUsersPage> createState() => _AdminPanelUsersPageState();
}

class _AdminPanelUsersPageState extends State<AdminPanelUsersPage> {
  final _userService = UserService();
  final _searchController = TextEditingController();

  List<UserPreviewModel>? _searchResults;

  void _getUserSearchResults() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      if (mounted) setState(() => _searchController.text = "");
      return;
    }

    _userService.getUserSearchResults(query).then(
      (serviceResult) {
        if (serviceResult.isSuccessful) {
          if (mounted) setState(() => _searchResults = serviceResult.data!);
        } else {
          serviceResult.showPopUp(context);
          if (serviceResult.shouldSignOutUser) _userService.signOut(context);
        }
      },
    );
  }

  Widget _getSearchResultsBody() {
    if (_searchResults == null || _searchController.text.isEmpty) {
      return const SizedBox();
    }

    if (_searchResults!.isEmpty) {
      return const Center(
        child: Text(
          "No results!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 23),
      child: ListView.builder(
        itemCount: _searchResults!.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            child: UserPreview(user: _searchResults![index]),
            onTap: () {
              if (mounted) {
                Navigator.of(context).pushNamed(
                  "/profile",
                  arguments: [_searchResults![index].id, _getUserSearchResults],
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 23),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              onChanged: (_) => _getUserSearchResults(),
              leading: const Icon(Icons.search),
              trailing: [
                IconButton(
                  onPressed: () {
                    if (mounted) setState(() => _searchController.text = "");
                  },
                  icon: const Icon(Icons.clear_outlined),
                ),
              ],
            ),
            Expanded(
              child: _getSearchResultsBody(),
            ),
          ],
        ),
      ),
    );
  }
}
