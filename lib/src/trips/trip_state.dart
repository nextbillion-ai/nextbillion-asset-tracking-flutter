enum TripState {
  started,
  ended,
  updated,
  deleted,
}

extension TripStateExtension on TripState {
  static TripState fromString(String value) {
    switch (value.toUpperCase()) {
      case 'STARTED':
        return TripState.started;
      case 'ENDED':
      case 'END':
        return TripState.ended;
      case 'UPDATED':
        return TripState.updated;
      case 'DELETED':
        return TripState.deleted;
      default:
        throw ArgumentError('Invalid trip state: $value');
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}