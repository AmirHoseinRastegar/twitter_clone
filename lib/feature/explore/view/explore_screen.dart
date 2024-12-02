import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/explore/controller/explore_controller.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../widgets/searchtile.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final searchController = TextEditingController();
  bool isSearchedUserShown = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: ColorsPallet.searchBarColor,
        ));
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  isSearchedUserShown = true;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                fillColor: ColorsPallet.searchBarColor,
                filled: true,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle,
                hintText: 'Search Twitter',
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
              ),
            ),
          ),
        ),
        body: isSearchedUserShown
            ? ref.watch(searchUsersProvider(searchController.text)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final user = data[index];
                        return SearchTile(user);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorMessage(errorMessage: error.toString()),
                  loading: () => Loader(),
                )
            : const SizedBox(),
      ),
    );
  }
}
