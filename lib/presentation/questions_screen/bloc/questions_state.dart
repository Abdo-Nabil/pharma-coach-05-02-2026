// ignore_for_file: must_be_immutable

part of 'questions_bloc.dart';

/// Represents the state of Questions in the application.
class QuestionsState extends Equatable {
  QuestionsState({
    this.activelisteningController,
    this.positioningBrandBenefitsController,
    this.closingController,
    this.bridgingToNextProductsController,
    this.questionsModelObj,
  });

  TextEditingController? activelisteningController;

  TextEditingController? positioningBrandBenefitsController;

  TextEditingController? closingController;

  TextEditingController? bridgingToNextProductsController;

  QuestionsModel? questionsModelObj;

  @override
  List<Object?> get props => [
        activelisteningController,
        positioningBrandBenefitsController,
        closingController,
        bridgingToNextProductsController,
        questionsModelObj,
      ];

  QuestionsState copyWith({
    TextEditingController? activelisteningController,
    TextEditingController? positioningBrandBenefitsController,
    TextEditingController? closingController,
    TextEditingController? bridgingToNextProductsController,
    QuestionsModel? questionsModelObj,
  }) {
    return QuestionsState(
      activelisteningController:
          activelisteningController ?? this.activelisteningController,
      positioningBrandBenefitsController: positioningBrandBenefitsController ??
          this.positioningBrandBenefitsController,
      closingController: closingController ?? this.closingController,
      bridgingToNextProductsController: bridgingToNextProductsController ??
          this.bridgingToNextProductsController,
      questionsModelObj: questionsModelObj ?? this.questionsModelObj,
    );
  }
}
