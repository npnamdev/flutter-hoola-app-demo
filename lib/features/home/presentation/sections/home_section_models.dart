// Models & mock data for home sections

// Data models for Home sections
class ContinueItem {
  final String courseId;
  final String title;
  final String thumbnailUrl;
  final double progress; // 0..1
  final String? lastLesson;
  const ContinueItem({
    required this.courseId,
    required this.title,
    required this.thumbnailUrl,
    required this.progress,
    this.lastLesson,
  });
}

class Recommendation {
  final String courseId;
  final String title;
  final String thumbnailUrl;
  final double relevance; // 0..1
  final String reason;
  const Recommendation({
    required this.courseId,
    required this.title,
    required this.thumbnailUrl,
    required this.relevance,
    required this.reason,
  });
}

class QuickQuizMeta {
  final String id;
  final int questions;
  final Duration estimated;
  final bool completedToday;
  const QuickQuizMeta({
    required this.id,
    required this.questions,
    required this.estimated,
    this.completedToday = false,
  });
}

// Mock data (temporary; replace with Riverpod provider later)
final mockContinue = <ContinueItem>[
  ContinueItem(
    courseId: 'c_figma_basic',
    title: 'Figma cơ bản cho người mới',
    thumbnailUrl: 'https://picsum.photos/seed/figma/400/600',
    progress: .32,
    lastLesson: 'Chia sẻ component',
  ),
  ContinueItem(
    courseId: 'c_ui_color',
    title: 'Màu sắc & Giao diện thực chiến',
    thumbnailUrl: 'https://picsum.photos/seed/color/400/600',
    progress: .68,
    lastLesson: 'Lý thuyết sắc độ',
  ),
  ContinueItem(
    courseId: 'c_flutter_intro',
    title: 'Flutter từ số 0 đến 1',
    thumbnailUrl: 'https://picsum.photos/seed/flutter/400/600',
    progress: .12,
    lastLesson: 'Cấu trúc widget',
  ),
];

final mockRecommendations = <Recommendation>[
  Recommendation(
    courseId: 'c_ui_advanced',
    title: 'UI nâng cao với hệ thống thiết kế',
    thumbnailUrl: 'https://picsum.photos/seed/uidesign/400/600',
    relevance: .91,
    reason: 'Vì bạn hoàn thành Figma cơ bản',
  ),
  Recommendation(
    courseId: 'c_product_thinking',
    title: 'Tư duy sản phẩm cho designer',
    thumbnailUrl: 'https://picsum.photos/seed/product/400/600',
    relevance: .84,
    reason: 'Quan tâm UI/UX',
  ),
  Recommendation(
    courseId: 'c_motion',
    title: 'Nguyên lý Motion trong giao diện',
    thumbnailUrl: 'https://picsum.photos/seed/motion/400/600',
    relevance: .77,
    reason: 'Học nhiều khoá UI',
  ),
];

final mockQuickQuiz = QuickQuizMeta(
  id: 'quiz_daily',
  questions: 5,
  estimated: const Duration(minutes: 1),
  completedToday: false,
);
