import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/view_model_provider.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';
import 'package:flutter_goya_app/generated/i18n.dart';
import 'package:flutter_goya_app/utils/utils.dart';
import 'package:flutter_goya_app/view_model/theme_model.dart';
import 'package:flutter_goya_app/viewmodel/login_view_model.dart';
import 'package:flutter_goya_app/widget/bottom_clipper.dart';
import 'package:flutter_goya_app/widget/button_progress_indicator.dart';
import 'package:flutter_goya_app/widget/login_field_widget.dart';
import 'package:provider/provider.dart';

///登录
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginViewModel loginViewModel;

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pwdFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loginViewModel = ViewModelProvider.of(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: Icon(
              Icons.chevron_left,
              size: 40,
            ),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                LoginTopPanel(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoginLogo(),
                      LoginFormContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LoginTextField(
                              label: S
                                  .of(context)
                                  .userName,
                              icon: Icons.perm_identity,
                              controller: _nameController,
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              onFieldSubmited: (text) {
                                FocusScope.of(context).requestFocus(_pwdFocus);
                              },
                            ),
                            LoginTextField(
                              controller: _passwordController,
                              label: S
                                  .of(context)
                                  .password,
                              icon: Icons.lock_outline,
                              obscureText: true,
                              focusNode: _pwdFocus,
                              textInputAction: TextInputAction.done,
                            ),
                            LoginButton(_nameController, _passwordController,
                                loginViewModel),
                            SingUpWidget(_nameController),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

///登录按钮
class LoginButton extends StatelessWidget {
  final nameController;
  final passwordController;
  final LoginViewModel loginViewModel;

  LoginButton(this.nameController, this.passwordController,
      this.loginViewModel);

  bool canOnPressed = false;

  @override
  Widget build(BuildContext context) {
    return LoginButtonWidget(
      child: StreamBuilder(
        stream: loginViewModel.dataStream,
        builder: (BuildContext context, AsyncSnapshot<UserEntity> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ButtonProgressIndicator();
          } else {
            canOnPressed = true;
            return Text(
              S.of(context)
                  .signIn,
              style: Theme
                  .of(context)
                  .accentTextTheme
                  .title
                  .copyWith(wordSpacing: 6),
            );
          }
        },),
      onPressed: !canOnPressed ? null : (){
        var formState = Form.of(context);
        if (formState.validate()) {
          loginViewModel.login(nameController.text, passwordController.text);
        }
      } ,
    );
  }
}

class SingUpWidget extends StatefulWidget {
  final nameController;

  SingUpWidget(this.nameController);

  @override
  _SingUpWidgetState createState() => _SingUpWidgetState();
}

class _SingUpWidgetState extends State<SingUpWidget> {
  TapGestureRecognizer _recognizerRegister;

  @override
  void initState() {
    _recognizerRegister = TapGestureRecognizer()
      ..onTap = () async {
        // 将注册成功的用户名,回填如登录框
//        widget.nameController.text =
//        await Navigator.of(context).pushNamed(UIRouter.register);
      };
    super.initState();
  }

  @override
  void dispose() {
    _recognizerRegister.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(TextSpan(text: S.of(context).noAccount, children: [
        TextSpan(
            text: S.of(context).toSignUp,
            recognizer: _recognizerRegister,
            style: TextStyle(color: Theme.of(context).accentColor))
      ])),
    );
  }
}

///顶部弧形背景
class LoginTopPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipPath(
      clipper: BottomClipper(),
      child: Container(
        height: 220,
        color: Theme
            .of(context)
            .primaryColor,
      ),
    );
  }
}

///LOGO
class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return InkWell(
            onTap: () {
              themeModel.switchRandomTheme();
            },
            child: child,
          );
        },
        child: Hero(
          tag: 'loginLogo',
          child: Image.asset(
            Utils.getImagePath('login_logo'),
            width: 130,
            height: 100,
            fit: BoxFit.fitWidth,
            color: theme.brightness == Brightness.dark
                ? theme.accentColor
                : Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

///内容
class LoginFormContainer extends StatelessWidget {
  final Widget child;

  LoginFormContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              side: BorderSide(
                  color: Color(0xFFFFFFFF),
                  style: BorderStyle.solid,
                  width: 2)),
          color: Theme
              .of(context)
              .cardColor,
          shadows: [
            BoxShadow(
                color: Theme
                    .of(context)
                    .primaryColor
                    .withAlpha(20),
                offset: Offset(1.0, 1.0),
                blurRadius: 10.0,
                spreadRadius: 3.0),
          ]),
      child: child,
    );
  }
}

/// LoginPage 按钮样式封装
class LoginButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  LoginButtonWidget({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var color = Theme
        .of(context)
        .primaryColor
        .withAlpha(180);
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          color: color,
          disabledColor: color,
          borderRadius: BorderRadius.circular(110),
          pressedOpacity: 0.5,
          child: child,
          onPressed: onPressed,
        ));
  }
}
