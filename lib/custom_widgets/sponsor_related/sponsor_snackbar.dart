import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nocab/custom_widgets/duration_indicator/duration_indicator.dart';
import 'package:nocab/custom_widgets/sponsor_related/sponsor_providers.dart';
import 'package:nocab/extensions/size_extension.dart';

class SponsorSnackbar {
  SponsorSnackbar._();
  static const Duration _hideDuration = Duration(seconds: 12);

  static show(BuildContext context, {required int transferCount, int latestTransferSize = 0}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: _buildBody(context, _hideDuration, latestTransferSize, transferCount),
      dismissDirection: DismissDirection.startToEnd,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      behavior: SnackBarBehavior.floating,
      duration: _hideDuration,
      padding: const EdgeInsets.all(8),
    ));
  }

  static Widget _buildBody(BuildContext context, final Duration duration, int latestTransferSize, int transferCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
                image: const DecorationImage(image: NetworkImage("https://avatars.githubusercontent.com/u/47814461?v=4")),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latestTransferSize > 1.gbToBytes
                        ? "sponsorRelated.snackbar.titleBigFile".tr(namedArgs: {"size": latestTransferSize.formatBytes()})
                        : "sponsorRelated.snackbar.title".plural(transferCount, name: 'count'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "sponsorRelated.snackbar.subtitle".tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w200,
                        ),
                    maxLines: 3,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: SponsorProviders(),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("sponsorRelated.snackbar.action".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
            DurationIndicator(
              duration: duration,
              color: Theme.of(context).colorScheme.primary,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      ],
    );
  }
}
