import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                searchProvider.clearSuggestion();
              },
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Main layout
                  Column(
                    children: [
                      // 🔍 Search bar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              searchProvider.fetchSuggestions(val);
                            } else {
                              searchProvider.clearSuggestion();
                            }
                          },
                          onSubmitted: (val) {
                            searchProvider.search(val);
                            searchProvider.clearSuggestion();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for meals...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      // 📦 Search results
                      Expanded(
                        child: searchProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: searchProvider.searchResults.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      searchProvider.searchResults[index];
                                  return ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(product.name),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),

                  // 💡 Floating Suggestions Dropdown
                  if (searchProvider.suggestions.isNotEmpty)
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 70, // just below search bar
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchProvider.suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion =
                                  searchProvider.suggestions[index];
                              return ListTile(
                                title: Text(suggestion.name),
                                onTap: () {
                                  _controller.text = suggestion.name;

                                  // 👉 Run search immediately
                                  searchProvider.search(suggestion.name);

                                  // 👉 Clear dropdown
                                  searchProvider.clearSuggestion();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
