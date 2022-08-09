import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/ui/home/home.dart';

class RoootScreen extends StatefulWidget {
  const RoootScreen({Key? key}) : super(key: key);

  @override
  State<RoootScreen> createState() => _RoootScreenState();
}

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class _RoootScreenState extends State<RoootScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _carteKey = GlobalKey();
  GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _carteKey,
    profileIndex: _profileKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedScreenIndex,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectedIndex;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                ),
                label: 'خانه',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: const [
                    Icon(
                      CupertinoIcons.cart,
                    ),
                  ],
                ),
                label: 'سبد خرید',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.person,
                ),
                label: ' پروفایل',
              ),
            ],
          ),
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              _navigator(_homeKey, homeIndex, const HomeScreen()),
              _navigator(_carteKey, cartIndex, const CartScreen()),
              _navigator(
                _profileKey,
                profileIndex,
                const ProfileScreen(),
              ),
            ],
          ),
        ));
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child)));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cart Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
