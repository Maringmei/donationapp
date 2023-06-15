import 'package:flutter/material.dart';

import 'color_constant.dart';




const i_user = Icon(Icons.account_circle);
const i_lock = Icon(Icons.lock_outline);
const i_notification = Icon(Icons.notifications);
const i_menu = Icon(Icons.segment,color: c_white,);
const i_back = Icon(Icons.arrow_back_ios,size: 15,);
const i_test = Icon(Icons.radar_outlined);
const i_filter = Icon(Icons.filter_alt_outlined,size: 9,);

const i_home = Icon(Icons.home_outlined,color: c_black_opa,);
const i_leave = Icon(Icons.person_add_disabled_outlined,color: c_black_opa,);
const i_request = Icon(Icons.help_outline,color: c_black_opa,);
const i_approve = Icon(Icons.approval,color: c_black_opa,);
const i_history = Icon(Icons.history,color: c_black_opa,);
const i_policy = Icon(Icons.feed_outlined,color: c_black_opa,);
const i_encash = Icon(Icons.currency_exchange_outlined,color: c_black_opa,);
const i_leaderboard = Icon(Icons.leaderboard_outlined,color: c_black_opa,);
const i_logout = Icon(Icons.logout_outlined,color: c_red,);
const i_info =  Icon(Icons.info_outline,size: 15,);
const i_download =  Icon(Icons.download_for_offline,size: 15,);
const i_view =  Icon(Icons.picture_as_pdf,size: 15,);

const i_half = Icon(Icons.star_half,color: c_red,);
const i_full = Icon(Icons.star,color: c_red,);

final i_first = Icon(Icons.sunny,color: Colors.orange.withOpacity(0.5),);
const i_second = Icon(Icons.sunny,color: Colors.orange,);

List<Icon> applyLeaveOption = [
  i_full,
  i_half,
] ;

List<Icon> applyShiftOption = [
  i_first,
  i_second,
] ;
