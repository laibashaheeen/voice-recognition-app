import 'package:ai_app/components/feature_container.dart';
import 'package:ai_app/data/app_assets.dart';
import 'package:ai_app/data/app_colors.dart';
import 'package:ai_app/data/typography.dart';
import 'package:ai_app/openai_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 800;
  int delay = 800;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    bool available = await speechToText.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (errorNotification) => print('Error: $errorNotification'),
    );
    if (!available) {
      print('Speech recognition is not available on this device');
    } else {
      setState(() {});
    }
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> startListening() async {
    if (!speechToText.isAvailable) {
      print('Speech recognition not available');
      return;
    }
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  // Future<void> systemSpeak(String content) async {
  //   await flutterTts.speak(content);
  // }
  Future<void> systemSpeak(String content) async {
    print('systemSpeak: Attempting to speak: "$content"');
    try {
      await flutterTts.speak(content);
      print('systemSpeak: Speech request sent successfully');
    } catch (e) {
      print('systemSpeak: Error occurred while trying to speak: $e');
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print('Recognized words: $lastWords');
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          centerTitle: true,
          title: const Text('Allen'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 35.0.w, right: 35.w, top: 10.h, bottom: 20.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: ZoomIn(
                duration: Duration(milliseconds: start),
                child: CircleAvatar(
                    radius: 55.r,
                    backgroundColor: AppColors.assistantCircleColor,
                    backgroundImage: AssetImage(AppAssets.kProfile)),
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.topRight,
              child: FadeInLeft(
                duration: Duration(microseconds: start + 2 * delay),
                child: Visibility(
                  visible: lastWords.isNotEmpty || speechToText.isListening,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20.w, top: 15.h, bottom: 20.h, right: 20.w),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.firstSuggestionBoxColor,
                            width: 1.w),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            bottomLeft: Radius.circular(15.r),
                            bottomRight: Radius.circular(15.r))),
                    child: Text(lastWords,
                        style: AppTypography.kWelcome.copyWith(
                          color: AppColors.mainFontColor,
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            if (!speechToText.isListening) ...[
              FadeInRight(
                duration: Duration(microseconds: start + 2 * delay),
                child: Visibility(
                  visible: generatedImageUrl == null,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20.w, top: 15.h, bottom: 20.h, right: 20.w),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.thirdSuggestionBoxColor,
                            width: 1.w),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.r),
                            bottomLeft: Radius.circular(15.r),
                            bottomRight: Radius.circular(15.r))),
                    child: Text(
                        generatedContent == null
                            ? 'Good Morning, what task can I do for \nyou?'
                            : generatedContent!,
                        style: AppTypography.kWelcome.copyWith(
                          color: AppColors.mainFontColor,
                          fontSize: generatedContent == null ? 25 : 18,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // if (generatedImageUrl != null)
              //   ClipRRect(
              //       borderRadius: BorderRadius.circular(20.r),
              //       child: Image.network(generatedImageUrl!)),
              if (generatedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      generatedImageUrl!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Error loading image');
                      },
                    ),
                  ),
                ),
              Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Text('Here are a few features',
                    style: AppTypography.kFeature.copyWith(
                      color: AppColors.mainFontColor,
                    )),
              ),
              SizedBox(height: 20.h),
              Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Column(
                  children: [
                    FadeInLeft(
                      duration: Duration(milliseconds: start),
                      child: const FeatureContainer(
                        color: AppColors.firstSuggestionBoxColor,
                        title: 'ChatGPT',
                        description:
                            'A smarter way to stay organized and informed with ChatGPT',
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInLeft(
                      duration: Duration(milliseconds: start + delay),
                      child: const FeatureContainer(
                        color: AppColors.secondSuggestionBoxColor,
                        title: 'Dall-E',
                        description:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E',
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInLeft(
                      duration: Duration(milliseconds: start + 2 * delay),
                      child: const FeatureContainer(
                        color: AppColors.thirdSuggestionBoxColor,
                        title: 'Smart Voice Assistant',
                        description:
                            'A smarter way to stay organized and informed with ChatGPT',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ]),
        ),
        floatingActionButton: FadeInUp(
          child: FloatingActionButton(
            onPressed: () async {
              if (await speechToText.hasPermission &&
                  speechToText.isNotListening) {
                await startListening();
              } else if (speechToText.isListening) {
                await openAIService.isArtPromptAPI(lastWords);
                final speech = await openAIService.isArtPromptAPI(lastWords);
                if (speech.contains('https')) {
                  generatedImageUrl = speech;
                  generatedContent = null;
                  setState(() {});
                } else {
                  generatedImageUrl = null;
                  generatedContent = speech;
                  setState(() {});
                  await systemSpeak(speech);
                }

                await stopListening();
              } else {
                initSpeechToText();
              }
            },
            backgroundColor: AppColors.firstSuggestionBoxColor,
            child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
          ),
        ));
  }
}
