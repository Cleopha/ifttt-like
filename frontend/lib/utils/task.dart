import 'package:frontend/utils/services.dart';

class Task {
  final String? title;
  final String author;
  final int numberOfUsers;
  final ActionInfo action;
  final List<ReactionInfo> reactions;
  final bool isActive;

  Task({
    this.title,
    required this.author,
    required this.numberOfUsers,
    required this.action,
    required this.reactions,
    required this.isActive,
  });

  String formatedTitle(bool shorten) {
    String finalTitle = 'If ${action.name} Then ';

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
    return [action.service.iconPath] +
        reactions.map((reaction) => reaction.service.iconPath).toList();
  }
}
