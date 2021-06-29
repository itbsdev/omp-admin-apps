import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_changed_state.dart';

class PageChangedCubit extends Cubit<PageChangedState> {
  PageChangedCubit() : super(PageChangedPosition(0));

  void onPositionChanged(int position) => emit(PageChangedPosition(position));
}
