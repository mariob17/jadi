import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studytracker/main.dart';

void main() {
  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const StudyTrackerApp());
    await tester.pumpAndSettle();
  }

  testWidgets('menampilkan halaman utama dan tugas contoh', (tester) async {
    await openApp(tester);

    expect(find.text('StudyTracker'), findsOneWidget);
    expect(find.text('Baca materi Pemrograman Perangkat Bergerak'),
        findsOneWidget);
  });

  testWidgets('validasi menolak judul tugas kosong', (tester) async {
    await openApp(tester);
    await tester.tap(find.byKey(const Key('add-task')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan tugas'));
    await tester.pumpAndSettle();

    expect(find.text('Nama tugas wajib diisi.'), findsOneWidget);
    expect(find.text('StudyTracker'), findsNothing);
  });

  testWidgets('menambah, mengedit, memfilter, menandai, dan menghapus tugas',
      (tester) async {
    await openApp(tester);
    await tester.tap(find.byKey(const Key('add-task')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('task-title')), 'Tugas UTS');
    await tester.tap(find.text('Simpan tugas'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas UTS'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit tugas').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('task-title')), 'Tugas UTS Baru');
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas UTS Baru'), findsOneWidget);

    await tester.tap(find.byKey(const Key('complete-sample-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('filter-completed')));
    await tester.pumpAndSettle();
    expect(find.text('Baca materi Pemrograman Perangkat Bergerak'),
        findsOneWidget);
    expect(find.text('Tugas UTS Baru'), findsNothing);

    await tester.tap(find.byKey(const Key('filter-all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete-sample-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus').last);
    await tester.pumpAndSettle();
    expect(find.text('Baca materi Pemrograman Perangkat Bergerak'),
        findsNothing);
  });
}
