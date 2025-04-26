import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/connectivity.provider.dart';
import '../../views/network_error.screen.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        if (connectivityProvider.isConnected) {
          return child;
        } else {
          return NetworkErrorScreen(
            onRetry: () async {
              // Force a connectivity check when the user taps retry
              final connectivityProvider = Provider.of<ConnectivityProvider>(
                context, 
                listen: false
              );
              // This will trigger a rebuild if the connection state changes
              await connectivityProvider.initConnectivity();
            },
          );
        }
      },
    );
  }
} 