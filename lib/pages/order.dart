import 'package:flutter/material.dart';

final List<Map<String, dynamic>> dummyOrders = [
  {
    'id': 32053,
    'category': 'Breakfast',
    'title': 'Chicken Thai Biriyani',
    'price': 60,
    'imageUrl': 'assets/image/orders/chicken_thai_biriyani.jpg',
    'status': 'pending',
  },
  {
    'id': 32054,
    'category': 'Lunch',
    'title': 'Beef Burger with Fries',
    'price': 45,
    'imageUrl': 'assets/image/orders/beef_burger_fries.jpg',
    'status': 'pending',
  },
];

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final List<Map<String, dynamic>> _orders = dummyOrders
      .map((order) => Map<String, dynamic>.from(order))
      .toList();

  void _updateOrderStatus(int index, String status) {
    setState(() {
      _orders[index]['status'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF7),
        foregroundColor: const Color(0xFF252A34),
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                '${_orders.length} orders',
                style: TextStyle(color: Colors.blueGrey[500], fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 16, 16),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFF6CA8FF), width: 1),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
              itemCount: _orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return _OrderTile(
                  order: order,
                  onStatusChanged: (status) =>
                      _updateOrderStatus(index, status),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.onStatusChanged});

  final Map<String, dynamic> order;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;

    Widget price(bool compact) => Text(
      '\$${order['price']}',
      style: TextStyle(
        color: const Color(0xFF30343B),
        fontSize: compact ? 18 : 20,
        fontWeight: FontWeight.w500,
      ),
    );

    Widget actions(bool compact) {
      if (status != 'pending') {
        return _OrderStatus(status: status);
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OrderActionButton(
            label: 'Done',
            filled: true,
            compact: compact,
            onPressed: () => onStatusChanged('done'),
          ),
          SizedBox(width: compact ? 6 : 8),
          _OrderActionButton(
            label: 'Cancel',
            filled: false,
            compact: compact,
            onPressed: () => onStatusChanged('cancelled'),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final imageSize = compact ? 88.0 : 112.0;

        return SizedBox(
          height: compact ? 144 : 128,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(compact ? 16 : 20),
                child: Image.asset(
                  order['imageUrl'] as String,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: imageSize,
                    height: imageSize,
                    color: const Color(0xFFFFE6D6),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.deepOrange,
                      size: 36,
                    ),
                  ),
                ),
              ),
              SizedBox(width: compact ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order['category']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFE58B76),
                        fontSize: compact ? 13 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      order['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF30343B),
                        fontSize: compact ? 14 : 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'ID: ${order['id']}',
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    if (compact)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [price(compact), const Spacer()]),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: actions(compact),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(child: price(compact)),
                          actions(compact),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton({
    required this.label,
    required this.filled,
    required this.compact,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = filled ? const Color(0xFFFF7925) : const Color(0xFFFF594F);

    return SizedBox(
      height: 40,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(label, style: TextStyle(fontSize: compact ? 12 : 14)),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color, width: 1.4),
                minimumSize: const Size(0, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(label, style: TextStyle(fontSize: compact ? 12 : 14)),
            ),
    );
  }
}

class _OrderStatus extends StatelessWidget {
  const _OrderStatus({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final completed = status == 'done';
    final color = completed ? const Color(0xFF27845A) : const Color(0xFFD94B45);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        completed ? 'Done' : 'Cancelled',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
