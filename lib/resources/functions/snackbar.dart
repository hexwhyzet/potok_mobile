enum InfoSnackbarStyle {
  success,
  failure,
}

class InfoSnackbar {
  final String title;
  final InfoSnackbarStyle infoSnackbarStyle;

  InfoSnackbar(this.title, this.infoSnackbarStyle);
}
