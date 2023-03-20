import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'package:ouat/utility/constants.dart';

class NetBankingModel {
  String? bankKey;
  String? bankName;
  String? bankLogoUrl;

  NetBankingModel({this.bankKey, this.bankName, this.bankLogoUrl});
}

class CardInfoModel {
  static String? cardNumber;
  static String? expiryMonth;
  static String? expiryYear;
  static String? cvv;
  static String? cardHolderName;
  static String? mobileNumber;
  static String? email;
  static late Razorpay _razorpay;


  CardInfoModel(){
    _razorpay = Razorpay();
    _razorpay.initilizeSDK("${Constants.razorpay_key}");
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }


  static Future<String> validateCardFields(String cardNo, String cardName, String cvvInput, String expiry) async{
    CardInfoModel();
    if (cardNo.isEmpty) {
      return 'Card Number Cannot be Empty';
    }
    if (cardNo.isNotEmpty) {
      String input = getCleanedNumber(cardNo);
      final isValidCard = await _razorpay.isValidCardNumber(input);
      if(!isValidCard){
        return 'Invalid Card Number';
      }
      cardNumber = input;
    }
    if (cardName.isEmpty) {
      return 'Please enter your Name';
    }
    if(!RegExp(r'[a-zA-Z]').hasMatch(cardName)){
      return 'Please enter Valid Name';
    }
    if (cvvInput == '') {
      return 'CVV Cannot be Empty';
    }
    if(cvvInput != ''){
      if (cvvInput.length < 3 || cvvInput.length > 4) {
        return "CVV is invalid";
      }
    }
    if ((expiry.isEmpty) ||
        (expiry.isEmpty)
    ) {
      return 'Expiry Month / Year Cannot be Empty';
    }
    if(expiry.isNotEmpty){
      int year;
      int month;

      if (expiry.contains(new RegExp(r'(\/)'))) {
        var split = expiry.split(new RegExp(r'(\/)'));
        // The value before the slash is the month while the value to right of
        // it is the year.
        month = int.parse(split[0]);
        year = int.parse(split[1]);

      } else { // Only the month was entered
        month = int.parse(expiry.substring(0, (expiry.length)));
        year = -1; // Lets use an invalid year intentionally
      }

      if ((month < 1) || (month > 12)) {
        // A valid month is between 1 (January) and 12 (December)
        return 'Expiry month is invalid';
      }

      var fourDigitsYear = convertYearTo4Digits(year);
      if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
        // We are assuming a valid year should be between 1 and 2099.
        // Note that, it's valid doesn't mean that it has not expired.
        return 'Expiry year is invalid';
      }

      if (!hasDateExpired(month, year)) {
        return "Card has expired";
      }
      expiryYear = year.toString();
      expiryMonth = month.toString();
    }
    return '';
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }


  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is less than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently, is greater than card's
    // year
    return fourDigitsYear < now.year;
  }
}

class WalletModel {
  String? walletName;

  WalletModel({this.walletName});
}