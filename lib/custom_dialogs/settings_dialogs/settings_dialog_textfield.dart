part of settings_dialogs;

class _SettingsDialogTextField extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(String text) onSaved;
  final Function()? onCanceled;
  final bool closeOnAction;
  final List<TextInputFormatter>? inputFormatters;

  const _SettingsDialogTextField({
    Key? key,
    required this.title,
    this.subtitle,
    this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
    required this.onSaved,
    required this.onCanceled,
    required this.closeOnAction,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<_SettingsDialogTextField> createState() => _SettingsDialogTextFieldState();
}

class _SettingsDialogTextFieldState extends State<_SettingsDialogTextField> {
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
              child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            if (widget.subtitle != null)
              Center(
                child: Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              textAlign: TextAlign.center,
              controller: widget.controller,
              onChanged: (value) => setState(() {}),
              inputFormatters: widget.inputFormatters,
              autofocus: true,
              maxLength: 20,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(8),
                hintText: widget.hintText,
                counterText: "",
              ),
              onSubmitted: (value) {
                if (value.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }

                widget.onSaved.call(value);
                if (widget.closeOnAction) Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onCanceled?.call();
                    if (widget.closeOnAction) Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: widget.controller.text.isEmpty
                      ? null
                      : () {
                          widget.onSaved.call(widget.controller.text);
                          if (widget.closeOnAction) Navigator.of(context).pop();
                        },
                  icon: const Icon(Icons.done_rounded),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
