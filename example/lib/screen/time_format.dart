String timeFormat(DateTime? timestamp) {
  if (timestamp == null) return 'N/A';

  return timestamp.toLocal().toString();
}
