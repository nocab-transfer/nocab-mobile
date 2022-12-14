import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget widget;
  final String? helpText;
  final IconData leading;
  final Function()? onTap;
  final bool dangerous;
  const SettingCard({
    Key? key,
    required this.title,
    this.caption,
    required this.widget,
    this.helpText,
    required this.leading,
    this.onTap,
    this.dangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50),
          //width: 50,
          //color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    leading,
                    color: dangerous ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onBackground,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: dangerous ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Text(
                          caption ?? "",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ),
                  widget,
                ],
              ),
              if (helpText != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, color: Theme.of(context).colorScheme.onBackground, size: 16),
                      const SizedBox(width: 4),
                      Text(helpText ?? ""),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
