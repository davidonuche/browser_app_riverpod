import 'package:browser_app_riverpod/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavHorizontalList extends ConsumerWidget {
  const FavHorizontalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserFavs = ref.watch(browserFavouriteProvider);
    final favsCount = ref.watch(favsCountProvider);
    return Container(
      margin: EdgeInsets.all(6),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: favsCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white60,
            )),
            child: InkWell(
              onTap: () {
                ref
                    .read(controllerProvider.notifier)
                    .goToPage(url: browserFavs[index]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      browserFavs[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(browserFavouriteProvider.notifier)
                          .removeFromFavorites(browserFavs[index]);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
