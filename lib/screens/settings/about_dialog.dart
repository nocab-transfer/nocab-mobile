import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocab/custom_icons/custom_icons.dart';
import 'package:nocab/custom_widgets/sponsor_related/sponsor_avatars.dart';
import 'package:nocab/custom_widgets/sponsor_related/sponsor_providers.dart';
import 'package:nocab/services/github/github.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutDialogCustomized extends StatelessWidget {
  final String? version;
  const AboutDialogCustomized({Key? key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //override the default behavior of the dialog
      onTap: () => Navigator.pop(context),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SponsorAvatars(),
            GestureDetector(
              //make the dialog not close when content is tapped
              onTap: () {},
              child: AboutDialog(
                applicationVersion: version != null ? "v$version" : null,
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const Image(
                    image: AssetImage('assets/icon/ic_launcher.png'),
                    height: 70,
                    width: 70,
                  ),
                ),
                children: [
                  Container(
                    //width: 450,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Sponsor To Me", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          ),
                          const SponsorProviders(),
                          Divider(color: Theme.of(context).colorScheme.secondary),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Contact", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            IconButton(
                              onPressed: () => launchUrlString("mailto:'berkekbgz@gmail.com'", mode: LaunchMode.externalApplication),
                              style: IconButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              icon: const Icon(Icons.email_rounded),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => launchUrlString("https://twitter.com/berkekbgz", mode: LaunchMode.externalApplication),
                              style: IconButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              icon: const Icon(CustomIcons.twitter),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => launchUrlString("https://discord.gg/4uB5QgPgab", mode: LaunchMode.externalApplication),
                              style: IconButton.styleFrom(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              icon: const Icon(CustomIcons.discord, size: 18),
                            ),
                          ]),
                          Divider(color: Theme.of(context).colorScheme.secondary),
                          Text('Contributors', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              //border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                            ),
                            height: 40,
                            width: 400,
                            child: FutureBuilder(
                              future: Github().getContributors(owner: 'nocab-transfer', repo: 'nocab-mobile'),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'error',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Center(
                                            child: Tooltip(
                                              message: snapshot.data![index]['login'],
                                              child: InkWell(
                                                onTap: () => launchUrlString(snapshot.data![index]['html_url'], mode: LaunchMode.externalApplication),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(snapshot.data![index]['avatar_url']),
                                                  radius: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            .animate()
                                            .scaleXY(delay: (0.1 * index).seconds, duration: 0.3.seconds, curve: Curves.easeOutBack)
                                            .fadeIn(delay: (0.1 * index).seconds, duration: 0.3.seconds);
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
