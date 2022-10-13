class PictureEvent {}

class LoadPicture extends PictureEvent {}

class UpdateLikePicture extends PictureEvent {
  bool value;

  UpdateLikePicture(this.value);
}

class SharePicture extends PictureEvent {}

class SubscribeProfile extends PictureEvent {}

class CreateComment extends PictureEvent {}
