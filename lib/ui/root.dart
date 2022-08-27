import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/ui/cart/cart.dart';
import 'package:nike_store/ui/home/home.dart';
import 'package:nike_store/ui/profile/profile_Screen.dart';
import 'package:nike_store/ui/widgets/badge.dart';
import 'package:nike_store/ui/widgets/emty_state.dart';

import 'auth/atuh.dart';

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
    cartRepository.count();

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
                  children: [
                    Icon(
                      CupertinoIcons.cart,
                    ),
                    Positioned(
                      right: -10,
                      child: ValueListenableBuilder<int>(
                        valueListenable: CartRepository.cartNotifierCount,
                        builder: (context, value, child) {
                          return Badge(value: value);
                        },
                      ),
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

class ProfileScreen1 extends StatelessWidget {
  const ProfileScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile Screen'),
              AuthRepository.authInfoNotifire.value == null &&
                      AuthRepository.authInfoNotifire.value!.accessToen.isEmpty
                  ? EmptyState(
                      message: 'لطفا وارد حساب کاربری شوید',
                      image: SvgPicture.asset(
                        'assets/svgs/auth_required.svg',
                        width: 200,
                        height: 200,
                      ),
                      callToaction: ElevatedButton(
                        child: Text('ورود'),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AuthScreen()));
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
