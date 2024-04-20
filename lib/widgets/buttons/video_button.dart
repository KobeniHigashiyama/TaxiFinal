import 'package:cars/widgets/map_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/car_order_bloc/car_order_bloc.dart';
import '../../bloc/route_from_to/route_from_to.dart';
import '../../bloc/user/user_cubit.dart';
import '../../models/role.dart';
import '../../pages/video_player_page.dart';
import '../../res/styles.dart';

class VideoButton extends StatefulWidget {
  final GlobalKey<MapContainerState> mapKey;
  final GlobalKey<dynamic> mapDriverKey;
  final VoidCallback onPressed;

  const VideoButton({
    Key? key,
    required this.mapKey,
    required this.mapDriverKey,
    required this.onPressed,
  }) : super(key: key);

  @override
  _VideoButtonState createState() => _VideoButtonState();
}

class _VideoButtonState extends State<VideoButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 420, right: 0),
      child: Container(
        width: 30,
        height: 110,
        child: Column(
          children: [
            if (BlocProvider.of<UserCubit>(context).getUser()!.role ==
                Role.pass)
              InkWell(
                onTap: () async {
                  try {
                    widget.mapKey.currentState!
                        .fetchCurrentLocation(showCar: false);
                  } catch (e) {
                    print(e);
                  }
                  try {
                    widget.mapDriverKey.currentState!
                        .fetchCurrentLocation(showCar: false);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 151, 150, 151).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: (BlocProvider.of<CarOrderBloc>(context)
                                  .currentOrder
                                  .from !=
                              null &&
                          BlocProvider.of<CarOrderBloc>(context)
                                  .currentOrder
                                  .route !=
                              null &&
                          BlocProvider.of<CarOrderBloc>(context)
                                  .currentOrder
                                  .route!
                                  .length >=
                              1)
                      ? Image.asset(
                          'asstes/route.png',
                          color: blue,
                          scale: 10,
                        )
                      : Image.asset(
                          'asstes/point_1.png',
                          color: blue,
                          scale: 15,
                        ),
                ),
              ),
            SizedBox(height: 10),
            InkWell(
              onTap: widget.onPressed,
              child: Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 151, 150, 151).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  'asstes/cam7.png',
                  color: blue,
                  fit: BoxFit.fill,
                  scale: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VideoPlayerPage()),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 151, 150, 151).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  'asstes/car.png',
                  fit: BoxFit.fill,
                  scale: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
