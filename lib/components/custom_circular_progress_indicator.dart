import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
    final double? height;
    final double? width;
    final Color? color;
    final EdgeInsetsGeometry? padding;
    const CustomCircularProgressIndicator({ super.key, this.height = 10, this.width = 10, this.color, this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)});

    @override
    Widget build(BuildContext context){
        Color? warna = color ?? Colors.blue[900];

        return Padding(
            padding: padding ?? const EdgeInsets.symmetric(),
            child: SizedBox(
                width: width,
                height: height,
                child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: warna,
                ),
            ),
        );
    }
}