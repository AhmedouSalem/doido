enum TaskStatus {
  pending,
  inProgress,
  done;

  bool get isDone => this == TaskStatus.done;
}
