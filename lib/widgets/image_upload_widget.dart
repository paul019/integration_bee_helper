import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';

class ImageUploadWidget extends StatelessWidget {
  final String? imageUrl;
  final void Function(XFile) onUpload;
  final void Function() onDelete;

  const ImageUploadWidget({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return TextButton.icon(
        onPressed: () async {
          final image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );

          if (image != null) {
            onUpload(image);
          }
        },
        icon: const Icon(Icons.upload),
        label: Text(MyIntl.of(context).uploadImage),
      );
    } else {
      return Row(
        children: [
          Image.network(
            imageUrl!,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              onPressed: () => onDelete(),
              icon: const Icon(Icons.delete),
              color: ThemeColors.red,
            ),
          )
        ],
      );
    }
  }
}
