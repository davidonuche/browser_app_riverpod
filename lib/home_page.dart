import 'package:browser_app_riverpod/providers.dart';
import 'package:browser_app_riverpod/widgets/fav_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containsFav = ref.watch(containsFavProvider);
    var controller = WebViewController()
      // ..currentUrl().then(
      //     (value) => ref.read(currentUrlProvider.notifier).setLink(value!))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            ref.read(currentUrlProvider.notifier).setLink(url);
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error, can not go to ${error.description}"),
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
   
      ..loadRequest(Uri.parse(ref.read(currentUrlProvider)));

    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              final String currentUrl = ref.read(currentUrlProvider);

              if (containsFav) {
                ref
                    .read(browserFavouriteProvider.notifier)
                    .removeFromFavorites(currentUrl);
              } else {
                ref
                    .read(browserFavouriteProvider.notifier)
                    .addToFavorites(currentUrl);
              }
            },
            child: Text(containsFav ? "Remove from favs" : "Add to favs"),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autocorrect: false,
                    controller: ref.read(textEditingControllerProvider),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final textEditingController =
                        ref.read(textEditingControllerProvider);

                    FocusScope.of(context).unfocus();

                    ref
                        .read(controllerProvider.notifier)
                        .goToPage(url: textEditingController.text);

                    textEditingController.clear();
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 30),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (ref.watch(favsCountProvider) != 0) const FavHorizontalList(),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
