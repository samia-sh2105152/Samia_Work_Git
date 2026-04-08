import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/core/database/database_providers.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';
import 'package:to_do/features/items/domain/entities/items.dart';
import 'package:to_do/features/items/presentation/providers/items_provider.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  final Categories category;

  const ItemsScreen({super.key, required this.category});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  void _showAddItemDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter item name'),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) async {
              final title = controller.text.trim();
              if (title.isEmpty) return;

              final db = await ref.read(databaseProvider.future);

              await db.itemDao.addItem(
                Items(
                  id: 'item_${DateTime.now().microsecondsSinceEpoch}',
                  categoryId: widget.category.id,
                  title: title,
                  isDone: false,
                ),
              );

              if (mounted) Navigator.pop(ctx);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final title = controller.text.trim();
                if (title.isEmpty) return;

                final db = await ref.read(databaseProvider.future);

                await db.itemDao.addItem(
                  Items(
                    id: 'item_${DateTime.now().microsecondsSinceEpoch}',
                    categoryId: widget.category.id,
                    title: title,
                    isDone: false,
                  ),
                );

                if (mounted) Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsByCategoryProvider(widget.category.id));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8CB9D1), Color(0xFFD4E7F2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 28),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.category.name,
                          style: GoogleFonts.inriaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Category'),
                            content: Text(
                              'Are you sure you want to delete "${widget.category.name}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true) return;

                        final db = await ref.read(databaseProvider.future);
                        await db.itemDao.deleteItemsByCategory(
                          widget.category.id,
                        );
                        await db.categoryDao.deleteCategoryById(
                          widget.category.id,
                        );

                        if (mounted) {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${widget.category.name} deleted'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.black.withOpacity(0.18), height: 1),

              Expanded(
                child: itemsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                  data: (items) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: _showAddItemDialog,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Add Items....',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final item = items[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final db = await ref.read(
                                    databaseProvider.future,
                                  );

                                  await db.itemDao.updateItem(
                                    Items(
                                      id: item.id,
                                      categoryId: item.categoryId,
                                      title: item.title,
                                      isDone: item.isDone == true
                                          ? false
                                          : true,
                                    ),
                                  );
                                },
                                child: Icon(
                                  item.isDone
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: item.isDone
                                        ? Colors.grey
                                        : Colors.black,
                                    decoration: item.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
