import 'dart:io';

import 'package:Allen/Views/HomePage/components/feature_container.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:Allen/openai_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isListening = false;
  TextEditingController textEditingController = TextEditingController();
  String _submittedValue = '';
  bool isSpeaking = false;
  // bool _isPaused = false;
  
  bool isGeneratingContent = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    textEditingController = TextEditingController();
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

  Future<void> systemSpeak(String content) async {
    print('systemSpeak: Attempting to speak: "$content"');
    try {
      if (!isSpeaking) {
        await flutterTts.speak(content);
        print('systemSpeak: Speech request sent successfully');
      } else {
        // await flutterTts.stop();
        setState(() => isSpeaking = false);
        await flutterTts.stop();
        print('systemSpeak: Speech request terminated successfully');
        // setState(() => isSpeaking = false);
      }
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

  void toggleListening() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (errorNotification) => print('Error: $errorNotification'),
      );
      if (available) {
        setState(() {
          isListening = true;
          
          // _isPaused = false;
          textEditingController.clear(); // Clear the text field
        });
        speechToText.listen(
          onResult: (result) {
            setState(() {
              textEditingController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => isListening = false);
      speechToText.stop();
    }
  }

  void callApiFunction(String text) async {
    // Stop listening if still active
    if (isListening) {
      setState(() => isListening = false);

      speechToText.stop();
    }

    // Call your API here
    final speech = await openAIService.isArtPromptAPI(text);
    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      // await systemSpeak(speech);
    }
    setState(() {
      isGeneratingContent = false;
    });
  }


 Future<void> saveImage({required BuildContext context,required String image}) async {
    String? message;
    // final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(image));
      // Get temporary directory
      final dir = await getTemporaryDirectory();
      // Create an image name
      var time = DateTime.now().millisecondsSinceEpoch;
      var filename = '${dir.path}/image-$time.png';
      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
      // // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      await FlutterFileDialog.saveFile(params: params);
      ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    'Image downloaded successfully!',
                                    style: AppTypography.kDescription.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.mainFontColor),
                                  ),
                                  backgroundColor: AppColors.borderColor),
                            );
    } catch (e) {
      message = "$e";
      print("$e");
    }
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    "OOPS, try again",
                                    style: AppTypography.kDescription.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.mainFontColor),
                                  ),
                                  backgroundColor: AppColors.borderColor),
                            );
    }
  }


  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    textEditingController.dispose();
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
        padding:
            EdgeInsets.only(left: 35.0.w, right: 35.w, top: 10.h, bottom: 20.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          // Question Box
          Align(
            alignment: Alignment.topRight,
            child: FadeInLeft(
              duration: Duration(microseconds: start + 2 * delay),
              child: Visibility(
                visible: _submittedValue.isNotEmpty && !isListening,
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20.w, top: 15.h, bottom: 20.h, right: 20.w),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.firstSuggestionBoxColor, width: 1.w),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r))),
                  child: Text(_submittedValue,
                      style: AppTypography.kWelcome.copyWith(
                        color: AppColors.mainFontColor,
                        fontSize: 18,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          if (!isListening) ...[
            // Greeting and Answer Box
      
            Column(
              children: [
                FadeInRight(
                  duration: Duration(microseconds: start + 2 * delay),
                  child: Visibility(
                    visible: generatedImageUrl == null,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.w, top: 15.h, bottom: 20.h, right: 20.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.thirdSuggestionBoxColor, width: 1.w),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.r),
                              bottomLeft: Radius.circular(15.r),
                              bottomRight: Radius.circular(15.r))
                              ),
                      child: isGeneratingContent
                          ? Padding(
                              padding: EdgeInsets.all(90.0.h),
                              child: const LoadingIndicator(
                                indicatorType: Indicator.ballSpinFadeLoader,
                                colors: [
                                  AppColors.firstSuggestionBoxColor,
                                  AppColors.mainFontColor,
                                  AppColors.thirdSuggestionBoxColor,
                                  AppColors.secondSuggestionBoxColor
                                ],
                
                              
                                strokeWidth: 5,
                              ),
                            )
                          : Text(
                              generatedContent == null
                                  ? 'Good Morning, what task can I do for \nyou?'
                                  : generatedContent!,
                              style: AppTypography.kWelcome.copyWith(
                                color: AppColors.mainFontColor,
                                fontSize: generatedContent == null ? 25 : 18,
                              ),
                            ),
                    ),
                  ),
                ),
                
                if(generatedContent != null && !isGeneratingContent)
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isSpeaking
                          ? Icons.stop_circle_outlined
                          : Icons.volume_up_outlined,
                      color: AppColors.mainFontColor,
                      size: 20,
                    ),
                    onPressed: () async {
                      if (!isSpeaking) {
                        await flutterTts.speak(generatedContent!);
                        
      
                        setState(() {
                          isSpeaking = true;
                        });
                      } else {
                        await flutterTts.stop();
                        
                        setState(() {
                          isSpeaking = false;
                        });
                      }
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.copy,
                      color: AppColors.mainFontColor,
                      size: 20,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: generatedContent!))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                'Copied to your clipboard!',
                                style: AppTypography.kDescription.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.mainFontColor),
                              ),
                              backgroundColor: AppColors.borderColor),
                        );
                      });
                    },
                  ),
                ],
              ),
              ],
            ),
            
      
            
            //Generated image box
            if (generatedImageUrl != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.h),
                child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(15.r),),
                  child: Stack(children: [
                    Image.network(
                      generatedImageUrl!,
                      
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: Padding(
                          padding: EdgeInsets.all(90.0.h),
                          child: const LoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader,
                            colors: [
                              AppColors.firstSuggestionBoxColor,
                              AppColors.mainFontColor,
                              AppColors.thirdSuggestionBoxColor,
                              AppColors.secondSuggestionBoxColor
                            ],
                            strokeWidth: 5,
                          ),
                        ));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Error loading image');
                      },
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          
                          child: Container(
                            padding: EdgeInsets.all(4.h),
                            decoration: BoxDecoration(
                              color: AppColors.borderColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.file_download_outlined,
                                color: AppColors.mainFontColor),
                          ),
                          onTap: () async {
                             await saveImage(context: context, image: generatedImageUrl!);
                          },
                        ),
                      ),
                    
                  ]),
                ),
              ),
              SizedBox(height: 20.h,),
            //Message
            Visibility(
              visible: generatedContent == null &&
                  generatedImageUrl == null &&
                  isGeneratingContent == false,
              child: Text('Here are a few features',
                  style: AppTypography.kFeature.copyWith(
                    color: AppColors.mainFontColor,
                  )),
            ),
            SizedBox(height: 20.h),
            Visibility(
              visible: generatedContent == null &&
                  generatedImageUrl == null &&
                  isGeneratingContent == false,
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
      bottomSheet: Visibility(
        visible: isListening == true,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: const BoxDecoration(color: AppColors.whiteColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textEditingController,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Edit recognized text...',
                  hintStyle: AppTypography.kDescription
                      .copyWith(fontSize: 14.sp, color: AppColors.borderColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.mainFontColor,
                    ),
                    onPressed: () async {
                     
                      await speechToText.cancel();

                      
                      _submittedValue = '';
                      isListening = false;
                      
                      setState(() {});
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(
                  //     _isPaused ? Icons.stop : Icons.pause,
                  //     color: AppColors.redColor,
                  //   ),
                  //   onPressed: () async {
                  //     // _isPaused = false;
                  //     if (_isPaused) {
                  //       // Resume listening

                  //       await speechToText.listen(
                  //         onResult: (result) {
                  //           // Handle the speech recognition result

                  //           textEditingController.text =
                  //               "${textEditingController.text} + ${result.recognizedWords}";
                  //           print(textEditingController.text);
                  //         },
                  //       );
                  //       _isPaused = false;
                  //     } else {
                  //       // Pause listening
                  //       await speechToText.cancel();
                  //       _isPaused = true;
                  //     }
                  //     // setState(() {});
                  //   },
                  // ),
                  IconButton(
                    icon: Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: const BoxDecoration(
                            color: AppColors.firstSuggestionBoxColor,
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.send,
                          color: AppColors.mainFontColor,
                        )),
                    onPressed: () {
                      _submittedValue = textEditingController.text;
                      if (_submittedValue.isEmpty) {
                        print("Please provide a prompt");
                        isListening = false;
                      } else {
                        setState(() {
                          isGeneratingContent = true;
                        });
                        callApiFunction(_submittedValue);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !isListening,
        child: FloatingActionButton(
          onPressed: toggleListening,
          backgroundColor: AppColors.firstSuggestionBoxColor,
          child: const Icon(Icons.mic),
        ),
      ),
    );
  }
}
