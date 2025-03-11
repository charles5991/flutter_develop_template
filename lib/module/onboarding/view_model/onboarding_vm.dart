import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/onboarding/api/onboarding_repository.dart';
import 'package:flutter_develop_template/module/onboarding/model/onboarding_m.dart';
import 'package:flutter_develop_template/module/onboarding/view/onboarding_v.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_develop_template/router/navigator_util.dart';
import 'package:flutter_develop_template/router/routers.dart';

class OnboardingViewModel extends PageViewModel<OnboardingViewState> {
  final PageController pageController = PageController();
  
  @override
  void onCreate() {
    pageDataModel = PageDataModel();
    requestData();
  }
  
  @override
  void onDispose() {
    pageController.dispose();
    super.onDispose();
  }
  
  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) async {
    PageViewModel viewModel = await OnboardingRepository().getOnboardingData(
      pageViewModel: this,
    );
    
    pageDataModel = viewModel.pageDataModel;
    pageDataModel?.refreshState();
    return Future<PageViewModel>.value(viewModel);
  }
  
  void nextStep() {
    if (pageController != null && 
        pageDataModel?.data != null &&
        (pageDataModel!.data as OnboardingModel).currentStepIndex < 
        (pageDataModel!.data as OnboardingModel).steps.length - 1) {
      pageController!.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void previousStep() {
    OnboardingModel? model = pageDataModel?.data as OnboardingModel?;
    if (model != null && !model.isFirstStep) {
      model.previousStep();
      pageController.animateToPage(
        model.currentStepIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      pageDataModel?.refreshState();
    }
  }
  
  void skipOnboarding() {
    OnboardingModel? model = pageDataModel?.data as OnboardingModel?;
    if (model != null) {
      model.completed = true;
      pageDataModel?.refreshState();
    }
  }
  
  void onPageChanged(int page) {
    OnboardingModel? model = pageDataModel?.data as OnboardingModel?;
    if (model != null && model.currentStepIndex != page) {
      model.currentStepIndex = page;
      pageDataModel?.refreshState();
    }
  }
  
  Future<void> setOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
  }
  
  void completeOnboarding() async {
    await setOnboardingComplete();
    NavigatorUtil.push(state.context, Routers.root, clearStack: true);
  }
}