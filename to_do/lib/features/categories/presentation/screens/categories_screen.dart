import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/features/categories/domain/entities/categories.dart';
import 'package:to_do/features/categories/presentation/providers/categories_provider.dart';
import 'package:to_do/features/items/presentation/screens/items_screen.dart';
import 'package:to_do/core/database/database_providers.dart';
import 'package:to_do/features/items/domain/entities/items.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8CB9D1), // top
              Color(0xFFD4E7F2), // bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    'assets/icon/Logo.svg',
                    width: 182, // adjust size
                    height: 50,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  "Hello Mate! 👋",
                  style: GoogleFonts.inriaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                // --- Subtitle ---
                Text(
                  "Welcome to YourDay! Here's what's on your plate today.",
                  style: GoogleFonts.inriaSans(
                    fontSize: 16,
                    height: 1.35,
                    color: Color(0xFF565050),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.black.withOpacity(0.18), height: 18),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA1D1C8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Categories:",
                    style: GoogleFonts.inriaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: categoriesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text("Error: $e")),
                    data: (categories) {
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, i) {
                          final c = categories[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: ValueKey(c.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              confirmDismiss: (_) async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete category?'),
                                    content: Text(
                                      'Are you sure you want to delete "${c.name}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldDelete != true) return false;

                                try {
                                  final db = await ref.read(
                                    databaseProvider.future,
                                  );
                                  await db.itemDao.deleteItemsByCategory(c.id);
                                  await db.categoryDao.deleteCategoryById(c.id);
                                  return true;
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Delete failed: $e'),
                                      ),
                                    );
                                  }
                                  return false;
                                }
                              },
                              onDismissed: (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${c.name} deleted')),
                                );
                              },
                              child: CategoryTile(
                                title: c.name,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ItemsScreen(category: c),
                                    ),
                                  );
                                },
                                onEditTap: () {
                                  _showEditCategoryDialog(context, c);
                                },
                              ),
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
      ),

      floatingActionButton: _SquareAddButton(
        onTap: () {
          _showCreateCategoryDialog(context);
        },
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    final controller = TextEditingController();
    final itemInputController = TextEditingController();
    final List<String> items = [];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            void addItem(String value) {
              final v = value.trim();
              if (v.isEmpty) return;

              setDialogState(() {
                items.add(v);
                itemInputController.clear();
              });
            }

            return Dialog(
              backgroundColor: const Color(0xFF80ABC2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Category",
                      style: GoogleFonts.inriaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.black.withOpacity(0.25), height: 16),

                    const SizedBox(height: 10),
                    Text(
                      "Category Name:",
                      style: GoogleFonts.inriaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Category input
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.list, color: Colors.black54),
                          hintText: "e.g. Groceries, Work, Study",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Text(
                      "Items:",
                      style: GoogleFonts.inriaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Items box
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: items.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.radio_button_unchecked,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                items[index],
                                                style: GoogleFonts.inriaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setDialogState(() {
                                                  items.removeAt(index);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.radio_button_unchecked,
                                  size: 18,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: itemInputController,
                                    decoration: InputDecoration(
                                      hintText: 'Add item and press Enter',
                                      hintStyle: GoogleFonts.inriaSans(
                                        color: Colors.grey.shade500,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: addItem,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _DialogButton(
                            text: "Cancel",
                            textColor: Colors.red,
                            background: const Color(0xFFE5E5E5),
                            onTap: () => Navigator.pop(ctx),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _DialogButton(
                            text: "Add Category",
                            textColor: Colors.black,
                            background: const Color(0xFFBFDCCB),
                            onTap: () async {
                              final name = controller.text.trim();

                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Category name is empty"),
                                  ),
                                );
                                return;
                              }

                              final repo = ref.read(categoriesRepoProvider);
                              final db = await ref.read(
                                databaseProvider.future,
                              );

                              final categoryId =
                                  'cat_${DateTime.now().millisecondsSinceEpoch}';

                              await repo.addCategory(
                                Categories(id: categoryId, name: name),
                              );

                              for (final itemTitle in items) {
                                await db.itemDao.addItem(
                                  Items(
                                    id: 'item_${DateTime.now().microsecondsSinceEpoch}_$itemTitle',
                                    categoryId: categoryId,
                                    title: itemTitle,
                                    isDone: false,
                                  ),
                                );
                              }

                              if (mounted) {
                                Navigator.pop(ctx);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, Categories category) {
    final controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new category name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) return;

                final updatedCategory = Categories(
                  id: category.id,
                  name: newName,
                );

                final repo = ref.read(categoriesRepoProvider);
                await repo.updateCategory(updatedCategory);

                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated to "$newName"')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

// ----------------- Widgets -----------------

class CategoryTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFCFE2B2), // light green
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onEditTap,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.menu, color: Colors.black, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareAddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SquareAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 34, color: Colors.black),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color background;
  final VoidCallback onTap;

  const _DialogButton({
    required this.text,
    required this.textColor,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
