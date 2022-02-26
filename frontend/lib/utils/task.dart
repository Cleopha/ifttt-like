import 'package:frontend/utils/services.dart';

class Task {
  final String? title;
  final ActionInfo? action;
  final String? author;
  final List<ReactionInfo> reactions;
  final int numberOfUsers;
  final bool isActive;

  Task({
    this.title,
    this.action,
    this.author,
    required this.reactions,
    required this.numberOfUsers,
    required this.isActive,
  });

  String formatedTitle(bool shorten) {
    if (action == null) return '';
    String finalTitle = 'If ${action!.name} Then ';

    for (int i = 0; i < reactions.length; i++) {
      finalTitle += reactions[i].name;
      if (i != reactions.length - 1) {
        finalTitle += ' And ';
      }
    }
    if (shorten && finalTitle.length > 60) {
      finalTitle = finalTitle.substring(0, 60) + '...';
    }
    return finalTitle;
  }

  List<String> tagsGetter() {
    if (action == null) return [];
    return [action!.service.iconPath] +
        reactions.map((reaction) => reaction.service.iconPath).toList();
  }
}
