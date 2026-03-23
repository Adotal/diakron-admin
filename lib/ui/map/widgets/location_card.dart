import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final Map<String, int>? stats;
  final bool isConnected;
  final String? avatarUrl;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.address,
    this.stats,
    required this.isConnected,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isConnected ? AppColors.greenDiakron1 : Colors.red;
    final statusText = isConnected ? "Operativo" : "Sin conexión";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Data
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: avatarUrl != null
                          ? Image.network(avatarUrl!, fit: BoxFit.cover)
                          : const Icon(Icons.location_on, size: 28, color: Colors.grey),
                    ),
                    const SizedBox(width: 15),
                    
                    // Stats Address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: stats?.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  "•${entry.value}% ${entry.key}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            }).toList() ?? [],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              
              // Status bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}