class CommentEvent {}

class LoadComment extends CommentEvent {}

class UpdateLikeComment extends CommentEvent {
  bool value;

  UpdateLikeComment(this.value);
}

class ShareComment extends CommentEvent {}

class CreateComment extends CommentEvent {
  String text;

  CreateComment(this.text);
}
