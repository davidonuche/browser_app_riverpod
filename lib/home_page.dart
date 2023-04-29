import 'package:browser_app_riverpod/notifiers/controller_notifier.dart';
import 'package:browser_app_riverpod/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/fav_horizontal_list.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containsFav = ref.watch(containsFavProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(
              onPressed: () {
                final String currentUrl = ref.read(currentUrlProvider);
                //final bool containsFav = ref.read(containsFavProvider);
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
              child: Text(containsFav ? "Remove to favs" : "Add to favs"),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              padding: EdgeInsets.all(8),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: ref.read(textEditingControllerProvider),
                    // onChanged: (value) {
                    //   ref.read(currentUrlProvider.notifier).setLink(value);
                    // },
                  )),
                  IconButton(
                    onPressed: ()  {
                      //final String currentUrl = ref.read(currentUrlProvider);
                      final textEditingController =
                          ref.read(textEditingControllerProvider);
                      FocusScope.of(context).unfocus();
                       ref
                          .read(controllerProvider.notifier)
                          .goToPage(url: textEditingController.text);
                      textEditingControllerProvider.clear();
                      // ref.read(controllerProvider)?.loadUrl(currentUrl);
                    },
                    

                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            if (ref.watch(favsCountProvider) != 0)
              Expanded(
                child: WebView(
                  onWebViewCreated: (webViewController) {
                    ref
                        .read(controllerProvider.notifier)
                        .setController(webViewController);
                  },
                  initialUrl: ref.read(currentUrlProvider),
                  onWebResourceError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Error, can not go to ${error.failingUrl}"),
                      ),
                    );
                  },
                  onPageStarted: (link) =>
                      ref.read(currentUrlProvider.notifier).setLink(link),
                ),
              ),
          ],
        ));
  }
}
