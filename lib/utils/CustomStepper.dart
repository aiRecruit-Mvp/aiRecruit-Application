import 'package:airecruit/utils/globalColors.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final Color activeColor;
  final Color inactiveColor;
  final Color activeStepTextColor;
  final Color inactiveStepTextColor;
  final Color activeControlColor;
  final Color inactiveControlColor;
  final double lineThickness;
  final double activeStepElevation;
  final double inactiveStepElevation;
  final int currentStep;
  final void Function(int)? onStepTapped;
  final List<Step> steps;

  const CustomStepper({
    required this.activeColor,
    required this.inactiveColor,
    this.activeStepTextColor = GlobalColors.secondaryColor,
    this.inactiveStepTextColor = Colors.white,
    this.activeControlColor = GlobalColors.buttonColor,
    this.inactiveControlColor = Colors.grey,
    this.lineThickness = 1.0,
    this.activeStepElevation = 4.0,
    this.inactiveStepElevation = 2.0,
    required this.currentStep,
    required this.onStepTapped,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // Disable default step styling to use custom colors
        visualDensity: VisualDensity.compact,
      ),
      child: Row(
        children: List.from(steps).map((step) {
          final bool isActive = currentStep == steps.indexOf(step);
          final bool isLast = steps.lastIndexOf(step) == steps.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onStepTapped?.call(steps.indexOf(step)),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    // Step title
                    Text(
                      step.title is Text
                          ? (step.title as Text).data!
                          : '', // Replace with this line
                      style: TextStyle(
                        color: isActive
                            ? activeStepTextColor
                            : inactiveStepTextColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8.0),
                    // Step content (if available)
                    if (step.content != null) step.content!,
                    const SizedBox(height: 8.0),
                    // Line between steps
                    if (!isLast)
                      Container(
                        height: lineThickness,
                        color: isActive ? activeColor : inactiveColor,
                      ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2.0,
                        blurRadius: 4.0,
                        offset: const Offset(0, 2.0),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
