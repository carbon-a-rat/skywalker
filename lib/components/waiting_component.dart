import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FutureBuilder waitFor<T>({executed, waiting_for, placeholder}) {
  return FutureBuilder(
    future: waiting_for(),
    builder: (context, snapshot) {
      if (context == null) {
        return Text("Loading...");
      }
      if (snapshot.hasData) {
        if (snapshot.data != 0) {
          T data = snapshot.data!;
          return executed(data);
        }
      }

      return Center(child: CircularProgressIndicator());
    },
  );
}
