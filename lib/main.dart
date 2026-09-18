import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MarketplaceApp());
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marketplace CI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String imageUrl;

  const Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Numéro WhatsApp ivoirien fictif pour le MVP.
  // Format international : 225 + numéro sans le 0.
  static const String whatsappNumber = '2250700000000';

  static const List<Product> products = [
    Product(
      name: 'Smartphone Samsung',
      price: 85000,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    ),
    Product(
      name: 'Chaussures Nike',
      price: 30000,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    ),
    Product(
      name: 'Sac à dos moderne',
      price: 18000,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
    ),
  ];

  Future<void> acheter(Product product) async {
    final message =
        'Bonjour, je veux commander le produit ${product.name} '
        'au prix de ${product.price} CFA';

    final encodedMessage = Uri.encodeComponent(message);

    final whatsappUrl = Uri.parse(
      'https://wa.me/$whatsappNumber?text=$encodedMessage',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Impossible d’ouvrir WhatsApp.');
    }
  }

  String formatPrice(int price) {
    return '${price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)} ',
        )}CFA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Marketplace CI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo du produit
                Image.network(
                  product.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Prix
                      Text(
                        formatPrice(product.price),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Bouton Acheter
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => acheter(product),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text(
                            'Acheter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
