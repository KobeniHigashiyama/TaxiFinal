import 'dart:async';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car_order.dart';
import 'package:cars/models/route_from_to.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/utils.dart';
import 'package:cars/widgets/bottom_sheet/bottom_shet_header.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_shet_body.dart';
import 'package:cars/widgets/buttons/map_button.dart';
import 'package:cars/widgets/menu/pass_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoPlayerController _firstController;
  late VideoPlayerController _secondController;
  late CarOrder order;

  StreamSubscription<dynamic>? streamSubscription;

  @override
  void initState() {
    super.initState();
    order = CarOrder(
        status: CarOrderStatus
            .active); // Исправлено: передаем значение для параметра status

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      order =
          BlocProvider.of<CarOrderBloc>(context, listen: false).currentOrder;

      if (order.from == null) {
        Future.delayed(const Duration(seconds: 3), () async {
          try {
            var point = await getCurrentPoint();
            BlocProvider.of<CarOrderBloc>(context, listen: false)
                .currentOrder
                .from = point;
            if (mounted) {
              setState(() {
                order = BlocProvider.of<CarOrderBloc>(context, listen: false)
                    .currentOrder;
              });
            }
          } catch (e) {
            print(e);
          }
        });
      }
    });

    _initializeVideoControllers();
    _setupFirestoreSubscription();
  }

  void _initializeVideoControllers() {
    _firstController = VideoPlayerController.network(
        'rtmp://rtmp.streamaxia.com/streamaxia/-225403035')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _firstController.play();
          });
        }
      }).catchError((e) {
        print('Error initializing the first video controller: $e');
      });

    _secondController = VideoPlayerController.network(
        'rtmp://rtmp.streamaxia.com/streamaxia/-225403035')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((e) {
        print('Error initializing the second video controller: $e');
      });
  }

  void _setupFirestoreSubscription() {
    if (!(BlocProvider.of<CarOrderBloc>(context, listen: false).state
        is CarOrderStatePlanAnother)) {
      streamSubscription = FirebaseFirestore.instance
          .collection("orders")
          .snapshots()
          .listen((querySnapshot) {
        BlocProvider.of<CarOrderBloc>(context, listen: false)
            .add(CarOrderEventInitPassenger());
      });
    }
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: PassMenu(),
      floatingActionButton: MapButton(
        onPressed: () {
          Get.to(() => PassHomePage());
        },
      ),
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: BottomSheetHeader(),
        expandableContent: PassBottomSheetBody(order: order),
        onIsExtendedCallback: () {
          print('Sheet is extended');
        },
        onIsContractedCallback: () {
          print('Sheet is contracted');
        },
        background: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50),
                      Expanded(
                        child: _firstController.value.initialized
                            ? VideoPlayer(_firstController)
                            : CircularProgressIndicator(),
                      ),
                      Expanded(
                        child: _secondController.value.initialized
                            ? VideoPlayer(_secondController)
                            : CircularProgressIndicator(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
