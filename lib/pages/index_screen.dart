import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage/account_screen.dart';
import 'package:flutter_application_1/pages/homepage/login_screen.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IndexScreen extends HookConsumerWidget {
    const IndexScreen({super.key});

    static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    static const List<String> title = <String>["Home", "Feed", "My Post", "Account"];
    static const List<Widget> _widgetOptions = <Widget>[
        Text(
            'TODO: Home',
            style: optionStyle,
        ),
        Text(
            'TODO: Feed',
            style: optionStyle,
        ),
        Text(
            'TODO: My Post',
            style: optionStyle,
        ),
        AccountScreen(),
    ];
    static const List<BottomNavigationBarItem> _bottomNavItem = [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.grey), activeIcon: Icon(Icons.home, color: Colors.blueAccent), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded, color: Colors.grey,), activeIcon: Icon(Icons.add_circle_rounded, color: Colors.blueAccent,),label: "Feeds"),
        BottomNavigationBarItem(icon: Icon(Icons.feed_outlined, color: Colors.grey,), activeIcon: Icon(Icons.feed, color: Colors.blueAccent,), label: "My Posts"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Colors.grey,), activeIcon: Icon(Icons.account_circle, color: Colors.blueAccent,), label: "Account"),
    ];

    // Widget renderedScreen(int index) {
    //     return TabContent(tabIndex: index);
    // }

    void _onItemTapped(ValueNotifier<int> indexValue, int currentValue) {
        indexValue.value = currentValue;
    }

    @override
    Widget build(BuildContext context, ref) {
        final isLogin = ref.watch(userDataStateProvider);
        ValueNotifier<int> indexNavigationBar = useState(0);

        return Scaffold(
            appBar: AppBar(
                title: Text(isLogin == null ? "Login" : title[indexNavigationBar.value]),
            ),
            // body: const _MyCustomForm(),
            // body: isLogin == null ? const LoginForm() : const AccountScreen(),
            // body: renderedScreen(indexNavigationBar.value),
            // bottomNavigationBar: NavigationBar(
            //     selectedIndex: indexNavigationBar.value,
            //     destinations: <Widget>[
            //         NavigationDestination(icon: Icon(indexNavigationBar.value == 0 ? Icons.home : Icons.home_outlined), label: "Home"),
            //         NavigationDestination(icon: Icon(indexNavigationBar.value == 1 ? Icons.account_circle : Icons.account_circle_outlined), label: "Profile"),
            //     ],
            //     onDestinationSelected: (value) {
            //         debugPrint(value.toString());
            //         indexNavigationBar.value = value;
            //     },
            // ),
            body: isLogin == null ? const LoginForm() : _widgetOptions.elementAt(indexNavigationBar.value),
            bottomNavigationBar: isLogin == null ? null : BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: _bottomNavItem,
                currentIndex: indexNavigationBar.value,
                onTap: (index) {
                    _onItemTapped(indexNavigationBar, index);
                },
            ),
        );
    }
}

// class TabContent extends StatefulHookConsumerWidget {
//     final int tabIndex;
//     const TabContent({super.key, required this.tabIndex});

//     @override
//     ConsumerState<ConsumerStatefulWidget> createState() => _TabContentState();
// }
// class _TabContentState extends ConsumerState<TabContent> {
//     @override
//     Widget build(BuildContext context) {
//         return Text("${widget.tabIndex}");
//     }
// }