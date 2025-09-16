import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';

import '../../catalog/stores/catalog.store.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  _PosPageState createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final catalogStore = GetIt.I<CatalogStore>();
  bool _expanded = false;
  int? _selectedCategoryIndex;
  final List<String> _categories =
      List.generate(20, (index) => 'Categoria ${index + 1}');

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final int crossAxisCount = MediaQuery.of(context).size.width ~/ 120;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Criando pedido'),
            )
          : null,
      body: Column(
        children: [
          if (isMobile)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Criando pedido'),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Row(
                      children: [
                        Icon(Icons.filter_list),
                        Text('Filtrar'),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          if (isMobile)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategoryIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryIndex = selected ? index : null;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final itemWidth = maxWidth / 6 - 16;
                return Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildCategoryChips(
                      _expanded ? _categories.length : 11, itemWidth),
                );
              },
            ),
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              children: List.generate(
                  20,
                  (index) => Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image, size: 40),
                            const SizedBox(height: 8),
                            Text('Item ${index + 1}'),
                          ],
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryChips(int count, double itemWidth) {
    final List<Widget> chips = [];
    final int displayCount =
        count > _categories.length ? _categories.length : count;

    for (int i = 0; i < displayCount; i++) {
      chips.add(
        SizedBox(
          width: itemWidth,
          child: ChoiceChip(
            label: SizedBox(
              width: double.infinity,
              child: Text(
                _categories[i],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            selected: _selectedCategoryIndex == i,
            onSelected: (selected) {
              setState(() {
                _selectedCategoryIndex = selected ? i : null;
              });
            },
          ),
        ),
      );
    }

    if (_categories.length > 11) {
      chips.add(
        SizedBox(
          width: itemWidth,
          child: ChoiceChip(
            label: SizedBox(
              width: double.infinity,
              child: Text(
                _expanded ? 'Ver menos' : 'Ver mais',
                textAlign: TextAlign.center,
              ),
            ),
            selected: false,
            onSelected: (selected) {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
      );
    }

    return chips;
  }
}
