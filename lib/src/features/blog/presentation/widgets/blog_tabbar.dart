import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class TopicsTabBar extends StatelessWidget {
  final List<String> allTopics;
  final String selectedTopic;
  final Function(String) onTopicSelected;

  const TopicsTabBar({
    super.key,
    required this.allTopics,
    required this.selectedTopic,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        child: Row(
          children: [
            // Opción "Todos"
            _buildTopicChip(
              label: 'Todos',
              isSelected: selectedTopic.isEmpty,
              onSelected: () => onTopicSelected(''),
            ),
            // Lista de topics
            ...allTopics.map((topic) => _buildTopicChip(
                  label: topic,
                  isSelected: selectedTopic == topic,
                  onSelected: () => onTopicSelected(topic),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorTheme.gradient1 : ColorTheme.textPrimary,
          border: isSelected ? null : Border.all(color: ColorTheme.borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onSelected,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
