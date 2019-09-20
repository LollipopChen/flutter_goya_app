import 'package:flutter/material.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/routers/uirouter/ui_router.dart';
import 'package:flutter_goya_app/utils/logger.dart';
import 'package:flutter_goya_app/utils/novigator_utils.dart';
import 'package:flutter_goya_app/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController logoController;

  ///倒计时
  AnimationController countdownController;

  @override
  void initState() {
    logoController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: logoController, curve: Curves.easeInOutBack))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          logoController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          logoController.forward();
        }
      });
    logoController.forward();
    ///倒计时-4 秒
    countdownController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    countdownController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.expand,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: double.infinity, minWidth: double.infinity),
              child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFeaf3ff))),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedFlutterLogo(animation: animation),
            ),
            Align(
              alignment: Alignment(0.0, 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AnimatedAndroidLogo(
                    animation: animation,
                  ),
                ],
              ),
            ),
            Align(
              //Align 对齐与相对定位布局
              alignment: Alignment.bottomRight,
              child: SafeArea(
                  child: InkWell(
                onTap: () => toNextPage(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black.withAlpha(100),
                  ),
                  child: AnimatedCountDown(
                    context: context,
                    animation: StepTween(begin: 3, end: 0)
                        .animate(countdownController),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    logoController.dispose();
    countdownController.dispose();
    super.dispose();
  }
}

//跳转主页
void toNextPage(BuildContext context) {
  NavigatorUtils.push(context, UIRouter.mainPage, replace: true);
}

///Flutter Logo
class AnimatedFlutterLogo extends AnimatedWidget {
  AnimatedFlutterLogo({
    Key key,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedAlign(
      duration: Duration(milliseconds: 10),
      alignment: Alignment(0, animation.value * 0.3 - 0.5),
      curve: Curves.bounceOut,
      child: Image.asset(
        Utils.getImagePath('splash_flutter'),
        width: 280,
        height: 120,
      ),
    );
  }
}

///Android Logo
class AnimatedAndroidLogo extends AnimatedWidget {
  AnimatedAndroidLogo({
    Key key,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          Utils.getImagePath('splash_fun'),
          width: 140 * animation.value,
          height: 80 * animation.value,
        ),
        Image.asset(
          Utils.getImagePath('splash_android'),
          width: 200 * (1 - animation.value),
          height: 80 * (1 - animation.value),
        ),
      ],
    );
  }
}

/// 倒计时
class AnimatedCountDown extends AnimatedWidget {
  final Animation<int> animation;

  AnimatedCountDown({key, this.animation, context})
      : super(key: key, listenable: animation) {
    this.animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        toNextPage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var value = animation.value + 1;
//    print("value = $value");
    return Text(
      (value == 0 ? '' : '$value | ') + S.of(context).splashSkip,
      style: TextStyle(color: Colors.white),
    );
  }
}
