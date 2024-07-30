import 'dart:math' as math;

import 'package:aihealthcoaching_main/utils/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/constants.dart';
import '../providers/auth.dart';
import '../generated/l10n.dart';
import 'categories/categories.dart';
import 'group_result.dart';
import 'home/dashboard.dart';
import 'offline/offline_screen.dart';
import 'settings/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    Categories(),
    // PaymentScreen(),
    ShareScreen(),
    //UserPage()
    GroupResults()
  ];

  int _index = 0;

  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    initAuthProvider(context);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            //icon: Icon(Icons.home_outlined),
            icon: Image.asset(
              "assets/images/icons/home.png",
              width: 50,
            ),
            label: '${S.of(context)!.home}',
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.category_outlined),
            icon: Image.asset(
              "assets/images/icons/index.png",
              width: 50,
            ),

            label: '${S.of(context)!.indices}',
          ),
          // BottomNavigationBarItem(
          //   //icon: Icon(Icons.attach_money_outlined),
          //   icon: Image.asset(
          //     "assets/images/icons/payment.png",
          //     width: 50,
          //   ),
          //   label: '${S.of(context).payment}',
          // ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.share),
            icon: Image.asset(
              "assets/images/icons/share.png",
              width: 50,
            ),
            label: '${S.of(context)!.share}',
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.person_outline_outlined),
            icon: Image.asset(
              "assets/images/icons/group_result.png",
              width: 50,
            ),
            label: '${S.of(context)!.group_result}',
          ),
        ],
        selectedItemColor: Color(kPrimaryNavigationBarColor),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: connectionStatus == ConnectivityStatus.Offline
          ? OffLineScreen()
          : _widgetList[_index],
      floatingActionButton: ExpandableFab(
        distance: 130.0,
        initialOpen: false,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-weight');
            },
            icon: Image.asset(
              "assets/images/icons/balance.png",
              fit: BoxFit.cover,
              width: 150,
            ),
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-next-goal');
            },
            icon: Image.asset(
              "assets/images/icons/target.png",
              fit: BoxFit.fill,
            ),
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-picture');
            },
            icon: Image.asset(
              "assets/images/icons/upload_image.png",
              fit: BoxFit.cover,
            ),
          ),
          // ActionButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/add-testmonial');
          //   },
          //   //icon: const Icon(Icons.videocam_outlined),
          //   /*icon: ImageIcon(
          //     AssetImage("assets/images/icons/upload_video.png"),
          //   ),*/
          //   icon: Image.asset(
          //     "assets/images/icons/upload_video.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ],
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    required this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Container(
        height: 120,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(
              Icons.add,
              size: 35,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

@immutable
// ignore: must_be_immutable
class _ExpandingActionButton extends StatelessWidget {
   _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  double directionInDegrees = 0.0;
  double maxDistance = 0.0;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.iconTheme,
        child: IconButton(
          iconSize: 80.0,
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
