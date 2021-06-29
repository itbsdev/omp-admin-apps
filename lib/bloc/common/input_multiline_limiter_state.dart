part of 'input_multiline_limiter_cubit.dart';

abstract class InputMultilineLimiterState extends Equatable {
  final String recordedText;
  const InputMultilineLimiterState(this.recordedText);

  @override
  List<Object> get props => [recordedText];
}

class InputMultilineLimiterChanged extends InputMultilineLimiterState {
  InputMultilineLimiterChanged(String recordedText): super(recordedText);

}
