import 'package:intl/intl.dart';

final indianRupeesFormat = NumberFormat.currency(
  name: "INR",
  locale: 'en_IN',
  decimalDigits: 0, // change it to get decimal places
  symbol: '₹ ',
);