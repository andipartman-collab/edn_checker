import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),

              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
