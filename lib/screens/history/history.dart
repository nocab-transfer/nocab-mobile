import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocab/custom_widgets/svh_color_handler/svg_color_handler.dart';
import 'package:nocab/screens/history/history_details.dart';
import 'package:nocab/screens/history/history_item.dart';
import 'package:nocab/services/database/database.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? selectedUuid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            const SizedBox(width: 8),
            const Text("History"),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: Database().getTransfers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) return _emptyState(context);
          return SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: HistoryItem(
                    transfer: snapshot.data![index],
                    index: snapshot.data!.length - index,
                    isSelected: selectedUuid == snapshot.data![index].transferUuid,
                    onClicked: (transfer) {
                      setState(() => selectedUuid = transfer.transferUuid);
                      return showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => HistoryDetails(transfer: transfer),
                      ).then((value) => setState(() => selectedUuid = null));
                    },
                  ),
                );

                // avoid unnecessary animations
                if (snapshot.data!.length - index < 15) {
                  return item.animate().slideX(delay: (30 * (snapshot.data!.length - index)).ms, begin: -.05, curve: Curves.easeOut).fadeIn();
                }

                return item;
              },
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgColorHandler(
            svgPath: "assets/images/history_empty_state.svg",
            colorSwitch: {
              const Color(0xff6c63ff): Theme.of(context).colorScheme.primary,
              const Color(0xff3f3d56): Theme.of(context).colorScheme.outline,
              const Color(0xffe6e6e6): Theme.of(context).colorScheme.outlineVariant,
              const Color(0xfff2f2f2): Theme.of(context).colorScheme.primaryContainer,
              const Color(0xffffffff): Theme.of(context).colorScheme.background,
              const Color(0xffcccccc): Theme.of(context).colorScheme.secondary,
            },
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "No Entry Found",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                const Text(
                  "You have to make at least one transfer to see it here",
                ),
              ],
            ),
          ),
        ],
      ).animate(delay: 100.ms).fadeIn().slideX(curve: Curves.easeInOutCubicEmphasized, begin: -.05),
    );
  }
}
