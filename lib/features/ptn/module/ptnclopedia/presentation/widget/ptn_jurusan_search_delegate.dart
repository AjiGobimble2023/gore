import 'package:flutter/material.dart';

import '../../../../../../core/config/extensions.dart';
import '../../entity/jurusan.dart';

class JurusanSearchDelegate extends SearchDelegate<Jurusan?> {
  final List<Jurusan> listJurusan;

  JurusanSearchDelegate(this.listJurusan);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = query.isEmpty
        ? listJurusan
        : listJurusan.where((ptn) {
            if (ptn.namaJurusan.toLowerCase().contains(query.toLowerCase())) {
              return true;
            }
            return false;
          }).toList();

    return MediaQuery(
      data:
          MediaQuery.of(context).copyWith(textScaleFactor: context.textScale12),
      child: ListView.separated(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(suggestions[index].namaJurusan),
          subtitle: Text(suggestions[index].kelompok),
          onTap: () {
            close(context, suggestions[index]);
          },
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? listJurusan
        : listJurusan.where((ptn) {
            if (ptn.namaJurusan.toLowerCase().contains(query.toLowerCase())) {
              return true;
            }
            return false;
          }).toList();

    return MediaQuery(
      data:
          MediaQuery.of(context).copyWith(textScaleFactor: context.textScale12),
      child: ListView.separated(
        itemCount: suggestions.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(suggestions[index].namaJurusan),
          subtitle: Text(suggestions[index].kelompok),
          onTap: () {
            close(context, suggestions[index]);
          },
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
