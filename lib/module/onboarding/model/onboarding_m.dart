import 'package:flutter_develop_template/common/mvvm/base_model.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

class OnboardingModel extends BaseModel {
  final List<OnboardingStep> steps;
  int currentStepIndex = 0;
  bool completed = false;

  OnboardingModel({
    required this.steps,
  });

  OnboardingStep get currentStep => steps[currentStepIndex];
  
  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == steps.length - 1;
  
  void nextStep() {
    if (!isLastStep) {
      currentStepIndex++;
    } else {
      completed = true;
    }
  }
  
  void previousStep() {
    if (!isFirstStep) {
      currentStepIndex--;
    }
  }
  
  @override
  void onDispose() {
    super.onDispose();
  }
}

class OnboardingStep {
  final String title;
  final String description;
  final String imagePath;

  OnboardingStep({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}