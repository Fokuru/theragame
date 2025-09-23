import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

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

  var tasks = [
    "Take a short walk, even if it's just around the room",
    "Listen to a favorite song",
    "Draw or color something simple",
    "Watch a light or funny video",
    "Write a journal entry about your day",
    "Do a puzzle, word search, sedoku, or crossword",
    "Knit, crochet, or do some other simple craft",
    "Meditate or practice deep breathing for 2-5 minutes",
    "Try a guided breathing exercise",
    "Text a friend or family member",
    "Scroll through calming photos, such as nature or animals",
    "Pet or cuddle a pet or stuffed animal",
    "Eat a small snack or drink some water",
    "Read a short article or comic",
    "Take a photo of something you find beautiful",
    "Play a phone game or app-based brain teaser",
    "Doodle freely or follow a simple drawing tutorial",
    "Do simple stretches",
    "Make a gratitude list",
    "Look through old photos or memories",
    "Creat a playlist of 'healing' or 'happy' songs",
    "Listen to a podcast or audiobook",
    "Wrap yourself in a cozy blanket",
    "Try progressive muscle relaxation",
    "Think of three things that went okay today",
    "Smile on purpose, just because",
    "Set a tiny goal for the next hour",
    "Do a quick body scan meditation",
    "Use a coloring book or app",
    "Watch an episode of a favorite show",
    "Repeat a positive affirmation to yourself",
    "Hold a smooth stone or fidget toy",
    "Ask yourself, 'What do I need right now?', and do it",
    "Say no to a stressor, out loud, in writing, or in your head",
    "Organize a small space, like a drawer, desk, bag, or shelf",
    "Try a graditude photo challenge",
    "Watch clouds, birds, or trees from a window",
    "Try silent sitting or listening for a few minutes",
    "Read a comforting quote or verse",
    "Light a flameless candle or turn on soft light",
    "Keep a comfort box with items that help you feel better nearby",
    "Write down one hope for the future",
    "Play with a sensory item like playdough, fabric, or beads",
    "Massage a part of your body slowly and gently; this can be your hands, feet, scalp, neck, or another body part."
        "Give someone a positive message or compliment, in writing or in person",
    "Try a short YouTube meditation or mindfulness video",
    "Name five things you can see, hear, and feel right now",
    "Put on something that makes you feel good, whether it's a full outfit or just a pair of socks",
    "Give yourself permission to rest, even if it's just for a few minutes",
    "Say or write: 'I am doing my best, and that is enough'",
  ];

  var pickedTasks = [];

  String currentTask = "";

  var doneTasks = [];

  int kittyInUse = 0;

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
    "Black Collared Kitty",
    "Calico Collared Kitty",
    "Siamese Collared Kitty",
    "White Collared Kitty",
    "Black Hat Kitty",
    "Calico Hat Kitty",
    "Siamese Hat Kitty",
    "White Hat Kitty",
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
    loadData().then((_) {
      setState(() {
        updateCatImages();
        isLoading = false;
      });
    });

    catImages = List.generate(9, (index) => kittyImages[kittyInUse][index]);

    shopItems = List.generate(
      16,
      (index) => {
        'image': 'images/${kittyTypes[index]}/${kittyTypes[index]}UO.png',
        'name': kittyNames[index],
        'price': getPriceForIndex(index),
        'purchased': index < 4, // first 4 are unlocked by default
        'using': index == 0, // first one is in use by default
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

  List genTaskList() {
    final random = Random();
    List<String> shuffledTasks = List.from(tasks)..shuffle(random);

    for (int i = 0; i < 25 && i < shuffledTasks.length; i++) {
      pickedTasks.add(shuffledTasks[i]);
      doneTasks.add(false);
    }

    return pickedTasks;
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

    // Save ints
    prefs.setInt('kittyNumber', kittyNumber);
    prefs.setInt('heartNumber', heartNumber);
    prefs.setInt('textSize', textSize);
    prefs.setInt('kittyInUse', kittyInUse);
    prefs.setInt('selectedPattern', selectedPattern);

    // Save strings
    prefs.setString('boardItem', boardItem);

    // Save colors as ARGB integers
    prefs.setInt('backgroundColor', backgroundColor.value);
    prefs.setInt('foregroundColor', foregroundColor.value);

    // Save pickedTasks and doneTasks as JSON strings
    prefs.setString('pickedTasks', jsonEncode(pickedTasks));
    prefs.setString('doneTasks', jsonEncode(doneTasks));

    // Save shopItems as JSON string
    prefs.setString('shopItems', jsonEncode(shopItems));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    kittyNumber = prefs.getInt('kittyNumber') ?? 0;
    heartNumber = prefs.getInt('heartNumber') ?? 0;
    textSize = prefs.getInt('textSize') ?? 24;
    kittyInUse = prefs.getInt('kittyInUse') ?? 0;
    selectedPattern = prefs.getInt('selectedPattern') ?? 0;

    boardItem = prefs.getString('boardItem') ?? "BINGO";

    int? bgColorInt = prefs.getInt('backgroundColor');
    backgroundColor = bgColorInt != null
        ? Color(bgColorInt)
        : Color.fromARGB(255, 221, 255, 199);

    int? fgColorInt = prefs.getInt('foregroundColor');
    foregroundColor = fgColorInt != null
        ? Color(fgColorInt)
        : Color.fromARGB(255, 15, 115, 60);

    pickedTasks = jsonDecode(prefs.getString('pickedTasks') ?? '[]');
    doneTasks = jsonDecode(prefs.getString('doneTasks') ?? '[]');

    // Attempt to load shopItems from prefs
    var loadedShopItems = prefs.getString('shopItems');
    if (loadedShopItems != null && loadedShopItems.isNotEmpty) {
      shopItems = List<Map<String, dynamic>>.from(jsonDecode(loadedShopItems));
    } else {
      // Fallback: regenerate shopItems if none exist.
      shopItems = List.generate(
        16,
        (index) => {
          'image': 'images/${kittyTypes[index]}/${kittyTypes[index]}UO.png',
          'name': kittyNames[index],
          'price': getPriceForIndex(index),
          'purchased': index < 4, // first 4 are unlocked by default
          'using': index == 0, // first one is in use by default
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    pickedTasks = genTaskList();

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
                                return Image(
                                  image: AssetImage((catImages[kittyNumber])),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        for (
                                          int i = 0;
                                          i < doneTasks.length;
                                          i++
                                        ) {
                                          doneTasks[i] = false;
                                        }
                                        money = 0;
                                        shopItems = List.generate(
                                          16,
                                          (index) => {
                                            'image':
                                                'images/${kittyTypes[index]}/${kittyTypes[index]}UO.png',
                                            'name': kittyNames[index],
                                            'price': getPriceForIndex(index),
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
                      pickedTasks.clear();
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
                                                currentTask = pickedTasks[0];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 1) {
                                                currentTask = pickedTasks[1];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 2) {
                                                currentTask = pickedTasks[2];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 3) {
                                                currentTask = pickedTasks[3];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 0 && col == 4) {
                                                currentTask = pickedTasks[4];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 0) {
                                                currentTask = pickedTasks[5];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 1) {
                                                currentTask = pickedTasks[6];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 2) {
                                                currentTask = pickedTasks[7];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 3) {
                                                currentTask = pickedTasks[8];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 1 && col == 4) {
                                                currentTask = pickedTasks[9];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 0) {
                                                currentTask = pickedTasks[10];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 1) {
                                                currentTask = pickedTasks[11];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 2) {
                                                currentTask = pickedTasks[12];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 3) {
                                                currentTask = pickedTasks[13];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 2 && col == 4) {
                                                currentTask = pickedTasks[14];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 0) {
                                                currentTask = pickedTasks[15];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 1) {
                                                currentTask = pickedTasks[16];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 2) {
                                                currentTask = pickedTasks[17];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 3) {
                                                currentTask = pickedTasks[18];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 3 && col == 4) {
                                                currentTask = pickedTasks[19];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 0) {
                                                currentTask = pickedTasks[20];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 1) {
                                                currentTask = pickedTasks[21];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 2) {
                                                currentTask = pickedTasks[22];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 3) {
                                                currentTask = pickedTasks[23];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              } else if (row == 4 && col == 4) {
                                                currentTask = pickedTasks[24];
                                                setState(() {
                                                  kittyNumber = 0;
                                                  heartNumber = 0;
                                                  screenDisplayed = 3;
                                                });
                                              }
                                            });
                                          },
                                          child: Text(
                                            doneTasks[row * 5 + col]
                                                ? '✓'
                                                : 'X',
                                            style: TextStyle(
                                              fontSize: textSize.toDouble(),
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
                            child: Text(
                              currentTask,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: foregroundColor,
                                fontSize: textSize.toDouble(),
                              ),
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
                          kittyNumber = 0;
                          int taskIndex = pickedTasks.indexOf(currentTask);
                          if (taskIndex != -1) {
                            doneTasks[taskIndex] = true;
                          }
                          money += updatePatterns() * 10;
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
                          int taskIndex = pickedTasks.indexOf(currentTask);
                          if (taskIndex != -1) {
                            doneTasks[taskIndex] = false;
                          }
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
                            'Disclamer: This app was made by a student for a Girl Scouts Gold Award project and is not mediaclly approved. Do not use this app as a substitute for professional therapy or medical advice.\n\nHello!\n\nWelcome to Theragame, a game designed to help you come to enjoy therapy and spend time with your virtual kitty.\n\nYou can interact with your kitty, complete tasks, and even shop for new kitties with in game money earned from completting 5 tasks in a row much like a bingo board and then spend it in the shop screen.\n\nTo complette tasks, go to the board screen and click on the squares. You can mark tasks as done as you do them and go back to the board screen by either pressing the -Not Done- button or the back arrow at the top left.\n\nHave fun and enjoy your time with your kitty!\n\nCreated by: Raley Wilkin\n\nVersion: 1.0.0',
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
