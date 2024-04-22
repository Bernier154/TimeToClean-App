String prettyDuration(Duration duration) {
  var components = <String>[];

  var days = duration.inDays;
  if (days != 0) {
    components.add('${days}d');
  }
  var hours = duration.inHours % 24;
  if (hours != 0) {
    components.add('${hours}h');
  }
  var minutes = duration.inMinutes % 60;
  if (minutes != 0) {
    components.add('${minutes}m');
  }

  var seconds = duration.inSeconds % 60;
  var centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
  if (components.isEmpty || seconds != 0 || centiseconds != 0) {
    components.add('$seconds');
    components.add('s');
  }
  return components.join();
}
