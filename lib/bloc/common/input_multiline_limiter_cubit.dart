import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'input_multiline_limiter_state.dart';

class InputMultilineLimiterCubit extends Cubit<InputMultilineLimiterChanged> {
  InputMultilineLimiterCubit() : super(InputMultilineLimiterChanged(""));

  void record(String text) => emit(InputMultilineLimiterChanged(text));
}
