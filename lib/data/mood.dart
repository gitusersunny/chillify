import 'package:flutter/material.dart';

class Mood {
  final String name;
  final String emoji;
  final Color color;

  const Mood({
    required this.name,
    required this.emoji,
    required this.color,
  });
}

const List<Mood> moods = [
  Mood(
    name: "happy",
    emoji: "😄",
    color: Colors.yellow,
  ),
  Mood(
    name: "sad",
    emoji: "😢",
    color: Colors.blue,
  ),
  Mood(
    name: "energetic",
    emoji: "⚡",
    color: Colors.orange,
  ),
  Mood(
    name: "calm",
    emoji: "🌿",
    color: Colors.green,
  ),
  Mood(
    name: "romantic",
    emoji: "❤️",
    color: Colors.pink,
  ),
];
