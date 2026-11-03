import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'word_provider.g.dart';

final class WordStats {
  const WordStats({
    this.words = 0,
    this.characters = 0,
    this.charactersNoSpaces = 0,
    this.sentences = 0,
    this.paragraphs = 0,
    this.readingTimeSeconds = 0,
  });

  final int words;
  final int characters;
  final int charactersNoSpaces;
  final int sentences;
  final int paragraphs;
  final int readingTimeSeconds;

  String get readingTime {
    final mins = readingTimeSeconds ~/ 60;
    final secs = readingTimeSeconds % 60;
    if (mins == 0) return '${secs}s';
    return '${mins}m ${secs}s';
  }
}

@riverpod
class WordNotifier extends _$WordNotifier {
  @override
  WordStats build() => const WordStats();

  void analyse(String text) {
    if (text.trim().isEmpty) {
      state = const WordStats();
      return;
    }

    final words = text.trim().split(RegExp(r'\s+')).length;
    final characters = text.length;
    final charsNoSpaces = text.replaceAll(' ', '').length;
    final sentences =
        text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;
    final paragraphs =
        text.split(RegExp(r'\n+')).where((p) => p.trim().isNotEmpty).length;
    // Average 200 words per minute reading speed
    final readingSeconds = (words / 200 * 60).round();

    state = WordStats(
      words: words,
      characters: characters,
      charactersNoSpaces: charsNoSpaces,
      sentences: sentences,
      paragraphs: paragraphs,
      readingTimeSeconds: readingSeconds,
    );
  }
}
