part of settings_dialogs;

class _SettingsDialogSelection<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<SettingsDialogSelectionItem<T>> items;
  final ValueChanged<T> onItemClicked;
  final bool closeOnAction;

  const _SettingsDialogSelection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onItemClicked,
    required this.closeOnAction,
  }) : super(key: key);

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
              child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            if (subtitle != null)
              Center(
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        onItemClicked.call(item.value);
                        if (closeOnAction) Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 45),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: item.selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(item.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      if (item.subtitle != null)
                                        Text(item.subtitle!, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}

class SettingsDialogSelectionItem<T> {
  final String title;
  final String? subtitle;
  final T value;
  final bool selected;

  SettingsDialogSelectionItem({
    required this.title,
    this.subtitle,
    required this.value,
    this.selected = false,
  });
}
