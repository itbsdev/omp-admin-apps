part of 'page_changed_cubit.dart';

abstract class PageChangedState extends Equatable {
  final int position;

  const PageChangedState(this.position);

  @override
  List<Object> get props => [position];
}

class PageChangedPosition extends PageChangedState {
  PageChangedPosition(position): super(position);

}
