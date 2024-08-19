import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/functions/navigation.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/driver/auth/provider/driver_login_provider.dart';
import 'package:fuel_management/features/driver/pages/end_trip_page.dart';

import '../../../core/functions/int_to_date.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';
import '../../admin/dashboard/provider/assignment_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var driver = ref.watch(driverProvider);
    var assignments = ref
        .watch(assignmentsProvider)
        .items
        .where((element) => element.driverId == driver!.id)
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assignment History', style: style.title(color: primaryColor)),
            const SizedBox(
              height: 10,
            ),
            if (assignments.isEmpty)
              const Center(child: Text('No assignments yet')),
            ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var pendingOrOnTrip = assignments[index];
                  return Container(
                    width: style.width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.white),
                                      const SizedBox(width: 10),
                                      Text(
                                        pendingOrOnTrip.route,
                                        style: style.body(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.date_range,
                                          color: Colors.white),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Pickup: ${intToDate(pendingOrOnTrip.pickupTime)}',
                                        style: style.body(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  //car number
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.numbers,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        pendingOrOnTrip
                                            .car['registrationNumber'],
                                        style: style.body(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  Assets.imagesLogoWhite,
                                  width: 80,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                //status
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Text(pendingOrOnTrip.status))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (pendingOrOnTrip.status == 'on trip')
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryColor),
                              onPressed: () {
                                ref
                                    .read(selectedAssignmentProvider.notifier)
                                    .setAssignment(pendingOrOnTrip);
                                navigateTransparentRoute(
                                    context,
                                    EndTripPage(
                                      assignment: pendingOrOnTrip,
                                    ));
                              },
                              child: Text(
                                'Complete Trip',
                                style: style.subtitle(color: primaryColor),
                              )),
                        if (pendingOrOnTrip.status == 'pending')
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryColor),
                              onPressed: () {
                                CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to start trip?',
                                    secondBtnText: 'Start',
                                    onConfirm: () async {
                                      ref
                                          .read(assignmentsProvider.notifier)
                                          .updateTrip(pendingOrOnTrip.copyWith(
                                            status: 'on trip',
                                          ));
                                    });
                              },
                              child: Text(
                                'Start Trip',
                                style: style.subtitle(color: primaryColor),
                              ))
                      ],
                    ),
                  );
                },
                itemCount: assignments.length),
          ],
        ),
      ),
    );
  }
}
