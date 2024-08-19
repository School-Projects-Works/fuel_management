import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/core/views/custom_drop_down.dart';
import 'package:fuel_management/core/views/custom_input.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/provider/driver_new_edit_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/functions/int_to_date.dart';
import '../../../../../../core/views/custom_button.dart';
import '../../../../../../router/router.dart';
import '../../../../../../router/router_items.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/styles.dart';

class NewDriverForm extends ConsumerStatefulWidget {
  const NewDriverForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewDriverFormState();
}

class _NewDriverFormState extends ConsumerState<NewDriverForm> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var notifier = ref.read(newDriverProvider.notifier);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(22),
      alignment: Alignment.center,
      child: SizedBox(
        width: styles.width * 0.55,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.driversRoute);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      Text(
                        'Back',
                        style: styles.body(fontSize: 15),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register New Driver'.toUpperCase(),
                        style: styles.title(fontSize: 35, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: primaryColor,
              thickness: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Driver Id',
                          label: 'Driver Id',
                          //isCapitalized: true,
                          
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Driver Id is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setDriverId(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomDropDown(
                          label: 'Driver Gender',
                          items: ['Male', 'Female']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          hintText: 'Driver Gender',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Driver gender is required';
                            }
                            return null;
                          },
                          onChanged: (type) {
                            notifier.setGender(type);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFields(
                          label: 'Driver Name',
                          hintText: 'Driver Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Driver Name is required';
                            }
                            return null;
                          },
                          onSaved: (name) {
                            notifier.setName(name);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Driver Phone',
                          label: 'Driver Phone',
                          //isDigitOnly: true,
                          isPhoneInput: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Driver Phone is required';
                            }
                            return null;
                          },
                          onSaved: (phone) {
                            notifier.setPhone(phone!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextFields(
                              label: 'License Number',
                              hintText: 'License Number',
                              validator: (fuel) {
                                if (fuel == null || fuel.isEmpty) {
                                  return 'Driver License Number is required';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                notifier.setLicenseNumber(value);
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      //fuel capacity
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'License Expiry Date',
                          label: 'License Expiry Date',
                          controller: TextEditingController(
                              text: ref
                                          .watch(newDriverProvider)
                                          .licenseExpiryDate !=
                                      0
                                  ? intToDate(ref
                                      .watch(newDriverProvider)
                                      .licenseExpiryDate)
                                  : ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'License Expiry Date is required';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value != null) {
                                  notifier.setLicenseExpire(
                                      value.millisecondsSinceEpoch);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Join Date',
                          label: 'Join Date',
                          controller: TextEditingController(
                              text: ref.watch(newDriverProvider).dateEmployed !=
                                      0
                                  ? intToDate(
                                      ref.watch(newDriverProvider).dateEmployed)
                                  : ''),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value != null) {
                                  notifier.setDateEmployed(
                                      value.millisecondsSinceEpoch);
                                }
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'License Expiry Date is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //notifier.setLicenseExpire(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          if (ref.watch(driverImageProvider) != null)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  image: DecorationImage(
                                      image: MemoryImage(
                                          ref.watch(driverImageProvider)!),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        ref
                                            .read(driverImageProvider.notifier)
                                            .state = null;
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          if (ref.watch(driverImageProvider) == null)
                            TextButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: const Text('Upload Driver Image'))
                          else
                            TextButton(
                                onPressed: () {
                                  ref.read(driverImageProvider.notifier).state =
                                      null;
                                },
                                child: const Text(
                                  'Remove Image',
                                  style: TextStyle(color: Colors.red),
                                ))
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          if (ref.watch(licenseImageProvider) != null)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  image: DecorationImage(
                                      image: MemoryImage(
                                          ref.watch(licenseImageProvider)!),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          if (ref.watch(licenseImageProvider) == null)
                            TextButton(
                                onPressed: () {
                                  pickLicense();
                                },
                                child: const Text('Upload License Image'))
                          else
                            TextButton(
                                onPressed: () {
                                  ref
                                      .read(licenseImageProvider.notifier)
                                      .state = null;
                                },
                                child: const Text(
                                  'Remove Image',
                                  style: TextStyle(color: Colors.red),
                                ))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: 'Save Driver',
                    radius: 10,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        var image = ref.watch(driverImageProvider);
                        var license = ref.watch(licenseImageProvider);
                        if (image != null && license != null) {
                          notifier.saveDriver(ref: ref, form: formKey);
                        } else {
                          CustomDialogs.showDialog(
                              message:
                                  'Please upload driver image and license image',
                              type: DialogType.error);
                        }
                      }
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(driverImageProvider.notifier).state = await image.readAsBytes();
    }
  }

  void pickLicense() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(licenseImageProvider.notifier).state = await image.readAsBytes();
    }
  }
}
