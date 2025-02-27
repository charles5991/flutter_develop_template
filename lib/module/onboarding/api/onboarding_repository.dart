import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/repository/base_repository.dart';
import 'package:flutter_develop_template/module/onboarding/model/onboarding_m.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';

class OnboardingRepository extends BaseRepository {
  // This would typically fetch from an API, but for onboarding we'll create locally
  Future<PageViewModel> getOnboardingData({
    required PageViewModel pageViewModel,
  }) async {
    // Create sample onboarding steps
    final onboardingModel = OnboardingModel(
      steps: [
        OnboardingStep(
          title: 'Easy & Trusted',
          description: 'Expand your team and easy to earn',
          imagePath: 'assets/images/onboarding1.png',
        ),
        OnboardingStep(
          title: 'Saving Money',
          description: 'The bigger your team, the more commission you earn',
          imagePath: 'assets/images/onboarding2.png',
        ),
        OnboardingStep(
          title: 'Daily Task',
          description: 'Invite friends to complete daily order, you will get more rewards',
          imagePath: 'assets/images/onboarding3.png',
        ),
      ],
    );

    // Set the model in the ViewModel
    onboardingModel.vm = pageViewModel;
    pageViewModel.pageDataModel?.data = onboardingModel;
    pageViewModel.pageDataModel?.type = NotifierResultType.success;
    
    return pageViewModel;
  }
}