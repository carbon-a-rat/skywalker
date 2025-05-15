import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';

class FilterResult {
  String code = "";
}

Future<FilterResult?> showChartFilter(BuildContext context) async {
  TextStyle style = Theme.of(context).textTheme.headlineLarge!;
  FilterResult result = FilterResult();
  DateTime invalidation_date = DateTime.now().add(Duration(days: 2));
  return await showDialog<FilterResult>(
    context: context,
    builder: (context) {
      // values
      return StatefulBuilder(
        builder:
            (context, setState) => SizedBox(
              height: 500,
              child: Dialog(
                child: pad(
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          pad(
                            Text(
                              "Filter charts",
                              style: style.apply(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pad(Text("Filter charts")),

                      pad(
                        Column(
                          children: [
                            pady(
                              OutlinedButton.icon(
                                onPressed:
                                    () => {
                                      showDatePicker(
                                        context: context,
                                        initialDate: invalidation_date,
                                        firstDate: DateTime.now().add(
                                          Duration(days: 1),
                                        ),
                                        lastDate: DateTime.now().add(
                                          Duration(days: 8),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          if (value == null) return;
                                          invalidation_date = value;
                                        });
                                      }),
                                    },
                                icon: Icon(Icons.date_range),
                                label: Text("Set specific launcher date"),
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                pad(
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: padx(Text("Cancel")),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, result);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_alt),
                                      Text("Filter"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    },
  );
}
