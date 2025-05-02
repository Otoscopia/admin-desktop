import 'package:appwrite/models.dart';
import 'package:fluent_ui/fluent_ui.dart';

extension DocumentListExtensions on DocumentList {
  List<ComboBoxItem<String>> toPasswordExpiration(DocumentList documents) {
    return documents.documents.map((e) {
      return ComboBoxItem(value: e.$id, child: Text(e.data['title']));
    }).toList();
  }

  List<ComboBoxItem<String>> toPasswordGracePeriod(DocumentList documents) {
    return documents.documents.map((e) {
      return ComboBoxItem(value: e.$id, child: Text(e.data['title']));
    }).toList();
  }

  List<ComboBoxItem<String>> toIdleSession(DocumentList documents) {
    return documents.documents.map((e) {
      return ComboBoxItem(value: e.$id, child: Text(e.data['title']));
    }).toList();
  }

  Map<String, dynamic> toConfiguration(DocumentList documents) {
    final mfa = documents.documents.first;
    return mfa.data;
  }
}
