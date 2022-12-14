part of settings_dialogs;

class _SettingsDialogColorPicker extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Color> colors;
  final Function(Color color) onColorClicked;
  final bool closeOnAction;

  const _SettingsDialogColorPicker({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onColorClicked,
    required this.closeOnAction,
  }) : super(key: key);

  @override
  State<_SettingsDialogColorPicker> createState() => _SettingsDialogColorPickerState();
}

class _SettingsDialogColorPickerState extends State<_SettingsDialogColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (widget.subtitle != null)
                    Text(widget.subtitle!, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 70),
                  itemCount: Colors.accents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          widget.onColorClicked.call(widget.colors[index]);
                          if (widget.closeOnAction) Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                          decoration: BoxDecoration(
                            color: widget.colors[index],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
