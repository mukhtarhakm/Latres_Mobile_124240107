import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/session_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Text(
              'Profil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFF424242),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Text(
                      session.username.value ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Kesan: Seru banget praktikumnya! Belajar banyak dari mas-mas asisten, terutama seni mengamati, meniru, dan memodifikasi kodingan (alias copas elegan).',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const Text(
                    'Pesan: Sehat terus mas-mas asisten! Makasih udah sabar ngadepin error kami. Semoga dimudahkan TA-nya, dilancarkan revisinya, dan lulus tepat waktu (jangan lupa nilai A-nya ya mas!).',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        try {
                          await session.logout();
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal logout')),
                            );
                          }
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
