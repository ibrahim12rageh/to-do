import 'package:flutter/material.dart';
import 'package:to_do/home/task_list/task_list_item.dart';
import 'package:to_do/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:to_do/provider/app_config_provider.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
class TaskListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      child: Column(
        children: [
          Container(
             color: MyTheme.whiteColor,
            child:EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {
                //`selectedDate` the new date selected.
              },
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
              locale: provider.appLanguage,
            )
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context,int){
                  return TaskListItem();
                },
              itemCount: 30,
                ),
          )
        ],
      ),
    );
  }
}
