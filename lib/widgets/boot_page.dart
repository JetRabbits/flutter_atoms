import 'package:flutter/material.dart';
import 'package:flutter_atoms/blocs/blocs.dart';
import 'package:flutter_atoms/blocs/boot/boot_bloc_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BootPage extends StatelessWidget {
  final Widget logo;

  final String repeatLabelText;

  final String nextRoute;

  const BootPage(
      {Key key, this.logo, this.repeatLabelText, @required this.nextRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          logo ?? FlutterLogo(size: 100),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<BootBlocCubit, BootBlocState>(
                listener: (prev, current) {
              if (current == BootBlocState.READY) {
                Navigator.of(context).pushReplacementNamed(nextRoute);
              }
            }, builder: (context, state) {
              var bootCubit = BlocProvider.of<BootBlocCubit>(context);
              if (state == BootBlocState.INIT) bootCubit.start();
              if (state == BootBlocState.ERROR)
                return Center(
                    child: FlatButton(
                  onPressed: () => bootCubit.start(),
                  child: SizedBox(
                    width: 200,
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 24,
                        ),
                        SizedBox(width: 4),
                        Text(
                          repeatLabelText ?? "repeat load",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                );
              return SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
            }),
          ),
        ],
      ),
    );
  }
}
