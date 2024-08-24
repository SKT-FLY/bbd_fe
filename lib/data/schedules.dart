// 일정 데이터
final Map<String, List<Map<String, String>>> schedules = {
  '2024-08-13': [
    {'time': '07:00', 'title': '아침 산책', 'description': '공원에서 산책'},
    {'time': '10:00', 'title': '병원 진료', 'description': '근처 병원에서 진료'},
    {'time': '12:00', 'title': '점심 식사', 'description': '가족과 함께 점심'},
    {'time': '19:00', 'title': '저녁 드라마 시청', 'description': 'TV에서 드라마 보기'},
  ],
  '2024-08-14': [
    {'time': '08:00', 'title': '아침 요가', 'description': '집에서 가벼운 요가'},
    {'time': '09:00', 'title': '병원 방문', 'description': '정기 검진'},
    {'time': '11:00', 'title': '마트 방문', 'description': '마트에서 장보기'},
    {'time': '14:00', 'title': '친구와 차 마시기', 'description': '근처 카페에서 친구와 대화'},
  ],
  // 더 많은 일정 추가 가능...
};

// 공휴일 데이터
final Set<DateTime> holidays = {
  // 2020년 공휴일
  DateTime.utc(2020, 1, 1),  // New Year's Day
  DateTime.utc(2020, 1, 24), // Seollal Holiday
  DateTime.utc(2020, 1, 25), // Seollal (Lunar New Year's Day)
  DateTime.utc(2020, 1, 26), // Seollal Holiday
  DateTime.utc(2020, 3, 1),  // Independence Movement Day
  DateTime.utc(2020, 4, 30), // Buddha's Birthday
  DateTime.utc(2020, 5, 5),  // Children's Day
  DateTime.utc(2020, 6, 6),  // Memorial Day
  DateTime.utc(2020, 8, 15), // Liberation Day
  DateTime.utc(2020, 9, 30), // Chuseok Holiday
  DateTime.utc(2020, 10, 1), // Chuseok
  DateTime.utc(2020, 10, 2), // Chuseok Holiday
  DateTime.utc(2020, 10, 3), // National Foundation Day
  DateTime.utc(2020, 10, 9), // Hangul Day
  DateTime.utc(2020, 12, 25), // Christmas Day

  // 2021년 공휴일
  DateTime.utc(2021, 1, 1),  // New Year's Day
  DateTime.utc(2021, 2, 11), // Seollal Holiday
  DateTime.utc(2021, 2, 12), // Seollal (Lunar New Year's Day)
  DateTime.utc(2021, 2, 13), // Seollal Holiday
  DateTime.utc(2021, 3, 1),  // Independence Movement Day
  DateTime.utc(2021, 5, 5),  // Children's Day
  DateTime.utc(2021, 5, 19), // Buddha's Birthday
  DateTime.utc(2021, 6, 6),  // Memorial Day
  DateTime.utc(2021, 8, 15), // Liberation Day
  DateTime.utc(2021, 9, 20), // Chuseok Holiday
  DateTime.utc(2021, 9, 21), // Chuseok
  DateTime.utc(2021, 9, 22), // Chuseok Holiday
  DateTime.utc(2021, 10, 3), // National Foundation Day
  DateTime.utc(2021, 10, 9), // Hangul Day
  DateTime.utc(2021, 12, 25), // Christmas Day

  // 2022년 공휴일
  DateTime.utc(2022, 1, 1),  // New Year's Day
  DateTime.utc(2022, 1, 31), // Seollal Holiday
  DateTime.utc(2022, 2, 1),  // Seollal (Lunar New Year's Day)
  DateTime.utc(2022, 2, 2),  // Seollal Holiday
  DateTime.utc(2022, 3, 1),  // Independence Movement Day
  DateTime.utc(2022, 5, 5),  // Children's Day
  DateTime.utc(2022, 5, 8),  // Buddha's Birthday
  DateTime.utc(2022, 6, 6),  // Memorial Day
  DateTime.utc(2022, 8, 15), // Liberation Day
  DateTime.utc(2022, 9, 9),  // Chuseok Holiday
  DateTime.utc(2022, 9, 10), // Chuseok
  DateTime.utc(2022, 9, 11), // Chuseok Holiday
  DateTime.utc(2022, 10, 3), // National Foundation Day
  DateTime.utc(2022, 10, 9), // Hangul Day
  DateTime.utc(2022, 12, 25), // Christmas Day

  // 2023년 공휴일
  DateTime.utc(2023, 1, 1),  // New Year's Day
  DateTime.utc(2023, 1, 21), // Seollal Holiday
  DateTime.utc(2023, 1, 22), // Seollal (Lunar New Year's Day)
  DateTime.utc(2023, 1, 23), // Seollal Holiday
  DateTime.utc(2023, 3, 1),  // Independence Movement Day
  DateTime.utc(2023, 5, 5),  // Children's Day
  DateTime.utc(2023, 5, 27), // Buddha's Birthday
  DateTime.utc(2023, 6, 6),  // Memorial Day
  DateTime.utc(2023, 8, 15), // Liberation Day
  DateTime.utc(2023, 9, 28), // Chuseok Holiday
  DateTime.utc(2023, 9, 29), // Chuseok
  DateTime.utc(2023, 9, 30), // Chuseok Holiday
  DateTime.utc(2023, 10, 3), // National Foundation Day
  DateTime.utc(2023, 10, 9), // Hangul Day
  DateTime.utc(2023, 12, 25), // Christmas Day

  // 2024년 공휴일
  DateTime.utc(2024, 1, 1),  // New Year's Day
  DateTime.utc(2024, 2, 9),  // Seollal (Lunar New Year's Day)
  DateTime.utc(2024, 2, 10), // Seollal Holiday
  DateTime.utc(2024, 2, 11), // Seollal Holiday
  DateTime.utc(2024, 3, 1),  // Independence Movement Day
  DateTime.utc(2024, 5, 5),  // Children's Day
  DateTime.utc(2024, 5, 15), // Buddha's Birthday
  DateTime.utc(2024, 6, 6),  // Memorial Day
  DateTime.utc(2024, 8, 15), // Liberation Day
  DateTime.utc(2024, 9, 16), // Chuseok
  DateTime.utc(2024, 9, 17), // Chuseok Holiday
  DateTime.utc(2024, 9, 18), // Chuseok Holiday
  DateTime.utc(2024, 10, 3), // National Foundation Day
  DateTime.utc(2024, 10, 9), // Hangul Day
  DateTime.utc(2024, 12, 25), // Christmas Day

  // 2025년 공휴일
  DateTime.utc(2025, 1, 1),  // New Year's Day
  DateTime.utc(2025, 1, 28), // Seollal Holiday
  DateTime.utc(2025, 1, 29), // Seollal (Lunar New Year's Day)
  DateTime.utc(2025, 1, 30), // Seollal Holiday
  DateTime.utc(2025, 3, 1),  // Independence Movement Day
  DateTime.utc(2025, 5, 5),  // Children's Day
  DateTime.utc(2025, 5, 15), // Buddha's Birthday
  DateTime.utc(2025, 6, 6),  // Memorial Day
  DateTime.utc(2025, 8, 15), // Liberation Day
  DateTime.utc(2025, 10, 3), // National Foundation Day
  DateTime.utc(2025, 10, 6), // Chuseok Holiday
  DateTime.utc(2025, 10, 7), // Chuseok
  DateTime.utc(2025, 10, 8), // Chuseok Holiday
  DateTime.utc(2025, 10, 9), // Hangul Day
  DateTime.utc(2025, 12, 25), // Christmas Day
};

// 특정 날짜의 이벤트를 가져오는 함수
List<String> getEventsForDay(DateTime day) {
  final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  return schedules[key]?.map((event) => event['title'] ?? '').toList() ?? [];
}
