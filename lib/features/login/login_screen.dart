import 'package:admin_app/bloc/authentication/authentication_bloc.dart';
import 'package:admin_app/bloc/common/password_visibility_cubit.dart';
import 'package:admin_app/features/home/home_screen.dart';
import 'package:admin_app/widgets/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext rootContext) {
    final screenSize = MediaQuery.of(rootContext).size;
    final authBloc = BlocProvider.of<AuthenticationBloc>(rootContext);

    return BlocProvider<PasswordVisibilityCubit>(
        create: (blocContext) {
          return PasswordVisibilityCubit();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (listenerContext, state) {
              if (state is AuthenticationSuccessState) {
                HomeScreen.navigate(listenerContext);
              } else if (state is AuthenticationErrorState) {
                ScaffoldMessenger.of(listenerContext)
                    .showSnackBar(SnackBar(content: Text("${state.err}")));
              }
            },
            child: Stack(
              children: [
                provideSvgLocalImage(assetPath: "assets/images/bg.svg"),
                Center(
                  child: Container(
                    width: screenSize.width * 0.6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                            decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        )),
                        SizedBox(
                          height: 16.0,
                        ),
                        BlocBuilder<PasswordVisibilityCubit,
                                PasswordVisibilityState>(
                            builder: (blocContext, state) {
                          final bloc = BlocProvider.of<PasswordVisibilityCubit>(
                              blocContext);

                          return TextFormField(
                            controller: _passwordController,
                            obscureText: !state.visibility,
                            decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(!state.visibility
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded),
                                  onPressed: () {
                                    if (state.visibility)
                                      bloc.hide();
                                    else
                                      bloc.show();
                                  },
                                )),
                          );
                        }),
                        SizedBox(
                          height: 32.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              /*authBloc.login(_usernameController.text, _passwordController.text)*/
                              /// this is only temporary
                              if (_usernameController.text == "admin" && _passwordController.text == "P@sSw0Rd") {
                                HomeScreen.navigate(rootContext);
                              } else {
                                ScaffoldMessenger.of(rootContext).showSnackBar(SnackBar(content: Text("Please enter correct credentials")));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text("LOGIN"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
