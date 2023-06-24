import '../../env/env.dart';


abstract class ApiURL {

  //Set Live or Staging
  static const urlLive = "https://app.mateng.globizsapp.com";
  static const urlStaging = "https://app.mateng.globizsapp.com";

  static const baseUrl = isStaging ? urlStaging : urlLive;

  static const loginUrl = "/api/sites/login";
  static const createUserUrl = "/api/sites/signup";
  static const payUrl = "/api/payments/pay?amount=";
  static const confirmUrl = "/api/payments/confirm";
  static const dashboardUrl = "/api/sites/dashboard";
  static const benificiariesListUrl = "/api/payments/details?payment_id=";
  static const historyUrl = "/api/payments/history";



  static const seeMoreUrl = "/api/beneficiaries/getbeneficiary";
  static const beneficiariesUrl = "/api/beneficiaries?";
  static const beneUpdateUrl = "/api/beneficiaries/";
  static const profileUrl = "/api/sites/profile";
  static const updateprofileUrl = "/api/sites/updateprofile";
  static const reliefcampListUrl = "/api/beneficiaries/reliefcamp";

  static const testUrl = "https://reliefcamp.globizsapp.com/api/webhooks/ivr";






}