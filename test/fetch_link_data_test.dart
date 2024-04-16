import 'package:fetch_link_data/fetch_link_data.dart';
import 'package:test/test.dart';

void main() {
  group('Test Fetch Link Data Functionality', () {
    test('Fetch Link Data', () async {
      final linkData = await FetchLinkData.fetchLinkData(
          'https://books.rakuten.co.jp/rb/17315128/');
      expect(
        linkData.title,
        'コスパで考える学歴攻略法　（新潮新書）',
      );
    });
  });
}
