import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smartpark/models/parking_model.dart';
import 'package:smartpark/models/spots_model.dart';
import 'package:smartpark/providers/parking_provider.dart';
import 'package:smartpark/style/colors.dart';

class SpaceView extends StatelessWidget {
  static const String routerName = 'space';
  static const String routerPath = '/space';
  const SpaceView({super.key, required this.argument});
  final Map argument;

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final ParkingModel parking = argument['parking'] as ParkingModel;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(parking.name ?? '', style: const TextStyle(color: AppColors.dark, fontSize: 18),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: parkingProvider.getParkingsById(parking.idPar),
            builder: (context, snapshot) {
              if(parking.spots == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<SpotsModel> spotsModel = snapshot.data as List<SpotsModel>;
              return GridView.builder(
                shrinkWrap: true,
                primary: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 120,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 110
                ),
                itemCount: spotsModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary, width: 2)
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.identity()..rotateZ(90 * 3.1415927 / 180),
                            child: SvgPicture.asset('assets/images/car.svg', color: spotsModel[index].status == 1? AppColors.green : spotsModel[index].status == 2? Colors.yellow.withOpacity(0.8): AppColors.red, width: 50)
                          ),
                          Text(parking.spots![index].spotNumber.toString(), style: const TextStyle(color: AppColors.dark, fontSize: 14))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          ),
        )
      ),
    );
  }
}