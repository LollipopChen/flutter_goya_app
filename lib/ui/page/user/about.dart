import 'package:flutter/material.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/res/text_styles.dart';
import 'package:flutter_goya_app/utils/image_utils.dart';
import 'package:flutter_goya_app/utils/utils.dart';
import 'package:flutter_goya_app/widget/back_title_bar.dart';
import 'package:package_info/package_info.dart';

///关于
class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  PackageInfo packageInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo){
      setState(() {
        this.packageInfo = packageInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BackTitleBar(
        titleText: '关于',
        isShowBack: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Gaps.vGap50,
            loadAssetsOvalImage(Utils.getImagePath('logo'),height: 100,
                width: 100),
            Gaps.vGap5,
            Text(
              '${packageInfo?.appName}',
              style: TextStyles.textBoldDark18,
            ),
            Gaps.vGap5,
            Text(
              'v${packageInfo?.version}',
              style: TextStyles.textDark16,
            ),
          ],
        ),
      ),
    );
  }
}
