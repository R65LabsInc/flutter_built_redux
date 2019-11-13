import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;

import 'flutter_built_redux.dart';

class StoreSubConnection<
    StoreState extends Built<StoreState, StoreStateBuilder>,
    StoreStateBuilder extends Builder<StoreState, StoreStateBuilder>,
    StoreActions extends ReduxActions,
    LocalState,
    LocalActions extends ReduxActions> extends StatelessWidget {
  final Connect<StoreState, LocalState> _stateConnection;
  final Connect<StoreActions, LocalActions> _actionConnection;
  final StoreConnectionBuilder<LocalState, LocalActions> builder;

  StoreSubConnection({
    Key key,
    Connect<StoreState, LocalState> stateConnection,
    Connect<StoreActions, LocalActions> actionConnection,
    @required this.builder,
  })  : assert(stateConnection != null || StoreState == LocalState,
            'StoreSubConnection: stateConnection must not be null'),
        assert(actionConnection != null || StoreState == LocalState,
            'StoreSubConnection: actionConnection must not be null'),
        _stateConnection = stateConnection ?? _defaultConnection<StoreState, LocalState>(),
        _actionConnection = actionConnection ?? _defaultConnection<StoreActions, LocalActions>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnection<StoreState, StoreActions, LocalState>(
      connect: _stateConnection,
      builder: (BuildContext context, LocalState state, StoreActions storeActions) {
        final LocalActions actions = _actionConnection(storeActions);
        return this.builder(context, state, actions);
      },
    );
  }

  static Connect<StoreType, LocalType> _defaultConnection<StoreType, LocalType>() {
    if (StoreType == LocalType) {
      return (state) => state as LocalType;
    }
    return null;
  }
}
