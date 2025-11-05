import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/contract_service.dart';

class ContractBalanceCard extends StatelessWidget {
  final VoidCallback onDonate;
  final VoidCallback onViewExplorer;

  const ContractBalanceCard({
    super.key,
    required this.onDonate,
    required this.onViewExplorer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1f2d53),
            Color(0xFF162447),
            Color(0xFF101c39),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF121a33).withOpacity(0.45),
            blurRadius: 60,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient lighting effects
          Positioned(
            top: -60,
            right: 0,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7086ff).withOpacity(0.25),
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10b981).withOpacity(0.2),
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL FUNDS LOCKED',
                          style: TextStyle(
                            color: Colors.blue[200]?.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer<ContractService>(
                          builder: (context, contractService, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF89a2ff),
                                  Color(0xFF8f85ff),
                                  Color(0xFFaf7dff),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                '${contractService.contractBalance} ETH',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // USD estimate
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'USD estimate',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Consumer<ContractService>(
                          builder: (context, contractService, child) {
                            return Text(
                              '\$${contractService.usdEstimate}',
                              style: TextStyle(
                                color: Colors.green[200],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                        Text(
                          '+12.5% this quarter',
                          style: TextStyle(
                            color: Colors.green[200]?.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Chart
              _buildChart(),
              
              const SizedBox(height: 24),
              
              // Time range buttons
              _buildTimeRangeButtons(),
              
              const SizedBox(height: 24),
              
              // Performance indicator
              _buildPerformanceIndicator(),
              
              const SizedBox(height: 24),
              
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 96,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF10b981).withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Chart bars
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [55, 48, 62, 70, 90, 110, 100, 130, 125, 135, 150, 160]
                  .map((value) => Container(
                        width: 8,
                        height: (value / 160 * 60).clamp(10, 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF22d1a0),
                              Color(0xFF9ef5d7),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // Lifetime donations label
          Positioned(
            top: 8,
            right: 8,
            child: Consumer<ContractService>(
              builder: (context, contractService, child) {
                return Text(
                  'Lifetime donations ${contractService.lifetimeDonations} ETH',
                  style: TextStyle(
                    color: Colors.green[100]?.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButtons() {
    final timeRanges = ['1D', '1W', '1M', '3M', '6M', '1Y'];
    final selectedRange = '6M';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: timeRanges.map((range) {
        final isSelected = range == selectedRange;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.1),
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ] : null,
          ),
          child: Text(
            range,
            style: TextStyle(
              color: isSelected 
                  ? const Color(0xFF101c39) 
                  : Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.green[200],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Performance +12.5%',
                style: TextStyle(
                  color: Colors.green[200],
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle live ledger tap
            },
            child: Row(
              children: [
                Icon(
                  Icons.visibility,
                  color: Colors.blue[200],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Live ledger',
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Donate button
        Expanded(
          child: GestureDetector(
            onTap: onDonate,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6370ff),
                    Color(0xFF8a57ff),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6370ff).withOpacity(0.4),
                    blurRadius: 45,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Donate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Explorer button
        Expanded(
          child: GestureDetector(
            onTap: onViewExplorer,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.open_in_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Audit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}