import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:get/get.dart';

class UtilsWidgets {
  static AppBar buildAppBar(
    String title, {
    Widget? icon,
    bool isrequired = false,
    String? btnName,
    Function()? onChange,
  }) {
    return AppBar(
        leading: icon,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        // automaticallyImplyLeading: false,
        title: Text(
          title,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          isrequired
              ? TextButton(
                  onPressed: onChange,
                  child: Text('$btnName',
                      style: TextStyle(
                        color: Colors.white,
                      )))
              : SizedBox()
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Color.fromARGB(255, 17, 11, 68)),
        ));
  }

  static Widget searchAbleDropDown(
      List<dynamic> _dropdownItems,
      String? holder,
      String labelText,
      String? SelectedItem,
      Widget? icon,
      ValueChanged? onChange,
      String? DropdownPopUpText,
      Color? color,
      String? searchFieldPropsLabelText,
      FormFieldValidator? validator,
      {bool showSearchBox = true,
      FocusNode? focusNode,
      bool showClearButton = true,
      bool autoFocus = false,
      Key? key}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        width: kIsWeb ? 600 : null,
        child: DropdownSearch(
          key: key,
          focusNode: focusNode,
          showClearButton: showClearButton,
          mode: Mode.BOTTOM_SHEET,
          items: _dropdownItems,
          dropdownSearchDecoration: InputDecoration(
            icon: icon,
            labelText: labelText,
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          validator: validator,
          onChanged: onChange,
          selectedItem: SelectedItem,
          showSearchBox: showSearchBox,
          searchFieldProps: TextFieldProps(
            autofocus: autoFocus,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: searchFieldPropsLabelText,
            ),
          ),
          popupTitle: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                '$DropdownPopUpText',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          popupShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildSqureBtn(String? btnName, Function()? onpress) {
    return Center(
      child: ElevatedButton(
        onPressed: onpress,
        child: Text('$btnName'),
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          onSurface: Colors.black,
        ),
      ),
    );
  }

  static Widget buildRoundBtn(String? btnsend, Function()? onPressed) {
    return SizedBox(
      height: 50,
      width: 180,
      child: ElevatedButton(
          child: Text("$btnsend"),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: Colors.teal),
            ),
            primary: Colors.teal,
          ),
          onPressed: onPressed),
    );
  }

  static Widget textFormField(String? labelText, String hintText,
      String? Function(String?)? validator, TextEditingController? controller,
      {bool isReadOnly = false,
      TextInputType textInputType = TextInputType.text,
      bool obscure = false,
      int maxLine = 1,
      Widget? icon,
      Widget? suffixIcon,
      Widget? prefixIcon,
      Key? key,
      String? Function(String)? onChanged,
      List<TextInputFormatter>? inputFormatter,
      TextInputAction textInputAction = TextInputAction.next}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Container(
        child: TextFormField(
          onChanged: onChanged,
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              letterSpacing: 1),
          key: key,
          textInputAction: textInputAction,
          autofocus: false,
          keyboardType: textInputType,
          inputFormatters: inputFormatter,
          controller: controller,
          validator: validator,
          obscureText: obscure,
          maxLines: maxLine,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.black, width: 0.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            icon: icon,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    );
  }

  static Widget dropDownButton(
      String? hint,
      String? label,
      String _dropDownValue,
      List<dynamic> dropDownItem,
      Function(dynamic)? onChange,
      {String? Function(String?)? validator,
      String? holder,
      Widget? widget}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        children: [
          widget ?? Text(""),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    label: Text("$label")),
                value: holder,
                focusColor: Colors.transparent,
                isExpanded: true,
                hint: Text(
                  '$hint',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                items: dropDownItem
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ))
                    .toList(),
                validator: validator,
                onChanged: onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDatePicker(
    String dateLabelText,
    String hintText,
    TextEditingController editingController,
    Function(String)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: DateTimePicker(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(width: 2.0),
            ),
            icon: Icon(Icons.calendar_today),
            hintText: hintText,
            labelText: dateLabelText,
            labelStyle: TextStyle(color: Colors.grey)),
        type: DateTimePickerType.date,
        dateMask: 'd MMM, yyyy',
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        controller: editingController,
        onChanged: onChanged,
        validator: (val) {
          if (val!.isEmpty) {
            return "Please Choose Webinar Date";
          }
        },
      ),
    );
  }

  static ToggleButtons buildToggelButton(
      List<bool> isSelected, Function(int)? onPressed) {
    return ToggleButtons(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor:
          isSelected[0] ? Colors.greenAccent : Colors.redAccent,
      selectedColor: Colors.black,
      fillColor: isSelected[0] ? Colors.green : Colors.red,
      color: Colors.black,
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      children: [Text('Yes'), Text('No')],
      isSelected: isSelected,
      onPressed: onPressed,
    );
  }

  static showAlertDialog(BuildContext context, Function()? okPressed,
      String? title, String? content1,
      {String? note}) {
    Widget okButton = TextButton(
      child: Text('Ok'),
      onPressed: okPressed,
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text("$content1"),
            Text(
              "$note",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static addField(BuildContext context, Function()? okPressed, String? title,
      GlobalKey key, TextEditingController answer,
      {TextEditingController? options, bool isRequired = true}) {
    Widget okButton = TextButton(
      child: Text('Ok'),
      onPressed: okPressed,
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: key,
          child: Column(
            children: [
              UtilsWidgets.textFormField('answer', 'answer', (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please Enter correct answer";
                }
              }, answer),
              isRequired
                  ? UtilsWidgets.textFormField('options', 'options', (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Please Enter options";
                      }
                    }, options, maxLine: 4)
                  : SizedBox()
            ],
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showToastFunc(message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static bottomDialogs(
      String msg,
      String title,
      String btn1name,
      String btn2name,
      BuildContext context,
      Function() on1Pressed,
      Function() on2Pressed) {
    return Dialogs.bottomMaterialDialog(
        msg: msg,
        title: title,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: on1Pressed,
            text: btn1name,
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.red,
          ),
          IconsButton(
            onPressed: on2Pressed,
            text: btn2name,
            iconData: Icons.swipe_right,
            color: Colors.green,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  static showRatingAppDialog(BuildContext context, String title,
      Function() onCancelled, Function(dynamic) onSubmitted) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: RatingDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            message: Text(
              'feed_q1'.tr,
              textAlign: TextAlign.center,
            ),
            image: Image.asset(
              "assets/images/app_icon.png",
              height: 100,
            ),
            commentHint: 'feed_q2'.tr,
            submitButtonText: 'submit'.tr,
            onCancelled: onCancelled,
            onSubmitted: onSubmitted,
          ),
        );
      },
    );
  }
}
