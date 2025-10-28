import 'package:mega_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utility/constants.dart';
import '../../widgets/custom_dropdown.dart';
import 'components/order_header.dart';
import 'components/order_list_section.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const OrderHeader(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Orders",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: 280,
                            child: CustomDropdown(
                              hintText: 'Filter Order By status',
                              initialValue: ORDER_STATUS_ALL,
                              items: const [
                                ORDER_STATUS_ALL,
                                ORDER_STATUS_PENDING,
                                ORDER_STATUS_PROCESSING,
                                ORDER_STATUS_SHIPPED,
                                ORDER_STATUS_DELIVERED,
                                ORDER_STATUS_CANCELLED
                              ],
                              displayItem: (val) => val,
                              onChanged: (newValue) {
                                if (newValue == ORDER_STATUS_ALL) {
                                  context.dataProvider.filterOrders('');
                                } else if (newValue != null) {
                                  context.dataProvider.filterOrders(newValue);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select status';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Gap(40),
                          IconButton(
                              onPressed: () {
                                context.dataProvider
                                    .getAllOrders(showSnack: true);
                              },
                              icon: const Icon(Icons.refresh)),
                        ],
                      ),
                      const Gap(defaultPadding),
                      const OrderListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
