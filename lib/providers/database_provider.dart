import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../services/database_service.dart';

/// Provider tunggal untuk Isar instance.
/// Diinisialisasi sekali di main() via override.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError(
    'isarProvider harus di-override di ProviderScope '
    'setelah database dibuka di main().',
  );
});

/// Provider tunggal untuk WatchItemRepository.
final watchItemRepositoryProvider = Provider<WatchItemRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return WatchItemRepository(isar);
});
