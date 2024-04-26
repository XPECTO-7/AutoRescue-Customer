
import 'package:autorescue_customer/Authentication/Controller/onboarding_info.dart';

class OnboardingData{

  List<OnboardingInfo> items = [
     OnboardingInfo(
        title: "AUTORESCUE",
        description: "USER",
        image: "lib/images/obsi2.png"),
    OnboardingInfo(
        title: "Stuck on Unknown Place because of your vehicle issues?",
        description: "Don't worry.. AutoRescue is here",
        image: "assets/City driver.gif"),

    OnboardingInfo(
        title: "Solve vehicle related problems.",
        description: "No more stuck in road sides.",
        image: "assets/Order ride.gif"),

    OnboardingInfo(
        title: "Services provided to your location",
        description: "AutoRescue provides services to your location.No need of worrying about anything.",
        image: "assets/Delivery.gif"),

  ];
 }