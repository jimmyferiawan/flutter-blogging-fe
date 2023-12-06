import 'package:flutter/material.dart';

class ScrollableScreen extends StatelessWidget {
    const ScrollableScreen({
        super.key,
        required this.children,
    });

    final Widget children;

    @override
    Widget build(BuildContext context){
        return LayoutBuilder(
            builder: (context, constraints) {
                return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                        ),
                        child: children
                    ),
                );
            },
        );
    }
}