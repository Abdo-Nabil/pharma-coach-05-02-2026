class DashboardVisits {
  final int currentMonth;
  final int lastMonth;
  final int change;
  final String trend;

  DashboardVisits({
    required this.currentMonth,
    required this.lastMonth,
    required this.change,
    required this.trend,
  });

  factory DashboardVisits.fromMap(Map<String, dynamic> map) {
    return DashboardVisits(
      currentMonth: map['current_month'] ?? 0,
      lastMonth: map['last_month'] ?? 0,
      change: map['change'] ?? 0,
      trend: map['trend'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current_month': currentMonth,
      'last_month': lastMonth,
      'change': change,
      'trend': trend,
    };
  }
}
