import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int kittyNumber = 0; // Default image
  int heartNumber = 0;
  int screenDisplayed =
      0; // 0 for main screen, 1 for settings, 2 for board, 3 for board extra
  int textSize = 24; // Default text size
  Color backgroundColor = Color.fromARGB(255, 221, 255, 199);
  Color foregroundColor = Color.fromARGB(255, 15, 115, 60);
  String boardItem = "BINGO";
  bool showResetConfirmation = false;
  int currentTaskIndex = -1;

  final List<List<List<List<String>>>> tasks = [
    [
      [
        [
          "Draw or color something simple.",
          "Keep a comfort box with items that help you feel better nearby.",
          "Name five things you can see, hear, and feel right now.",
        ],
        [
          "Set a tiny goal for the next hour.",
          "Watch an informational YouTube video.",
        ],
        [
          "Listen to a favorite song.",
          "Scroll through calming photos, such as nature or animals.",
          "Take a photo of something you find beautiful.",
          "Repeat a positive affirmation to yourself.",
          "Play with a smooth stone or a fidget toy.",
          "Read a comforting quote or verse.",
          "Write down one hope for the future.",
          "Say or write: 'I am doing my best, and that is enough'.",
        ],
        [
          "Text a friend or family member.",
          "Give someone a positive message or compliment, in writing or in person.",
        ],
        ["Do simple stretches."],
        [
          "Watch a light or funny video.",
          "Eat a small snack or drink some water.",
          "Think of three things that went okay today.",
          "Smile on purpose, just because.",
          "Light a flameless candle or turn on a soft light.",
        ],
      ],
      [
        [
          "Make a gratitude list.",
          "Write a journal entry about your day.",
          "Doodle freely or follow a simple drawing tutorial.",
          "Use a coloring book or app.",
          "Try a gratitude photo challenge.",
        ],
        [
          "Play a phone game or app-based brain teaser.",
          "Organize a small space, like a drawer, desk, bag, or shelf.",
        ],
        [
          "Meditate or practice deep breathing for 2-5 minutes.",
          "Try a guided breathing exercise.",
          "Wrap yourself in a cozy blanket.",
          "Do a quick body scan meditation.",
          "Watch clouds, birds, or trees from a window.",
          "Try silent sitting or listening for a few minutes.",
          "Play with a sensory item like playdough, fabric, or beads.",
          "Put on something that makes you feel good, whether it's a full outfit or just a pair of socks.",
          "Give yourself permission to rest, even if it's just for a few minutes.",
        ],
        ["Look through old photos or memories."],
        [
          "Take a short walk, even if it's just around the room.",
          "Try progressive muscle relaxation, tensing each muscle entirely and then relaxing them one at a time.",
          "Try a short YouTube meditation or mindfulness video.",
        ],
        [
          "Pet or cuddle a pet or stuffed animal.",
          "Ask yourself, 'What do I need right now?', and do it.",
          "Say no to a stressor, out loud, in writing, or in your head.",
        ],
      ],
      [
        [
          "Knit, crochet, or do some other craft.",
          "Create a playlist of 'healing' or 'happy' songs.",
        ],
        [
          "Do a puzzle, word search, Sudoku, or crossword.",
          "Start a new book, try to read a couple of chapters in one you're already reading.",
        ],
        [
          "Read a short article or comic.",
          "Listen to a podcast or audiobook.",
          "Watch an episode of a favorite show.",
        ],
        [],
        [
          "Massage a part of your body slowly and gently; this can be your hands, feet, scalp, neck, or another body part.",
        ],
        [],
      ],
    ],
    [
      [
        [
          "Draw or color something simple.",
          "Keep a comfort box with items that help you feel better nearby.",
          "Name five things you can see, hear, and feel right now.",
          "Write a short poem or haiku about something you love.",
        ],
        [
          "Set a tiny goal for the next hour.",
          "Write a to-do list for tomorrow that includes one fun activity.",
          "Watch an informational YouTube video.",
        ],
        [
          "Listen to a favorite song.",
          "Scroll through calming photos, such as nature or animals.",
          "Take a photo of something you find beautiful.",
          "Repeat a positive affirmation to yourself.",
          "Play with a smooth stone or a fidget toy.",
          "Read a comforting quote or verse.",
          "Write down one hope for the future.",
          "Say or write: 'I am doing my best, and that is enough'.",
          "Write down three things you’re grateful for today.",
          "Lightly scent your space with something calming (lavender, vanilla, etc.)",
        ],
        [
          "Text a friend or family member.",
          "Give someone a positive message or compliment, in writing or in person.",
        ],
        [
          "Do simple stretches.",
          "Open a window and focus on feeling the fresh air.",
          "Water a plant or examine one closely.",
          "Take a few steps outside your door and describe what you see.",
        ],
        [
          "Watch a light or funny video.",
          "Eat a small snack or drink some water.",
          "Think of three things that went okay today.",
          "Smile on purpose, just because.",
          "Light a flameless candle or turn on a soft light.",
        ],
      ],
      [
        [
          "Make a gratitude list.",
          "Write a journal entry about your day.",
          "Doodle freely or follow a simple drawing tutorial.",
          "Use a coloring book or app.",
          "Try a gratitude photo challenge.",
          "Make a simple collage (digital or paper) about an idea such as family, peace, or hope.",
          "Create a digital mood board for your goals or recovery.",
          "Decorate your space with something that makes you smile.",
          "Try making a simple origami figure or paper craft.",
        ],
        [
          "Play a phone game or app-based brain teaser.",
          "Organize a small space, like a drawer, desk, bag, or shelf.",
          "Read a short story or a few pages of a favorite book.",
          "Play an easy memory game or a matching app.",
        ],
        [
          "Meditate or practice deep breathing for 2-5 minutes.",
          "Try a guided breathing exercise.",
          "Wrap yourself in a cozy blanket.",
          "Do a quick body scan meditation.",
          "Watch clouds, birds, or trees from a window.",
          "Try silent sitting or listening for a few minutes.",
          "Play with a sensory item like playdough, fabric, or beads.",
          "Put on something that makes you feel good, whether it's a full outfit or just a pair of socks.",
          "Give yourself permission to rest, even if it's just for a few minutes.",
          "Try a short 5-minute body stretch video.",
          "Practice 5 minutes of slow, mindful breathing.",
        ],
        [
          "Look through old photos or memories.",
          "Send someone a kind message at least 2 sentences long about why you appreciate them.",
        ],
        [
          "Take a short walk, even if it's just around the room.",
          "Try progressive muscle relaxation, tensing each muscle entirely and then relaxing them one at a time.",
          "Try a short YouTube meditation or mindfulness video.",
          "Sit or stand outside for a few minutes and notice 1 sound, 1 color, and 1 scent.",
          "Watch the sunset or sunrise for a few minutes.",
        ],
        [
          "Pet or cuddle a pet or stuffed animal.",
          "Ask yourself, 'What do I need right now?', and do it.",
          "Say no to a stressor, out loud, in writing, or in your head.",
        ],
      ],
      [
        [
          "Knit, crochet, or do some other craft.",
          "Create a playlist of 'healing' or 'happy' songs.",
        ],
        [
          "Do a puzzle, word search, Sudoku, or crossword.",
          "Set a small weekly goal and track your progress.",
          "Rearrange or tidy a small corner of your space.",
          "Start a new book, try to read a couple of chapters in one you're already reading.",
        ],
        [
          "Read a short article or comic.",
          "Listen to a podcast or audiobook.",
          "Watch an episode of a favorite show.",
          "Journal about what brings you comfort.",
          "Write yourself a supportive letter.",
        ],
        ["Call or video chat with a loved one."],
        [
          "Massage a part of your body slowly and gently; this can be your hands, feet, scalp, neck, or another body part.",
        ],
        [
          "Make a ‘comfort kit’ with snacks, music, and items that calm you.",
          "Reflect on how others have supported you.",
        ],
      ],
    ],
    [
      [
        [
          "Draw or color something simple.",
          "Keep a comfort box with items that help you feel better nearby.",
          "Name five things you can see, hear, and feel right now.",
          "Write a short poem or haiku about something you love.",
          "Create a collage of colors that represent your emotions.",
          "Make a playlist reflecting your healing journey.",
        ],
        [
          "Set a tiny goal for the next hour.",
          "Write a to-do list for tomorrow that includes one fun activity.",
          "Learn one new word or phrase.",
          "Watch an informational YouTube video.",
        ],
        [
          "Listen to a favorite song.",
          "Scroll through calming photos, such as nature or animals.",
          "Take a photo of something you find beautiful.",
          "Repeat a positive affirmation to yourself.",
          "Play with a smooth stone or a fidget toy.",
          "Read a comforting quote or verse.",
          "Write down one hope for the future.",
          "Say or write: 'I am doing my best, and that is enough'.",
          "Write down three things you’re grateful for today.",
          "Lightly scent your space with something calming (lavender, vanilla, etc.)",
        ],
        [
          "Text a friend or family member.",
          "Give someone a positive message or compliment, in writing or in person.",
        ],
        [
          "Do simple stretches.",
          "Open a window and focus on feeling the fresh air.",
          "Water a plant or examine one closely.",
          "Take a few steps outside your door and describe what you see.",
          "Stretch your arms and back while standing or sitting.",
        ],
        [
          "Watch a light or funny video.",
          "Eat a small snack or drink some water.",
          "Think of three things that went okay today.",
          "Smile on purpose, just because.",
          "Light a flameless candle or turn on a soft light.",
          "Write down what friendship means to you.",
          "Reflect on who makes you feel supported.",
        ],
      ],
      [
        [
          "Make a gratitude list.",
          "Write a journal entry about your day.",
          "Doodle freely or follow a simple drawing tutorial.",
          "Use a coloring book or app.",
          "Try a gratitude photo challenge.",
          "Make a simple collage (digital or paper) about an idea such as family, peace, or hope.",
          "Create a digital mood board for your goals or recovery.",
          "Decorate your space with something that makes you smile.",
          "Try making a simple origami figure or paper craft.",
          "Make a small scrapbook or photo journal of your journey.",
        ],
        [
          "Play a phone game or app-based brain teaser.",
          "Organize a small space, like a drawer, desk, bag, or shelf.",
          "Read a short story or a few pages of a favorite book.",
          "Play an easy memory game or a matching app.",
          "Identify one challenge and brainstorm gentle solutions.",
          "Plan a small achievable goal for next week.",
        ],
        [
          "Meditate or practice deep breathing for 2-5 minutes.",
          "Try a guided breathing exercise.",
          "Wrap yourself in a cozy blanket.",
          "Do a quick body scan meditation.",
          "Watch clouds, birds, or trees from a window.",
          "Try silent sitting or listening for a few minutes.",
          "Play with a sensory item like playdough, fabric, or beads.",
          "Put on something that makes you feel good, whether it's a full outfit or just a pair of socks.",
          "Give yourself permission to rest, even if it's just for a few minutes.",
          "Try a short 5-minute body stretch video.",
          "Practice 5 minutes of slow, mindful breathing.",
          "Write about how you’ve grown through recent challenges.",
          "Record a voice note or video of your thoughts or reflections.",
          "Write affirmations for yourself and display them somewhere visible.",
        ],
        [
          "Look through old photos or memories.",
          "Send someone a kind message at least 2 sentences long about why you appreciate them.",
          "Join a virtual or local support group.",
          "Share a photo or story about something that brings you joy.",
        ],
        [
          "Take a short walk, even if it's just around the room.",
          "Try progressive muscle relaxation, tensing each muscle entirely and then relaxing them one at a time.",
          "Try a short YouTube meditation or mindfulness video.",
          "Sit or stand outside for a few minutes and notice 1 sound, 1 color, and 1 scent.",
          "Watch the sunset or sunrise for a few minutes.",
          "Walk a short path you enjoy and focus on rhythm and breathing.",
          "Do gentle upper-body stretches in some place calm.",
          "Lightly stretch your legs while sitting on a bench or step.",
        ],
        [
          "Pet or cuddle a pet or stuffed animal.",
          "Ask yourself, 'What do I need right now?', and do it.",
          "Say no to a stressor, out loud, in writing, or in your head.",
          "Write about how others have influenced your strength.",
        ],
      ],
      [
        [
          "Knit, crochet, or do some other craft.",
          "Create a playlist of 'healing' or 'happy' songs.",
          "Record or perform a song or story you love.",
          "Create a ‘self-portrait’ that shows your personality, not appearance.",
        ],
        [
          "Do a puzzle, word search, Sudoku, or crossword.",
          "Set a small weekly goal and track your progress.",
          "Rearrange or tidy a small corner of your space.",
          "Explore a topic that sparks your curiosity.",
          "Start a new book, try to read a couple of chapters in one you're already reading.",
        ],
        [
          "Read a short article or comic.",
          "Listen to a podcast or audiobook.",
          "Watch an episode of a favorite show.",
          "Journal about what brings you comfort.",
          "Write yourself a supportive letter.",
        ],
        [
          "Call or video chat with a loved one.",
          "Share something creative or personal that you’re proud of with someone you trust.",
          "Plan one enjoyable activity with someone you trust, such as watching a movie, taking a walk, or playing a game like chess.",
        ],
        [
          "Massage a part of your body slowly and gently; this can be your hands, feet, scalp, neck, or another body part.",
          "Take a mindful stroll outdoors, noticing your surroundings as you move.",
          "Practice balance and posture for 10-15 minutes.",
          "Take a long walk while listening to music, a podcast, or nature sounds.",
          "Visit an animal shelter, park, or pet store to interact with animals safely.",
        ],
        [
          "Make a ‘comfort kit’ with snacks, music, and items that calm you.",
          "Reflect on how others have supported you.",
          "Write down what you’d say to someone who’s struggling.",
          "Do one small act of kindness anonymously.",
        ],
      ],
    ],
  ];

  var pickedTasks = [];

  String currentTask = "";

  var doneTasks = [];

  List<Map<String, dynamic>> filteredTasks = [];

  int kittyInUse = 0;

  final List<List<String>> taskImages = [
    ["images/Tasks/Art1.png", "images/Tasks/Art2.png", "images/Tasks/Art3.png"],
    ["images/Tasks/Cog1.png", "images/Tasks/Cog2.png", "images/Tasks/Cog3.png"],
    ["images/Tasks/Min1.png", "images/Tasks/Min2.png", "images/Tasks/Min3.png"],
    ["images/Tasks/Soc1.png", "images/Tasks/Soc2.png", "images/Tasks/Soc3.png"],
    ["images/Tasks/Out1.png", "images/Tasks/Out2.png", "images/Tasks/Out3.png"],
    ["images/Tasks/Oth1.png", "images/Tasks/Oth2.png", "images/Tasks/Oth3.png"],
  ];

  final List<String> compTaskImages = [
    "images/TasksCom/Art.png",
    "images/TasksCom/Cog.png",
    "images/TasksCom/Min.png",
    "images/TasksCom/Soc.png",
    "images/TasksCom/Out.png",
    "images/TasksCom/Oth.png",
  ];

  List<String> sectionNames = [
    "Creative",
    "Cognitive",
    "Mindfulness",
    "Social",
    "Outdoor",
    "Other",
  ];

  List<String> taskSelectionImages = [];

  final List<List<String>> kittyImages = [
    [
      "images/BK/BKUO.png",
      "images/BK/BKUD.png",
      "images/BK/BKUU.png",
      "images/BK/BKMO.png",
      "images/BK/BKMD.png",
      "images/BK/BKMU.png",
      "images/BK/BKDO.png",
      "images/BK/BKDD.png",
      "images/BK/BKDU.png",
    ],
    [
      "images/CK/CKUO.png",
      "images/CK/CKUD.png",
      "images/CK/CKUU.png",
      "images/CK/CKMO.png",
      "images/CK/CKMD.png",
      "images/CK/CKMU.png",
      "images/CK/CKDO.png",
      "images/CK/CKDD.png",
      "images/CK/CKDU.png",
    ],
    [
      "images/SK/SKUO.png",
      "images/SK/SKUD.png",
      "images/SK/SKUU.png",
      "images/SK/SKMO.png",
      "images/SK/SKMD.png",
      "images/SK/SKMU.png",
      "images/SK/SKDO.png",
      "images/SK/SKDD.png",
      "images/SK/SKDU.png",
    ],
    [
      "images/WK/WKUO.png",
      "images/WK/WKUD.png",
      "images/WK/WKUU.png",
      "images/WK/WKMO.png",
      "images/WK/WKMD.png",
      "images/WK/WKMU.png",
      "images/WK/WKDO.png",
      "images/WK/WKDD.png",
      "images/WK/WKDU.png",
    ],

    [
      "images/BKC/BKCUO.png",
      "images/BKC/BKCUD.png",
      "images/BKC/BKCUU.png",
      "images/BKC/BKCMO.png",
      "images/BKC/BKCMD.png",
      "images/BKC/BKCMU.png",
      "images/BKC/BKCDO.png",
      "images/BKC/BKCDD.png",
      "images/BKC/BKCDU.png",
    ],
    [
      "images/CKC/CKCUO.png",
      "images/CKC/CKCUD.png",
      "images/CKC/CKCUU.png",
      "images/CKC/CKCMO.png",
      "images/CKC/CKCMD.png",
      "images/CKC/CKCMU.png",
      "images/CKC/CKCDO.png",
      "images/CKC/CKCDD.png",
      "images/CKC/CKCDU.png",
    ],
    [
      "images/SKC/SKCUO.png",
      "images/SKC/SKCUD.png",
      "images/SKC/SKCUU.png",
      "images/SKC/SKCMO.png",
      "images/SKC/SKCMD.png",
      "images/SKC/SKCMU.png",
      "images/SKC/SKCDO.png",
      "images/SKC/SKDCD.png",
      "images/SKC/SKCDU.png",
    ],
    [
      "images/WKC/WKCUO.png",
      "images/WKC/WKCUD.png",
      "images/WKC/WKCUU.png",
      "images/WKC/WKCMO.png",
      "images/WKC/WKCMD.png",
      "images/WKC/WKCMU.png",
      "images/WKC/WKCDO.png",
      "images/WKC/WKCDD.png",
      "images/WKC/WKCDU.png",
    ],

    [
      "images/BKT/BKTUO.png",
      "images/BKT/BKTUD.png",
      "images/BKT/BKTUU.png",
      "images/BKT/BKTMO.png",
      "images/BKT/BKTMD.png",
      "images/BKT/BKTMU.png",
      "images/BKT/BKTDO.png",
      "images/BKT/BKTDD.png",
      "images/BKT/BKTDU.png",
    ],
    [
      "images/CKT/CKTUO.png",
      "images/CKT/CKTUD.png",
      "images/CKT/CKTUU.png",
      "images/CKT/CKTMO.png",
      "images/CKT/CKTMD.png",
      "images/CKT/CKTMU.png",
      "images/CKT/CKTDO.png",
      "images/CKT/CKTDD.png",
      "images/CKT/CKTDU.png",
    ],
    [
      "images/SKT/SKTUO.png",
      "images/SKT/SKTUD.png",
      "images/SKT/SKTUU.png",
      "images/SKT/SKTMO.png",
      "images/SKT/SKTMD.png",
      "images/SKT/SKTMU.png",
      "images/SKT/SKTDO.png",
      "images/SKT/SKTDD.png",
      "images/SKT/SKTDU.png",
    ],
    [
      "images/WKT/WKTUO.png",
      "images/WKT/WKTUD.png",
      "images/WKT/WKTUU.png",
      "images/WKT/WKTMO.png",
      "images/WKT/WKTMD.png",
      "images/WKT/WKTMU.png",
      "images/WKT/WKTDO.png",
      "images/WKT/WKTDD.png",
      "images/WKT/WKTDU.png",
    ],

    [
      "images/BKH/BKHUO.png",
      "images/BKH/BKHUD.png",
      "images/BKH/BKHUU.png",
      "images/BKH/BKHMO.png",
      "images/BKH/BKHMD.png",
      "images/BKH/BKHMU.png",
      "images/BKH/BKHDO.png",
      "images/BKH/BKHDD.png",
      "images/BKH/BKHDU.png",
    ],
    [
      "images/CKH/CKHUO.png",
      "images/CKH/CKHUD.png",
      "images/CKH/CKHUU.png",
      "images/CKH/CKHMO.png",
      "images/CKH/CKHMD.png",
      "images/CKH/CKHMU.png",
      "images/CKH/CKHDO.png",
      "images/CKH/CKHDD.png",
      "images/CKH/CKHDU.png",
    ],
    [
      "images/SKH/SKHUO.png",
      "images/SKH/SKHUD.png",
      "images/SKH/SKHUU.png",
      "images/SKH/SKHMO.png",
      "images/SKH/SKHMD.png",
      "images/SKH/SKHMU.png",
      "images/SKH/SKHDO.png",
      "images/SKH/SKHDD.png",
      "images/SKH/SKHDU.png",
    ],
    [
      "images/WKH/WKHUO.png",
      "images/WKH/WKHUD.png",
      "images/WKH/WKHUU.png",
      "images/WKH/WKHMO.png",
      "images/WKH/WKHMD.png",
      "images/WKH/WKHMU.png",
      "images/WKH/WKHDO.png",
      "images/WKH/WKHDD.png",
      "images/WKH/WKHDU.png",
    ],
  ];

  final List<String> kittyNames = [
    "Black Kitty",
    "Calico Kitty",
    "Siamese Kitty",
    "White Kitty",
    "Collar for Black Kitty",
    "Collar for Calico Kitty",
    "Collar for Siamese Kitty",
    "Collar for White Kitty",
    "Hat for Black Kitty",
    "Hat for Calico Kitty",
    "Hat for Siamese Kitty",
    "Hat for White Kitty",
    "Witch Kitty",
    "Koi Fish Kitty",
    "Moth Kitty",
    "Angel Kitty",
  ];

  // Map for kittyInUse (variant: BK=0, CK=1, SK=2, WK=3)
  List<String> kittyTypes = [
    'BK',
    'CK',
    'SK',
    'WK',
    'BKC',
    'CKC',
    'SKC',
    'WKC',
    'BKT',
    'CKT',
    'SKT',
    'WKT',
    'BKH',
    'CKH',
    'SKH',
    'WKH',
  ];

  final List<List<int>> winPatterns = [
    [0, 1, 2, 3, 4], // rows 0-4
    [5, 6, 7, 8, 9], // rows 5-9
    [10, 11, 12, 13, 14], // rows 10-14
    [15, 16, 17, 18, 19], // rows 15-19
    [20, 21, 22, 23, 24], // rows 20-24
    [0, 5, 10, 15, 20], // columns 0,5,10,15,20
    [1, 6, 11, 16, 21], // columns 1,6,11,16,21
    [2, 7, 12, 17, 22], // columns 2,7,12,17,22
    [3, 8, 13, 18, 23], // columns 3,8,13,18,23
    [4, 9, 14, 19, 24], // columns 4,9,14,19,24
    [0, 6, 12, 18, 24], // diagonal top-left to bottom-right
    [4, 8, 12, 16, 20], // diagonal top-right to bottom-left
  ];

  List<bool> patternsChecked = List.filled(12, false);

  bool isPatternComplete(int patternIndex) {
    for (int idx in winPatterns[patternIndex]) {
      if (!doneTasks[idx]) return false;
    }
    return true;
  }

  // Not working right now, but will be used to update patterns
  // when a task is marked as done.
  int updatePatterns() {
    int completedPatterns = 0;
    for (int i = 0; i < winPatterns.length; i++) {
      if (!patternsChecked[i] && isPatternComplete(i)) {
        patternsChecked[i] = true;
        completedPatterns++;
      }
    }
    return completedPatterns;
  }

  final List<ColorPattern> colorPatterns = [
    ColorPattern(
      "Mint",
      Color.fromARGB(255, 221, 255, 199),
      Color.fromARGB(255, 15, 115, 60),
    ),
    ColorPattern(
      "Lavender",
      Color.fromARGB(255, 230, 220, 255),
      Color.fromARGB(255, 90, 60, 150),
    ),
    ColorPattern(
      "Peach",
      Color.fromARGB(255, 255, 230, 200),
      Color.fromARGB(255, 200, 100, 50),
    ),
    ColorPattern(
      "Blueberry",
      Color.fromARGB(255, 184, 225, 255),
      Color.fromARGB(255, 30, 17, 81),
    ),
    ColorPattern(
      "Monocrome",
      Color.fromARGB(255, 229, 229, 229),
      Color.fromARGB(255, 76, 76, 76),
    ),
    ColorPattern(
      "Dark Mint",
      Color.fromARGB(255, 69, 90, 56),
      Color.fromARGB(255, 5, 37, 19),
    ),
    ColorPattern(
      "Dark Lavender",
      Color.fromARGB(255, 92, 82, 118),
      Color.fromARGB(255, 27, 17, 47),
    ),
    ColorPattern(
      "Dark Peach",
      Color.fromARGB(255, 102, 84, 63),
      Color.fromARGB(255, 62, 30, 14),
    ),
    ColorPattern(
      "Dark Blue",
      Color.fromARGB(255, 87, 82, 125),
      Color.fromARGB(255, 4, 5, 35),
    ),
    ColorPattern(
      "Dark Mono",
      Color.fromARGB(255, 105, 105, 105),
      Color.fromARGB(255, 0, 0, 0),
    ),
  ];

  int money = 0;

  // kittyImage(List<List<String>> kittyImages, int kittyNumber, int kittyInUse)

  late List<Map<String, dynamic>> shopItems;
  bool isLoading = true;
  late List<String> catImages;

  @override
  void initState() {
    super.initState();

    loadData().then((_) async {
      // Only generate tasks if nothing was saved
      if (filteredTasks.isEmpty) {
        filteredTasks = genTaskList();
      }

      // Only set pickedTasks if nothing was saved
      if (pickedTasks.isEmpty) {
        pickedTasks = filteredTasks;
      }

      // Only set doneTasks if nothing was saved
      if (doneTasks.isEmpty) {
        doneTasks = List.filled(25, false);
      }
      updateCatImages();
      isLoading = false;
      setState(() {});
    });
    catImages = List.generate(9, (index) => kittyImages[kittyInUse][index]);
    shopItems = List.generate(
      16,
      (index) => {
        'image': 'images/${kittyTypes[index]}/${kittyTypes[index]}UO.png',
        'name': kittyNames[index],
        'price': getPriceForIndex(index),
        'purchased': index < 4,
        'using': index == 0,
      },
    );
  }

  void updateCatImages() {
    catImages = List.generate(9, (index) => kittyImages[kittyInUse][index]);
  }

  int getPriceForIndex(int index) {
    if (index < 4) {
      return 0; // first 4 free
    } else if (index < 8) {
      return 50; // second 4 cost 50
    } else if (index < 12) {
      return 100; // third 4 cost 100
    } else {
      return 200; // remaining cost 200
    }
  }

  var hideSections = [false, false];
  var hideLongs = false;
  int taskLevel = 0;
  List<Map<String, dynamic>> genTaskList() {
    if (taskLevel < 0 || taskLevel >= tasks.length) return [];

    List<List<List<String>>> levelList = tasks[taskLevel];
    List<Map<String, dynamic>> available = [];

    // Build list with section info preserved
    for (int j = 0; j < levelList.length; j++) {
      // j = section (0=short, 1=medium, 2=long)
      for (int k = 0; k < levelList[j].length; k++) {
        if (hideLongs && j == 2) continue; // hide longs
        if (hideSections[0] && k == 3) continue; // hide Social
        if (hideSections[1] && k == 4) continue; // hide Outdoor

        for (String task in levelList[j][k]) {
          available.add({
            'task': task,
            'category': k, // Art..Oth
            'section': j, // 0 short, 1 medium, 2 long
          });
        }
      }
    }

    if (available.isEmpty) return [];

    Random rng = Random();
    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < 25; i++) {
      var item = available[rng.nextInt(available.length)];
      String task = item['task'];
      int category = item['category'];
      int order = item['section']; // image index based on short/med/long

      // safety check in case image set is smaller than expected
      if (order >= taskImages[category].length) order = 0;

      result.add({
        'task': task,
        'category': category,
        'index': i,
        'tsi': taskImages[category][order],
      });
    }

    return result;
  }

  int parseTaskCategory(String task) {
    if (task.startsWith("Art")) return 0;
    if (task.startsWith("Cog")) return 1;
    if (task.startsWith("Min")) return 2;
    if (task.startsWith("Soc")) return 3;
    if (task.startsWith("Out")) return 4;
    if (task.startsWith("Oth")) return 5;
    return 0;
  }

  String getTaskImage(int category, int section, bool isCategoryCompleted) {
    if (isCategoryCompleted) {
      return compTaskImages[category];
    } else {
      return taskImages[category][section];
    }
  }

  void buyItem(int index) {
    int price = getPriceForIndex(index);
    if (money >= price && !shopItems[index]['purchased']) {
      setState(() {
        money -= price;
        shopItems[index]['purchased'] = true;
      });
    } else {
      // Not enough money or already purchased
    }
  }

  int selectedPattern = 0;

  // --- Kitty animation timer fields ---
  Timer? _kittyTimer;

  void _startKittyAnimation() {
    _kittyTimer?.cancel();
    // The custom animation sequence:
    final List<int> frames = [2, 0, 3, 6, 8, 6, 3, 0];
    int frameIndex = 0;
    _kittyTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (screenDisplayed != 1) {
        _kittyTimer?.cancel();
        return;
      }
      setState(() {
        kittyNumber = frames[frameIndex];
        frameIndex = (frameIndex + 1) % frames.length;
      });
    });
  }

  void _stopKittyAnimation() {
    _kittyTimer?.cancel();
  }

  @override
  void dispose() {
    _kittyTimer?.cancel();
    super.dispose();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // --- Save integers ---
    prefs.setInt('kittyNumber', kittyNumber);
    prefs.setInt('heartNumber', heartNumber);
    prefs.setInt('textSize', textSize);
    prefs.setInt('kittyInUse', kittyInUse);
    prefs.setInt('selectedPattern', selectedPattern);
    prefs.setInt('taskLevel', taskLevel);
    prefs.setInt('money', money);
    prefs.setInt('screenDisplayed', screenDisplayed);
    prefs.setInt('currentTaskIndex', currentTaskIndex);

    // --- Save strings ---
    prefs.setString('boardItem', boardItem);
    prefs.setString('currentTask', currentTask);

    // --- Save colors ---
    prefs.setInt('backgroundColor', backgroundColor.value);
    prefs.setInt('foregroundColor', foregroundColor.value);

    // --- Save booleans ---
    prefs.setBool('hideLongs', hideLongs);
    prefs.setBool('showResetConfirmation', showResetConfirmation);

    // --- Save lists as JSON strings ---
    prefs.setString('pickedTasks', jsonEncode(pickedTasks)); // List<String>
    prefs.setString('doneTasks', jsonEncode(doneTasks)); // List<String>
    prefs.setString(
      'taskSelectionImages',
      jsonEncode(taskSelectionImages),
    ); // List<String>
    prefs.setString('HideSections', jsonEncode(hideSections)); // List<bool>
    prefs.setString(
      'patternsChecked',
      jsonEncode(patternsChecked),
    ); // List<bool>
    prefs.setString(
      'filteredTasks',
      jsonEncode(filteredTasks),
    ); // List<Map<String, dynamic>>

    // --- Save shopItems ---
    prefs.setString(
      'shopItems',
      jsonEncode(shopItems),
    ); // List<Map<String, dynamic>>
  }

  // Helper functions for background decoding
  Future<List<String>> decodeStringList(String jsonString) async {
    return List<String>.from(jsonDecode(jsonString));
  }

  Future<List<bool>> decodeBoolList(String jsonString) async {
    return List<bool>.from(jsonDecode(jsonString));
  }

  Future<List<Map<String, dynamic>>> decodeMapList(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is List) {
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // --- Load simple types ---
    kittyNumber = prefs.getInt('kittyNumber') ?? kittyNumber;
    heartNumber = prefs.getInt('heartNumber') ?? heartNumber;
    textSize = prefs.getInt('textSize') ?? textSize;
    kittyInUse = prefs.getInt('kittyInUse') ?? kittyInUse;
    selectedPattern = prefs.getInt('selectedPattern') ?? selectedPattern;
    taskLevel = prefs.getInt('taskLevel') ?? taskLevel;
    money = prefs.getInt('money') ?? money;
    screenDisplayed = prefs.getInt('screenDisplayed') ?? screenDisplayed;
    currentTaskIndex = prefs.getInt('currentTaskIndex') ?? currentTaskIndex;

    boardItem = prefs.getString('boardItem') ?? boardItem;
    currentTask = prefs.getString('currentTask') ?? currentTask;

    int? bgColorInt = prefs.getInt('backgroundColor');
    backgroundColor = bgColorInt != null ? Color(bgColorInt) : backgroundColor;

    int? fgColorInt = prefs.getInt('foregroundColor');
    foregroundColor = fgColorInt != null ? Color(fgColorInt) : foregroundColor;

    hideLongs = prefs.getBool('hideLongs') ?? hideLongs;
    showResetConfirmation =
        prefs.getBool('showResetConfirmation') ?? showResetConfirmation;

    // --- Load lists asynchronously if they exist ---
    try {
      String? pickedTasksJson = prefs.getString('pickedTasks');
      if (pickedTasksJson != null && pickedTasksJson.isNotEmpty) {
        pickedTasks = List<String>.from(jsonDecode(pickedTasksJson));
      }
    } catch (e) {
      print('Error decoding: $e');
    }
    try {
      String? doneTasksJson = prefs.getString('doneTasks');
      if (doneTasksJson != null && doneTasksJson.isNotEmpty) {
        doneTasks = List<bool>.from(jsonDecode(doneTasksJson));
      }
    } catch (e) {
      print('Error decoding: $e');
    }

    try {
      String? taskSelectionImagesJson = prefs.getString('taskSelectionImages');
      if (taskSelectionImagesJson != null &&
          taskSelectionImagesJson.isNotEmpty) {
        taskSelectionImages = List<String>.from(
          jsonDecode(taskSelectionImagesJson),
        );
      }
    } catch (e) {
      print('Error decoding: $e');
    }

    try {
      String? hideSectionsJson = prefs.getString('HideSections');
      if (hideSectionsJson != null && hideSectionsJson.isNotEmpty) {
        hideSections = List<bool>.from(jsonDecode(hideSectionsJson));
      }
    } catch (e) {
      print('Error decoding: $e');
    }

    try {
      String? patternsCheckedJson = prefs.getString('patternsChecked');
      if (patternsCheckedJson != null && patternsCheckedJson.isNotEmpty) {
        patternsChecked = List<bool>.from(jsonDecode(patternsCheckedJson));
      }
    } catch (e) {
      print('Error decoding: $e');
    }

    try {
      String? filteredTasksJson = prefs.getString('filteredTasks');
      if (filteredTasksJson != null && filteredTasksJson.isNotEmpty) {
        filteredTasks = List<Map<String, dynamic>>.from(
          jsonDecode(filteredTasksJson),
        );
      }
    } catch (e) {
      print('Error decoding: $e');
    }

    try {
      String? shopItemsJson = prefs.getString('shopItems');
      if (shopItemsJson != null && shopItemsJson.isNotEmpty) {
        shopItems = List<Map<String, dynamic>>.from(jsonDecode(shopItemsJson));
      }
    } catch (e) {
      print('Error decoding: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    //Main Screen
    if (screenDisplayed == 0) {
      _stopKittyAnimation();
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.lightbulb),
                iconSize: 50,
                color: backgroundColor,
                onPressed: () {
                  setState(() {
                    kittyNumber = 0;
                    heartNumber = 0;
                    screenDisplayed = 4;
                  });
                  saveData();
                  _stopKittyAnimation();
                },
              ),
              title: const Center(child: Text("Theragame")),
              backgroundColor: foregroundColor,
              titleTextStyle: TextStyle(color: backgroundColor, fontSize: 50),
              toolbarHeight: 120,
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  iconSize: 50,
                  color: backgroundColor,
                  onPressed: () async {
                    setState(() {
                      kittyNumber = 5;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      kittyNumber = 0;
                      screenDisplayed = 1;
                    });
                    saveData();
                    _startKittyAnimation(); // Start animation when entering settings
                  },
                ),
              ],
            ),

            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          color: Color.fromARGB(255, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage('images/background.png'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: FractionallySizedBox(
                              widthFactor: 0.6,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image(
                                  image: AssetImage(catImages[kittyNumber]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image(
                                image: AssetImage(heartImage(heartNumber)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 70.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              kittyNumber = 4;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              kittyNumber = 0;
                              screenDisplayed = 5;
                            });
                            _stopKittyAnimation(); // Start animation when entering settings
                            saveData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: foregroundColor,
                            foregroundColor: backgroundColor,
                            textStyle: TextStyle(fontSize: textSize.toDouble()),
                          ),
                          child: const Text('Shop'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              kittyNumber = 5;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              kittyNumber = 0;
                              screenDisplayed = 2;
                            });
                            _stopKittyAnimation(); // Stop animation if leaving settings
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: foregroundColor,
                            foregroundColor: backgroundColor,
                            textStyle: TextStyle(fontSize: textSize.toDouble()),
                          ),
                          child: const Text('Board'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              kittyNumber = 3;
                              heartNumber = 1;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              kittyNumber = 8;
                              heartNumber = 2;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              kittyNumber = 3;
                              heartNumber = 1;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              kittyNumber = 0;
                              heartNumber = 0;
                            });
                            saveData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: foregroundColor,
                            foregroundColor: backgroundColor,
                            textStyle: TextStyle(fontSize: textSize.toDouble()),
                          ),
                          child: const Text('Pet Kitty'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: backgroundColor,
                    width: 150.0,
                    height: 150.0,
                    padding: const EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Meow-come to Theragame my purr-tastic friend!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            color: foregroundColor,
                            fontSize: textSize.toDouble(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Settings Screen
    if (screenDisplayed == 1) {
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.home),
                iconSize: 100,
                color: backgroundColor,
                onPressed: () {
                  setState(() {
                    kittyNumber = 0;
                    heartNumber = 0;
                    screenDisplayed = 0;
                  });
                  _stopKittyAnimation(); // Stop animation when leaving settings
                  saveData();
                },
              ),
              title: const Center(child: Text("Settings")),
              backgroundColor: foregroundColor,
              titleTextStyle: TextStyle(color: backgroundColor, fontSize: 50),
              toolbarHeight: 120,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: backgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Text Size:",
                                style: TextStyle(
                                  fontSize: textSize.toDouble(),
                                  color: foregroundColor,
                                ),
                              ),
                            ),
                            Slider(
                              value: textSize.toDouble(),
                              min: 12,
                              max: 28,
                              divisions: 8,
                              label: textSize.toString(),
                              activeColor: foregroundColor,
                              thumbColor: foregroundColor,
                              inactiveColor: backgroundColor,
                              onChanged: (double newValue) {
                                setState(() {
                                  textSize = newValue.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Color Pattern:",
                                style: TextStyle(
                                  fontSize: textSize.toDouble(),
                                  color: foregroundColor,
                                ),
                              ),
                            ),
                            DropdownButton<int>(
                              value: selectedPattern,
                              dropdownColor:
                                  colorPatterns[selectedPattern].background,
                              style: TextStyle(
                                color:
                                    colorPatterns[selectedPattern].foreground,
                                fontSize: textSize.toDouble() > 22
                                    ? textSize.toDouble() - 6
                                    : textSize.toDouble() + 4,
                              ),
                              items: List.generate(
                                colorPatterns.length,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(colorPatterns[index].name),
                                ),
                              ),
                              onChanged: (int? newIndex) {
                                if (newIndex != null) {
                                  setState(() {
                                    selectedPattern = newIndex;
                                    backgroundColor =
                                        colorPatterns[newIndex].background;
                                    foregroundColor =
                                        colorPatterns[newIndex].foreground;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Task Level:",
                                style: TextStyle(
                                  fontSize: textSize.toDouble(),
                                  color: foregroundColor,
                                ),
                              ),
                            ),
                            Slider(
                              value: taskLevel.toDouble(),
                              min: 0,
                              max: 2,
                              divisions: 2,
                              label: (taskLevel + 1).toString(),
                              activeColor: foregroundColor,
                              thumbColor: foregroundColor,
                              inactiveColor: backgroundColor,
                              onChanged: (double newValue) {
                                setState(() {
                                  taskLevel = newValue.toInt();
                                  doneTasks = List.filled(25, false);
                                  patternsChecked = List.filled(12, false);
                                  pickedTasks = genTaskList();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: colorPatterns[selectedPattern].background,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: Listenable.merge([
                                ValueNotifier(screenDisplayed),
                              ]),
                              builder: (context, _) {
                                if (_kittyTimer == null ||
                                    !_kittyTimer!.isActive) {
                                  _startKittyAnimation();
                                }

                                // compute an inverse scale factor from textSize (12..28)
                                final double minText = 12.0;
                                final double maxText = 28.0;
                                double t =
                                    ((maxText - textSize) / (maxText - minText))
                                        .clamp(0.0, 1.0);
                                // widthFactor ranges roughly from 0.8 (big text) to 1.0 (small text)
                                double widthFactor = 0.8 + (0.2 * t);

                                return FractionallySizedBox(
                                  widthFactor: widthFactor,
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image(
                                      image: AssetImage(catImages[kittyNumber]),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: foregroundColor,
                                foregroundColor: backgroundColor,
                                textStyle: TextStyle(
                                  fontSize: textSize.toDouble(),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  showResetConfirmation =
                                      !showResetConfirmation;
                                });
                              },
                              child: const Text("Reset App"),
                            ),

                            // Show Confirm and Cancel if toggled on
                            if (showResetConfirmation) ...[
                              const SizedBox(height: 8),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Wrap(
                                      spacing: 16,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: foregroundColor,
                                            foregroundColor: backgroundColor,
                                          ),
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            await prefs.clear();
                                            setState(() {
                                              selectedPattern = 0;
                                              kittyNumber = 0;
                                              kittyInUse = 0;
                                              updateCatImages();
                                              backgroundColor =
                                                  colorPatterns[0].background;
                                              foregroundColor =
                                                  colorPatterns[0].foreground;
                                              textSize = 24;
                                              pickedTasks.clear();
                                              filteredTasks.clear();
                                              pickedTasks = genTaskList();
                                              doneTasks = List.filled(
                                                25,
                                                false,
                                              );
                                              taskLevel = 0;
                                              filteredTasks = [];
                                              hideSections = [false, false];
                                              hideLongs = false;
                                              patternsChecked = List.filled(
                                                12,
                                                false,
                                              );
                                              money = 0;
                                              shopItems = List.generate(
                                                16,
                                                (index) => {
                                                  'image':
                                                      'images/${kittyTypes[index]}/${kittyTypes[index]}UO.png',
                                                  'name': kittyNames[index],
                                                  'price': getPriceForIndex(
                                                    index,
                                                  ),
                                                  'purchased':
                                                      index <
                                                      4, // first 4 are unlocked by default
                                                  'using':
                                                      index ==
                                                      0, // first one is in use by default
                                                },
                                              );

                                              showResetConfirmation = false;
                                            });
                                            saveData();
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                          height: 3,
                                        ), // horizontal space between buttons
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: foregroundColor,
                                            foregroundColor: backgroundColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showResetConfirmation = false;
                                            });
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Board Screen
    if (screenDisplayed == 2) {
      _stopKittyAnimation();
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,

            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.home),
                iconSize: 100,
                color: backgroundColor,
                onPressed: () {
                  setState(() {
                    screenDisplayed = 0;
                  });
                  _stopKittyAnimation();
                  saveData();
                },
              ),
              title: Text(
                "Board",
                style: TextStyle(color: backgroundColor, fontSize: 50),
              ),
              centerTitle: true, // <- This centers the title properly
              backgroundColor: foregroundColor,
              toolbarHeight: 120,
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  iconSize: 100,
                  color: backgroundColor,
                  onPressed: () async {
                    setState(() {
                      pickedTasks = genTaskList();
                      for (int i = 0; i < doneTasks.length; i++) {
                        doneTasks[i] = false;
                      }
                      saveData();
                    });
                  },
                ),
              ],
            ),

            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate the size for square buttons (fit 6 rows, 5 columns)
                        final double buttonSpacing =
                            15.0; // total vertical/horizontal padding per button
                        final double buttonWidth =
                            (constraints.maxWidth - (4 * buttonSpacing)) / 5;
                        final double buttonHeight =
                            (constraints.maxHeight - (5 * buttonSpacing)) / 6;
                        final double buttonSize = buttonWidth < buttonHeight
                            ? buttonWidth
                            : buttonHeight;

                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top row: 5 text containers
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (col) => Container(
                                    width: buttonSize,
                                    height: buttonSize,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: foregroundColor,
                                      border: Border.all(
                                        color: backgroundColor,
                                      ),
                                    ),
                                    child: Text(
                                      boardItem.substring(col, col + 1),
                                      style: TextStyle(
                                        color: backgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textSize.toDouble(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 5 rows of 5 square buttons
                              ...List.generate(
                                5,
                                (row) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (col) => Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: SizedBox(
                                        width: buttonSize,
                                        height: buttonSize,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: foregroundColor,
                                            foregroundColor: backgroundColor,
                                            side: BorderSide(
                                              color: backgroundColor,
                                            ),
                                            padding: EdgeInsets.zero,
                                            shape:
                                                RoundedRectangleBorder(), // removes circular shape
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              // Do something based on the position
                                              if (row == 0 && col == 0) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 1) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 2) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 3) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 4) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 0) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 1) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 2) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 3) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 4) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 0) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 1) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 2) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 3) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 4) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 0) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 1) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 2) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 3) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 4) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 0) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 1) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 2) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 3) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 4) {
                                                int index = row * 5 + col;
                                                setState(() {
                                                  currentTaskIndex = index;
                                                  currentTask =
                                                      pickedTasks[index]['task'];
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              }
                                            });
                                          },
                                          child: SizedBox(
                                            width: buttonSize * 0.8,
                                            height: buttonSize * 0.8,
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: SizedBox(
                                                width: buttonSize,
                                                height: buttonSize,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        foregroundColor,
                                                    foregroundColor:
                                                        backgroundColor,
                                                    side: BorderSide(
                                                      color: foregroundColor,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(),
                                                  ),
                                                  onPressed: () {
                                                    int index = row * 5 + col;
                                                    setState(() {
                                                      currentTaskIndex = index;
                                                      currentTask =
                                                          pickedTasks[index]['task'];
                                                      kittyNumber = 0;
                                                      heartNumber = 0;
                                                      screenDisplayed =
                                                          3; // Open task screen
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: buttonSize * 0.8,
                                                    height: buttonSize * 0.8,
                                                    child: Image.asset(
                                                      doneTasks[row * 5 + col]
                                                          ? compTaskImages[(pickedTasks[row *
                                                                            5 +
                                                                        col]['category']
                                                                    is int)
                                                                ? pickedTasks[row *
                                                                              5 +
                                                                          col]['category']
                                                                      as int
                                                                : 0]
                                                          : (pickedTasks[row *
                                                                            5 +
                                                                        col]['tsi']
                                                                    as String? ??
                                                                'images/placeholder.png'),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8, // horizontal spacing between buttons
                      runSpacing: 8, // vertical spacing between rows of buttons
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hideSections[0] = !hideSections[0];
                              filteredTasks = genTaskList();
                              pickedTasks = filteredTasks;
                              for (int i = 0; i < doneTasks.length; i++) {
                                doneTasks[i] = false;
                              }
                            });
                          },
                          child: Text(
                            hideSections[0] ? "Show Social" : "Hide Social",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hideSections[1] = !hideSections[1];
                              filteredTasks = genTaskList();
                              pickedTasks = filteredTasks;
                              for (int i = 0; i < doneTasks.length; i++) {
                                doneTasks[i] = false;
                              }
                            });
                          },
                          child: Text(
                            hideSections[1] ? "Show Outdoor" : "Hide Outdoor",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hideLongs = !hideLongs;
                              filteredTasks = genTaskList();
                              pickedTasks = filteredTasks;
                              for (int i = 0; i < doneTasks.length; i++) {
                                doneTasks[i] = false;
                              }
                            });
                          },
                          child: Text(hideLongs ? "Show Long" : "Hide Long"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Clear all sample filters.
                              hideSections = [false, false];
                              hideLongs = false;
                              filteredTasks = genTaskList();
                              pickedTasks = filteredTasks;
                              for (int i = 0; i < doneTasks.length; i++) {
                                doneTasks[i] = false;
                              }
                            });
                          },
                          child: const Text("Clear"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Board Extra Screen
    if (screenDisplayed == 3) {
      _stopKittyAnimation();
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 100,
                color: backgroundColor,
                onPressed: () {
                  setState(() {
                    screenDisplayed = 2;
                  });
                  _stopKittyAnimation();
                  saveData();
                },
              ),
              title: const Center(child: Text("Task")),
              backgroundColor: foregroundColor,
              titleTextStyle: TextStyle(color: backgroundColor, fontSize: 50),
              toolbarHeight: 120,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Background container with centered text
                        Container(
                          width: double.infinity,
                          color: backgroundColor,
                          padding: EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment(
                              0,
                              0.75,
                            ), // x=0 is center, y=0.75 pushes it lower
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  currentTask,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: foregroundColor,
                                    fontSize: textSize.toDouble(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 250.0,
                          padding: EdgeInsets.all(0.0),
                          color: colorPatterns[selectedPattern].background,
                          child: Align(
                            alignment: Alignment(0.4, 0),
                            child: Padding(
                              padding: EdgeInsets.only(top: 70.0),
                              child: Transform.scale(
                                scale: 1.75, // 1.5x the current size
                                child: Image(
                                  image: AssetImage(catImages[kittyNumber]),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: foregroundColor,
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                        textStyle: TextStyle(fontSize: textSize.toDouble()),
                      ),
                      onPressed: () async {
                        setState(() {
                          kittyNumber = 5;
                        });
                        await Future.delayed(Duration(seconds: 1));
                        setState(() {
                          print("Marking task index $currentTaskIndex as done");
                          kittyNumber = 0;
                          print(kittyNumber = 0);
                          if (currentTaskIndex != -1 &&
                              currentTaskIndex < doneTasks.length) {
                            if (doneTasks[currentTaskIndex] == false) {
                              doneTasks[currentTaskIndex] = true;
                              money += 1;
                            }
                          }
                          money += updatePatterns() * 10;
                          currentTaskIndex = -1;
                          screenDisplayed = 2;
                        });
                        saveData();
                      },
                      child: Text('Mark as Done'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: foregroundColor,
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                        textStyle: TextStyle(fontSize: textSize.toDouble()),
                      ),
                      onPressed: () {
                        setState(() async {
                          setState(() {
                            kittyNumber = 4;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 0;
                            screenDisplayed = 1;
                          });
                          if (currentTaskIndex != -1) {
                            if (doneTasks[currentTaskIndex] == true) {
                              money -= 1;
                              doneTasks[currentTaskIndex] = false;

                              for (int i = 0; i < winPatterns.length; i++) {
                                // Skip patterns that are not marked completed
                                if (!patternsChecked[i]) continue;

                                // If this pattern includes the task we just removed
                                if (winPatterns[i].contains(currentTaskIndex)) {
                                  // Check if the pattern is now broken
                                  bool nowIncomplete = !isPatternComplete(i);

                                  if (nowIncomplete) {
                                    patternsChecked[i] = false;
                                    money -= 10;
                                  }
                                }
                              }
                            }
                          }
                          currentTaskIndex = -1;
                          screenDisplayed = 2;
                        });
                        saveData();
                      },
                      child: Text('Mark as Not Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Info Screen
    if (screenDisplayed == 4) {
      _stopKittyAnimation();
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.home),
                iconSize: 50,
                color: backgroundColor,
                onPressed: () {
                  setState(() {
                    screenDisplayed = 0;
                  });
                  _stopKittyAnimation();
                  saveData();
                },
              ),
              title: const Center(child: Text("Information")),
              backgroundColor: foregroundColor,
              titleTextStyle: TextStyle(color: backgroundColor, fontSize: 50),
              toolbarHeight: 120,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: backgroundColor,
                      padding: EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Text(
                            'Disclamer: This app was made by a student for a Girl Scouts Gold Award project and is not mediaclly approved. Do not use this app as a substitute for professional therapy or medical advice.\n\nHello!\n\nWelcome to Theragame, a game designed to help you come to enjoy therapy and spend time with your virtual kitty.\n\nYou can interact with your kitty, complete tasks, and even shop for new kitties with in game money earned from completting 5 tasks in a row much like a bingo board and then spend it in the shop screen.\n\nTo complette tasks, go to the board screen and click on the squares. You can mark tasks as done as you do them and go back to the board screen by either pressing the -Not Done- button or the back arrow at the top left.\n\nHave fun and enjoy your time with your kitty!\n\nCreated by: Raley Wilkin\n\nVersion: 2.0.2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: textSize.toDouble(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Shop Screen (screenDisplayed == 5)
    if (screenDisplayed == 5) {
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: foregroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: AppBar(
                backgroundColor: foregroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.home),
                  color: backgroundColor,
                  iconSize: 40,
                  onPressed: () {
                    setState(() {
                      screenDisplayed = 0;
                    });
                    saveData();
                  },
                ),
                flexibleSpace: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shop',
                        style: TextStyle(fontSize: 50, color: backgroundColor),
                      ),
                      Text(
                        'Money Owned: \$${money.toString()}',
                        style: TextStyle(fontSize: 20, color: backgroundColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.40,
              ),
              itemCount: shopItems.length,
              itemBuilder: (context, index) {
                var item = shopItems[index];
                return Card(
                  color: backgroundColor,
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top: Kitty name text
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            color: foregroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: textSize.toDouble() > 22
                                ? textSize.toDouble() - 6
                                : textSize.toDouble() + 4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Middle: Kitty image
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Bottom: Button with state-dependent text
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item['purchased'] == true
                                ? ((item['using'] ?? false)
                                      ? backgroundColor
                                      : foregroundColor)
                                : backgroundColor,
                            foregroundColor: item['purchased'] == true
                                ? ((item['using'] ?? false)
                                      ? foregroundColor
                                      : backgroundColor)
                                : foregroundColor,
                          ),
                          onPressed: () {
                            setState(() {
                              if (item['purchased'] != true) {
                                buyItem(index);
                              } else {
                                // Mark all items as not in use then mark this one as in use!
                                for (var i = 0; i < shopItems.length; i++) {
                                  shopItems[i]['using'] = false;
                                }
                                item['using'] = true;
                                kittyInUse = index;
                                updateCatImages();
                              }
                            });
                            saveData();
                          },
                          child: Text(
                            item['purchased'] != true
                                ? 'Buy for \$${item['price']}'
                                : ((item['using'] ?? false)
                                      ? 'Using'
                                      : 'Bought'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Fallback
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.lightbulb),
              iconSize: 50,
              color: backgroundColor,
              onPressed: () {
                setState(() {
                  kittyNumber = 0;
                  heartNumber = 0;
                  screenDisplayed = 4;
                });
                _stopKittyAnimation();
                saveData();
              },
            ),
            title: const Center(child: Text("Theragame")),
            backgroundColor: foregroundColor,
            titleTextStyle: TextStyle(color: backgroundColor, fontSize: 50),
            toolbarHeight: 120,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                iconSize: 50,
                color: backgroundColor,
                onPressed: () async {
                  setState(() {
                    kittyNumber = 5;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    kittyNumber = 0;
                    screenDisplayed = 1;
                  });
                  _startKittyAnimation(); // Start animation when entering settings
                  saveData();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 0, 0, 0),
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('images/background.png'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image(
                                image: AssetImage(catImages[kittyNumber]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image(
                              image: AssetImage(heartImage(heartNumber)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150.0,
                  height: 70.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            kittyNumber = 5;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 0;
                          });
                          saveData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: foregroundColor,
                          foregroundColor: backgroundColor,
                          textStyle: TextStyle(fontSize: textSize.toDouble()),
                        ),
                        child: const Text('Settings'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            kittyNumber = 4;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 0;
                          });
                          saveData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: foregroundColor,
                          foregroundColor: backgroundColor,
                          textStyle: TextStyle(fontSize: textSize.toDouble()),
                        ),
                        child: const Text('Board'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            kittyNumber = 3;
                            heartNumber = 1;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 6;
                            heartNumber = 2;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 3;
                            heartNumber = 1;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            kittyNumber = 0;
                            heartNumber = 0;
                          });
                          saveData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: foregroundColor,
                          foregroundColor: backgroundColor,
                          textStyle: TextStyle(fontSize: textSize.toDouble()),
                        ),
                        child: const Text('Pet Kitty'),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: backgroundColor,
                  width: 150.0,
                  height: 150.0,
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Meow-come to Theragame my purr-tastic friend!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String kittyImage(
  List<List<String>> kittyImages,
  int kittyNumber,
  int kittyInUse,
) {
  // Ensure kittyInUse is within bounds, else default to 0
  int kittyIndex = (kittyInUse >= 0 && kittyInUse < kittyImages.length)
      ? kittyInUse
      : 0;

  // Ensure kittyNumber is between 1 and 9 (since your inner lists have 9 images)
  int imageIndex = (kittyNumber >= 1 && kittyNumber <= 9) ? kittyNumber - 1 : 0;

  return kittyImages[kittyIndex][imageIndex];
}

String heartImage(int heartNumber) {
  if (heartNumber == 1) {
    return "images/heartLeft.png";
  } else if (heartNumber == 2) {
    return "images/heartRight.png";
  } else {
    return "images/noHeart.png";
  }
}

class ColorPattern {
  final String name;
  final Color background;
  final Color foreground;
  ColorPattern(this.name, this.background, this.foreground);
}
