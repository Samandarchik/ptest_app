import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ptest/main/core/constants/urls.dart';
import 'package:ptest/user/models/quiz_model.dart';
import 'package:ptest/user/services/quiz_service.dart';

class QuizPage extends StatefulWidget {
  final String id;
  const QuizPage({super.key, required this.id});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<QuizModel>?> _topicsFuture;
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  int correctAnswers = 0;
  bool isAnswered = false;
  List<QuizModel> quizList = [];
  bool showQuestionList = true;
  List<QuestionState> questionStates = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _topicsFuture = QuizService().getQuiz(widget.id);

    // 2 soniyadan keyin quiz sahifasiga o'tish
    if (mounted) {
      setState(() {
        showQuestionList = false;
      });
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _selectAnswer(String key, bool isCorrect) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = key;
      isAnswered = true;
      if (isCorrect) {
        correctAnswers++;
      }

      // Savol holatini yangilash
      questionStates[currentQuestionIndex] = QuestionState(
        isAnswered: true,
        isCorrect: isCorrect,
        selectedKey: key,
      );
    });

    // 2 soniyadan keyin avtomatik keyingi savolga o'tish
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      final state = questionStates[index];
      selectedAnswer = state.selectedKey;
      isAnswered = state.isAnswered;
    });
    _focusNode.requestFocus();
  }

  void _nextQuestion() {
    if (currentQuestionIndex < quizList.length - 1) {
      setState(() {
        currentQuestionIndex++;
        final state = questionStates[currentQuestionIndex];
        selectedAnswer = state.selectedKey;
        isAnswered = state.isAnswered;
      });
      _focusNode.requestFocus();
    } else {
      _showResults();
    }
  }

  // Klaviatura bilan javob tanlash
  void _handleKeyPress(String key) {
    if (isAnswered) return;

    final number = int.tryParse(key);
    if (number == null) return;

    final options = quizList[currentQuestionIndex].options;
    if (number > 0 && number <= options.length) {
      final option = options[number - 1];
      _selectAnswer(option.key, option.isAnswer);
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🎉 Test yakunlandi!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$correctAnswers / ${quizList.length}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: correctAnswers >= quizList.length * 0.7
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'To\'g\'ri javoblar: $correctAnswers',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Noto\'g\'ri javoblar: ${quizList.length - correctAnswers}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              _getResultMessage(),
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Bosh sahifaga qaytish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                selectedAnswer = null;
                correctAnswers = 0;
                isAnswered = false;
                questionStates = List.generate(
                  quizList.length,
                  (index) => QuestionState(),
                );
              });
              _focusNode.requestFocus();
            },
            child: const Text('Qayta boshlash'),
          ),
        ],
      ),
    );
  }

  String _getResultMessage() {
    final percentage = (correctAnswers / quizList.length) * 100;
    if (percentage >= 90) return 'A\'lo! Siz zo\'rsiz! 🌟';
    if (percentage >= 70) return 'Yaxshi natija! 👍';
    if (percentage >= 50) return 'Yomon emas, lekin ko\'proq mashq qiling 💪';
    return 'Qoidalarni qayta o\'rganishingiz kerak 📚';
  }

  Widget _buildQuestionList(List<QuizModel> quiz) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[700]!, Colors.blue[900]!],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Test sinovlari',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Jami ${quiz.length} ta savol',
                style: const TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Iltimos kuting...',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Test sinovlari"),
        elevation: 0,
        backgroundColor: Colors.blue[700],
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final key = event.logicalKey.keyLabel;
            _handleKeyPress(key);
          }
        },
        child: FutureBuilder<List<QuizModel>?>(
          future: _topicsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      "Ma'lumotlarni yuklab bo'lmadi",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Savollar mavjud emas",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (quizList.isEmpty) {
              quizList = snapshot.data!;
              questionStates = List.generate(
                quizList.length,
                (index) => QuestionState(),
              );
            }

            // Savollar ro'yxatini 2 soniya ko'rsatish
            if (showQuestionList) {
              return _buildQuestionList(quizList);
            }

            final currentQuiz = quizList[currentQuestionIndex];

            return Row(
              children: [
                // Main content
                Expanded(
                  child: Column(
                    children: [
                      // Progress indicator
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Savol ${currentQuestionIndex + 1}/${quizList.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'To\'g\'ri: $correctAnswers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value:
                                    (currentQuestionIndex + 1) /
                                    quizList.length,
                                minHeight: 10,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[700]!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Question and options
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 900),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Question card
                                  Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentQuiz.question["uz"] ?? "",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                          ),
                                          if (currentQuiz
                                              .imgUrl
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 20),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                "${AppUrls.baseUrl}${currentQuiz.imgUrl}",
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                        color: Colors.grey[200],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              'Rasmni yuklab bo\'lmadi',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // Options
                                  ...currentQuiz.options.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final option = entry.value;
                                    final optionNumber = index + 1;
                                    final isSelected =
                                        selectedAnswer == option.key;
                                    final isCorrect = option.isAnswer;

                                    Color? cardColor;
                                    Color? borderColor;
                                    IconData? icon;

                                    if (isAnswered) {
                                      if (isCorrect) {
                                        cardColor = Colors.green[50];
                                        borderColor = Colors.green[700];
                                        icon = Icons.check_circle;
                                      } else if (isSelected && !isCorrect) {
                                        cardColor = Colors.red[50];
                                        borderColor = Colors.red[700];
                                        icon = Icons.cancel;
                                      }
                                    } else if (isSelected) {
                                      cardColor = Colors.blue[50];
                                      borderColor = Colors.blue[700];
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: InkWell(
                                        onTap: () => _selectAnswer(
                                          option.key,
                                          isCorrect,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: cardColor ?? Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color:
                                                  borderColor ??
                                                  Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(18),
                                          child: Row(
                                            children: [
                                              // Raqam ko'rsatish
                                              Container(
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color:
                                                      borderColor ??
                                                      Colors.grey[300],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '$optionNumber',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (cardColor != null)
                                                          ? Colors.white
                                                          : Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 18),

                                              Expanded(
                                                child: Text(
                                                  option.text["uz"] ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),

                                              if (icon != null)
                                                Icon(
                                                  icon,
                                                  color: borderColor,
                                                  size: 30,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom navigation bar
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(-2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: Colors.blue[700]),
                        child: const Center(
                          child: Icon(
                            Icons.grid_view,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: quizList.length,
                          itemBuilder: (context, index) {
                            final state = questionStates[index];
                            final isCurrent = index == currentQuestionIndex;

                            Color bgColor;
                            Color textColor;

                            if (isCurrent) {
                              bgColor = Colors.blue[700]!;
                              textColor = Colors.white;
                            } else if (state.isAnswered) {
                              if (state.isCorrect) {
                                bgColor = Colors.green[100]!;
                                textColor = Colors.green[900]!;
                              } else {
                                bgColor = Colors.red[100]!;
                                textColor = Colors.red[900]!;
                              }
                            } else {
                              bgColor = Colors.grey[200]!;
                              textColor = Colors.grey[700]!;
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: InkWell(
                                onTap: () => _goToQuestion(index),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: isCurrent
                                        ? Border.all(
                                            color: Colors.blue[900]!,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QuestionState {
  final bool isAnswered;
  final bool isCorrect;
  final String? selectedKey;

  QuestionState({
    this.isAnswered = false,
    this.isCorrect = false,
    this.selectedKey,
  });
}
