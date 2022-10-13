import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/globals.dart';

class BottomActionsSheet extends StatelessWidget {
  final bottomActionsListTiles;

  BottomActionsSheet({this.bottomActionsListTiles});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: theme.colors.appBarColor,
            borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(10),
        child: Theme(
          data: ThemeData(
            iconTheme: IconThemeData(
              color: theme.colors.secondaryColor,
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Sofia',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.black,
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => bottomActionsListTiles[index],
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                indent: 13,
                endIndent: 13,
                color: Colors.grey[200],
              ),
              itemCount: bottomActionsListTiles.length,
            ),
          ),
        ),
      ),
    );
  }
}

constructListTile(String title, Icon icon, VoidCallback onTap) {
  return Container(
    padding: EdgeInsets.all(5),
    child: ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Sofia',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    ),
  );
}
