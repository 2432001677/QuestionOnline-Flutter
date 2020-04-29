import 'package:flutter/material.dart';

roundName(name) {
  return ClipOval(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircleAvatar(
        child: Text(
          name[0].toUpperCase(),
          style: TextStyle(fontSize: 12),
        ),
      ),
    ),
  );
}
