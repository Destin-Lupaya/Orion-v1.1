import 'package:orion/Resources/global_variables.dart';
import 'package:flutter/material.dart';

class ModalProgress extends StatelessWidget {
  final Widget child;
  final Color progressColor;
  final bool isAsync;
  const ModalProgress(
      {Key? key,
      required this.child,
      required this.progressColor,
      required this.isAsync})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kTransparentColor,
      body: Stack(
        children: [
          child,
          isAsync
              ? Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      color: AppColors.kBlackColor.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(progressColor),
                        ),
                      ),
                    ),
                  ))
              : Container()
        ],
      ),
    );
  }
}
