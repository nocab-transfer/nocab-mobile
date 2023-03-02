import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocab/services/sponsors/sponsors.dart';

class SponsorAvatars extends StatefulWidget {
  const SponsorAvatars({Key? key}) : super(key: key);

  @override
  State<SponsorAvatars> createState() => _SponsorAvatarsState();
}

class _SponsorAvatarsState extends State<SponsorAvatars> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(_scrollController.position.pixels + 100, duration: const Duration(milliseconds: 2100), curve: Curves.linear);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Sponsors.fetchHighTierSupponsors(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) return const SizedBox.shrink();

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'sponsorRelated.avatars.title'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length > 6 ? null : snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var item = snapshot.data![index % snapshot.data!.length];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Tooltip(
                              message: item.name,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: item.primary ? const Color(0xFFFFD700) : const Color(0xFF6667AB), width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(item.imageUrl),
                                    radius: 20,
                                  )
                                      .animate(onPlay: (controller) => controller.repeat(), delay: const Duration(milliseconds: 200))
                                      .shimmer(angle: 240)
                                      .then(delay: const Duration(seconds: 10)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(curve: Curves.easeInOut);
        } else {
          return Container();
        }
      },
    );
  }
}
