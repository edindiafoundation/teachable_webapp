import 'package:flutter/material.dart';

class Widgets {
  static Widget fieldData(String? key, String? value, BuildContext context,
      {bool isHighlight = false, Color? color}) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 30,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      "Your Answer :- ",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      key ?? "",
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isHighlight ? Colors.white : null,
                          backgroundColor: isHighlight ? color : null),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                      child: Text(
                    value ?? "",
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            endIndent: 20,
            indent: 20,
            thickness: 1,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
