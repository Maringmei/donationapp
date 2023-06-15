import '../../env/env.dart';


abstract class ApiURL {

  //Set Live or Staging
  static const urlLive = "https://app.tengbang.globizsapp.com";
  static const urlStaging = "https://app.tengbang.globizsapp.com";

  static const baseUrl = isStaging ? urlStaging : urlLive;

  static const loginUrl = "/api/sites/login";
  static const createUserUrl = "/api/sites/signup";
  static const payUrl = "/api/payments/pay?amount=";
  static const confirmUrl = "/api/payments/confirm";
  static const dashboardUrl = "/api/sites/dashboard";
  static const benificiariesListUrl = "/api/payments/details?payment_id=";
  static const historyUrl = "/api/payments/history";

}