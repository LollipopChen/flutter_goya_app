import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/view_model/locale_model.dart';
import 'package:flutter_goya_app/view_model/theme_model.dart';
import 'package:flutter_goya_app/viewmodel/setting_view_model.dart';
import 'package:flutter_goya_app/widget/back_title_bar.dart';
import 'package:provider/provider.dart';

///设置
class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  SettingViewModel settingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingViewModel = ViewModelProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: BackTitleBar(
        isShowBack: true,
        titleText: S.of(context).setting,
        backgroundColor: Theme.of(context).primaryColor.withAlpha(200),
      ),
      body: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              Gaps.vGap20,
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text('WebViewPlugin'),
                  onTap: settingViewModel.switchValue,
                  leading: Icon(
                    Icons.language,
                    color: iconColor,
                  ),
                  trailing: CupertinoSwitch(
                      activeColor: Theme.of(context).accentColor,
                      value: settingViewModel.value,
                      onChanged: (value) {
                        settingViewModel.switchValue();
                      }),
                ),
              ),
              Gaps.vGap20,
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(S.of(context).settingFont),
                      Text(
                        ThemeModel.fontName(
                            Provider.of<ThemeModel>(context).fontIndex,
                            context),
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  leading: Icon(
                    Icons.font_download,
                    color: iconColor,
                  ),
                  children: <Widget>[
                    ListView.builder(
                      itemBuilder: (context, index) {
                        var model = Provider.of<ThemeModel>(context);
                        return RadioListTile(
                            value: index,
                            groupValue: model.fontIndex,
                            title: Text(ThemeModel.fontName(index, context)),
                            onChanged: (index) {
                              model.switchFont(index);
                            });
                      },
                      shrinkWrap: true,
                      itemCount: ThemeModel.fontValueList.length,
                    )
                  ],
                ),
              ),
              Gaps.vGap10,
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        S.of(context).settingLanguage,
                      ),
                      Text(
                        LocaleModel.localeName(
                            Provider.of<LocaleModel>(context).localeIndex,
                            context),
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  leading: Icon(
                    Icons.public,
                    color: iconColor,
                  ),
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: LocaleModel.localeValueList.length,
                        itemBuilder: (context, index) {
                          var model = Provider.of<LocaleModel>(context);
                          return RadioListTile(
                            value: index,
                            onChanged: (index) {
                              model.switchLocale(index);
                            },
                            groupValue: model.localeIndex,
                            title: Text(LocaleModel.localeName(index, context)),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
