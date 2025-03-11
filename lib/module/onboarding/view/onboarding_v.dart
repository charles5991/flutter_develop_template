import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/onboarding/model/onboarding_m.dart';
import 'package:flutter_develop_template/module/onboarding/view_model/onboarding_vm.dart';
import 'package:flutter_develop_template/router/navigator_util.dart';
import 'package:flutter_develop_template/router/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_develop_template/module/auth/service/auth_service.dart';

class OnboardingView extends BaseStatefulPage<OnboardingViewModel> {
  OnboardingView({super.key});

  @override
  OnboardingViewState createState() => OnboardingViewState();
}

class OnboardingViewState extends BaseStatefulPageState<OnboardingView, OnboardingViewModel> {
  @override
  OnboardingViewModel viewBindingViewModel() {
    return OnboardingViewModel()..viewState = this;
  }

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      body: NotifierPageWidget(
        model: viewModel?.pageDataModel,
        builder: (context, model) {
          if (model.type == NotifierResultType.loading) {
            return Center(child: CircularProgressIndicator());
          }
          
          OnboardingModel? onboardingModel = model.data as OnboardingModel?;
          
          if (onboardingModel == null) {
            return Center(child: Text('Failed to load onboarding data'));
          }
          
          // If onboarding is completed, navigate to home
          if (onboardingModel.completed) {
            // Use a post-frame callback to avoid build during build issues
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigatorUtil.push(context, Routers.root, clearStack: true);
            });
            return Container(); // Return empty container while navigating
          }
          
          return Stack(
            children: [
              // PageView for the steps
              PageView.builder(
                controller: viewModel!.pageController,
                itemCount: onboardingModel.steps.length,
                onPageChanged: viewModel!.onPageChanged,
                itemBuilder: (context, index) {
                  final step = onboardingModel.steps[index];
                  return _buildOnboardingStep(step);
                },
              ),
              
              // Skip button
              Positioned(
                top: 50,
                right: 20,
                child: TextButton(
                  onPressed: viewModel!.skipOnboarding,
                  child: Text('Skip', style: TextStyle(fontSize: 16)),
                ),
              ),
              
              // Navigation buttons
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: _buildNavigationButtons(onboardingModel),
              ),
              
              // Indicator dots
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: _buildIndicatorDots(onboardingModel),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildOnboardingStep(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Replace the placeholder with actual Image.asset
          Image.asset(
            step.imagePath,
            height: 200,
            width: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Image not found', style: TextStyle(color: Colors.grey)),
                      Text(step.imagePath, style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 40),
          Text(
            step.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            step.description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationButtons(OnboardingModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (hidden on first step)
          Visibility(
            visible: !model.isFirstStep,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: ElevatedButton(
              onPressed: viewModel!.previousStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Back'),
            ),
          ),
          
          // Next/Get Started button
          ElevatedButton(
            onPressed: () {
              if (model.isLastStep) {
                // If it's the last step, complete onboarding and go to home
                AuthService.markOnboardingComplete();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routers.root,
                  (route) => false,
                );
              } else {
                // If not the last step, go to next step
                viewModel!.nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(model.isLastStep ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIndicatorDots(OnboardingModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        model.steps.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == model.currentStepIndex
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}