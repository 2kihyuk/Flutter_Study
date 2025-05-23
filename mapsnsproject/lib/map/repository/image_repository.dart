
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = StateProvider<XFile?>((ref) => null);

final imagePickerProvider = StateProvider<ImagePicker>((ref) => ImagePicker());