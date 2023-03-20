
class Constants {
   static var URL = "https://api.onceuponatrunk.com/";
   static var razorpay_key = 'rzp_live_uYJShTfS2m9kkP';


   static isDebugMode() {
    assert(() {
      URL = "https://api.onceuponatrunk.com/";//"http://stagealb-857340442.ap-south-1.elb.amazonaws.com/";
      razorpay_key = 'rzp_live_uYJShTfS2m9kkP';
      return true;
      //you can execute debug-specific codes here
    }());
  }



  static const USER = "user";

   static const DEEPLINK = "deepLink";

  static const SIGNUPACTIVITY = "signupactivity";

   static const APPTRACKINGSTATUS = "appTrackingStatus";

  
}