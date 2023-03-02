import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocab/services/sponsors/sponsors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SponsorProviders extends StatelessWidget {
  const SponsorProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 300,
      height: 40,
      child: ListView.builder(
        itemCount: Sponsors.getSponsors.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          var widget = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: Sponsors.getSponsors[index].logo ?? const Icon(Icons.error_outline_rounded),
              onPressed: () => launchUrlString(Sponsors.getSponsors[index].url, mode: LaunchMode.externalApplication),
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: Sponsors.getSponsors[index].primary ? BorderSide(color: Theme.of(context).colorScheme.primary) : BorderSide.none,
                  )),
            ),
          );
          if (Sponsors.getSponsors[index].primary) {
            return widget
                .animate(onPlay: (controller) => controller.repeat(), delay: const Duration(milliseconds: 200))
                .shake(hz: 5)
                .then()
                .shimmer(angle: 240, color: const Color(0xFFFFFBFF), duration: 500.ms, size: 0.8)
                .then(delay: const Duration(milliseconds: 800));
          }

          return widget;
        },
      ),
    );
  }
}
