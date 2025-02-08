part of '../pages/receipts_page.dart';

class _ReceiptTile extends StatelessWidget {
  final Receipt item;
  final ValueChanged<Receipt>? onTap;
  final ValueChanged<Receipt>? sendEmail;
  final ValueChanged<Receipt>? downloadFile;
  final ValueChanged<Receipt>? onReceiptDeleted;

  const _ReceiptTile({
    required this.item,
    this.onTap,
    this.sendEmail,
    this.downloadFile,
    this.onReceiptDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return MyCard.outline(
      onTap: () => onTap?.call(item),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Receipt Details ---
              Row(
                children: [
                  Icon(LucideIcons.fileText, size: 28, color: context.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.createdAt.format(format: 'dd-MM-yyyy hh:mm aa'),
                          style: context.bodySmall!.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// --- Action Buttons ---
              Row(
                spacing: 12.0,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    icon: LucideIcons.mail,
                    onPressed: () => sendEmail?.call(item),
                    backgroundColor: context.primaryContainer.withAlpha(25),
                    iconColor: context.onPrimary,
                  ),
                  _ActionButton(
                    icon: LucideIcons.download,
                    onPressed: () => downloadFile?.call(item),
                    backgroundColor: context.primaryContainer.withAlpha(25),
                    iconColor: context.onPrimary,
                  ),
                  _ActionButton(
                    icon: LucideIcons.trash,
                    onPressed: () => onReceiptDeleted?.call(item),
                    backgroundColor: context.errorContainer.withAlpha(25),
                    iconColor: context.onErrorContainer,
                  ),
                  const SizedBox(width: 4.0),
                ],
              ),
            ],
          ).expanded(),
          Icon(LucideIcons.chevronRight, color: Colors.grey.shade500),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
