import 'package:flutter/material.dart';

import 'models/task.dart';
import 'services/task_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TaskFilter { all, active, completed }

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDark') ?? false;
      setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
    } catch (_) {
      // ignore: avoid_print
      print('Failed to load theme preference');
    }
  }

  // Simple toggle: switch between light and dark when called and persist choice.
  void _toggleTheme() {
    setState(() => _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    SharedPreferences.getInstance().then((prefs) => prefs.setBool('isDark', _themeMode == ThemeMode.dark));
  }

  @override
  Widget build(BuildContext context) {
    // Modern Material 3 theming with a seed color and refined components
  const seed = Color(0xFF00BFA5); // teal-ish accent
  final lightScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
  final darkScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);

  // vibrant accents to make the app colorful
  const primaryColor = Color(0xFF06B6D4); // cyan
  const secondaryColor = Color(0xFFFFB020); // amber
  const tertiaryColor = Color(0xFFEF476F); // pink/red

  final vibrantLight = lightScheme.copyWith(primary: primaryColor, secondary: secondaryColor, tertiary: tertiaryColor);
  final vibrantDark = darkScheme.copyWith(primary: primaryColor, secondary: secondaryColor, tertiary: tertiaryColor);

    final lightTheme = ThemeData.from(colorScheme: vibrantLight, useMaterial3: true).copyWith(
      scaffoldBackgroundColor: vibrantLight.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: vibrantLight.primary,
        elevation: 0,
        foregroundColor: vibrantLight.onPrimary,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: vibrantLight.onPrimary),
        iconTheme: IconThemeData(color: vibrantLight.onPrimary),
      ),
      // cardTheme intentionally omitted to configure per-card in the list for precise control
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: lightScheme.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: vibrantLight.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: vibrantLight.tertiary,
        foregroundColor: vibrantLight.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodySmall: ThemeData.light().textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
    );

    final darkTheme = ThemeData.from(colorScheme: vibrantDark, useMaterial3: true).copyWith(
      scaffoldBackgroundColor: vibrantDark.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: vibrantDark.primary,
        elevation: 0,
        foregroundColor: vibrantDark.onPrimary,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: vibrantDark.onPrimary),
        iconTheme: IconThemeData(color: vibrantDark.onPrimary),
      ),
      // cardTheme intentionally omitted to configure per-card in the list for precise control
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: darkScheme.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: vibrantDark.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: vibrantDark.tertiary,
        foregroundColor: vibrantDark.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodySmall: ThemeData.dark().textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
    );
    // Return the app and show the landing page first
    return MaterialApp(
      title: 'MiniTask',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: LandingPage(themeMode: _themeMode, onToggleTheme: _toggleTheme),
    );
  }
}

class LandingPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  const LandingPage({super.key, required this.themeMode, required this.onToggleTheme});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TasksPage(themeMode: widget.themeMode, onToggleTheme: widget.onToggleTheme)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 84,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'MiniTask',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text('A lightweight task manager for quick lists and reminders.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
                Text('Opening...', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TasksPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const TasksPage({super.key, required this.themeMode, required this.onToggleTheme});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskStorage _storage = TaskStorage();
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isSearching = false;
  String _searchQuery = '';
  // selection for multi-delete
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _storage.loadTasks();
    setState(() => _tasks = list);
  }

  Future<void> _save() async => _storage.saveTasks(_tasks);

  List<Task> get _visibleTasks {
    List<Task> base;
    switch (_filter) {
      case TaskFilter.active:
        base = _tasks.where((t) => !t.completed).toList();
        break;
      case TaskFilter.completed:
        base = _tasks.where((t) => t.completed).toList();
        break;
      case TaskFilter.all:
        base = _tasks;
        break;
    }

    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((t) => t.title.toLowerCase().contains(q)).toList();
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = months[d.month - 1];
    return '$m ${d.day}, ${d.year}';
  }

  Future<void> _addOrEditTask({Task? task}) async {
    final isNew = task == null;
    final titleCtl = TextEditingController(text: task?.title ?? '');
    DateTime? due = task?.dueDate;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
        return AlertDialog(
          title: Text(isNew ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtl, decoration: const InputDecoration(labelText: 'Title'), autofocus: true),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Text(due == null ? 'No due date' : 'Due: ${_formatDate(due!)}', style: Theme.of(ctx).textTheme.bodySmall)),
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: due ?? now,
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: DateTime(2100),
                      selectableDayPredicate: (day) {
                        final today = DateTime(now.year, now.month, now.day);
                        final d = DateTime(day.year, day.month, day.day);
                        return !d.isBefore(today);
                      },
                    );
                    if (picked != null) setDialogState(() => due = picked);
                  },
                  child: const Text('Pick date'),
                )
              ])
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final text = titleCtl.text.trim();
                if (text.isEmpty) {
                  // require a title
                  showDialog<void>(context: ctx, builder: (dctx) {
                    return AlertDialog(
                      title: const Text('Missing title'),
                      content: const Text('Please enter a title for the task.'),
                      actions: [TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('OK'))],
                    );
                  });
                  return;
                }

                if (due == null) {
                  // require a due date
                  showDialog<void>(context: ctx, builder: (dctx) {
                    return AlertDialog(
                      title: const Text('Missing due date'),
                      content: const Text('Please pick a due date for the task. Due date is required.'),
                      actions: [TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('OK'))],
                    );
                  });
                  return;
                }

                // Duplicate-title check (case-insensitive). If editing, exclude the current task id.
        final existingId = task?.id ?? '';
        final duplicate = isNew
          ? _tasks.any((e) => e.title.trim().toLowerCase() == text.toLowerCase())
          : _tasks.any((e) => e.title.trim().toLowerCase() == text.toLowerCase() && e.id != existingId);
                if (duplicate) {
                  // show a pop-up asking the user to change the name before saving
                  showDialog<void>(context: ctx, builder: (dctx) {
                    return AlertDialog(
                      title: const Text('Duplicate task name'),
                      content: const Text('A task with this name already exists. Please choose a different name before saving.'),
                      actions: [TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('OK'))],
                    );
                  });
                  return;
                }

                if (isNew) {
                  final t = Task(id: DateTime.now().millisecondsSinceEpoch.toString(), title: text, completed: false, dueDate: due);
                  setState(() => _tasks.insert(0, t));
                  _save();
                  // notify user
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added'), duration: Duration(seconds: 2)));
                } else {
                  // update existing task and trigger UI rebuild
                  final current = task;
                  final idx = _tasks.indexWhere((e) => e.id == current.id);
                  if (idx != -1) {
                    setState(() => _tasks[idx] = _tasks[idx].copyWith(title: text, dueDate: due));
                    _save();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task updated'), duration: Duration(seconds: 2)));
                  }
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            )
          ],
        );
      }),
    );
  }

  void _deleteTask(Task t) {
    setState(() => _tasks.removeWhere((e) => e.id == t.id));
    _save();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted'), duration: Duration(seconds: 2)));
  }

  void _toggleCompleted(Task t, bool? v) {
    final idx = _tasks.indexWhere((e) => e.id == t.id);
    if (idx == -1) return;
    setState(() => _tasks[idx] = _tasks[idx].copyWith(completed: v ?? false));
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  final titleStyle = theme.textTheme.titleMedium;
  // Use a smaller bodySmall style for the due-date and match its color to the title
  final subtitleStyle = theme.textTheme.bodySmall?.copyWith(color: titleStyle?.color);

  final now = DateTime.now();

    // dueColor helper removed (no per-task color dot shown any more)

    return Scaffold(
      appBar: AppBar(
        title: _selected.isNotEmpty
            ? const SizedBox.shrink()
            : (_isSearching
                ? TextField(decoration: const InputDecoration(hintText: 'Search tasks', border: InputBorder.none), onChanged: (v) => setState(() => _searchQuery = v))
                : const Text('Tasks')),
        actions: _selected.isNotEmpty
            ? [
                IconButton(
                  tooltip: 'Mark selected complete',
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {
                    setState(() {
                      for (var i = 0; i < _tasks.length; i++) {
                        if (_selected.contains(_tasks[i].id)) _tasks[i] = _tasks[i].copyWith(completed: true);
                      }
                      _save();
                      _selected.clear();
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Mark selected incomplete',
                  icon: const Icon(Icons.radio_button_unchecked),
                  onPressed: () {
                    setState(() {
                      for (var i = 0; i < _tasks.length; i++) {
                        if (_selected.contains(_tasks[i].id)) _tasks[i] = _tasks[i].copyWith(completed: false);
                      }
                      _save();
                      _selected.clear();
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Delete selected',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      _tasks.removeWhere((t) => _selected.contains(t.id));
                      _selected.clear();
                      _save();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selected tasks deleted'), duration: Duration(seconds: 2)));
                  },
                ),
              ]
            : [
                IconButton(icon: Icon(_isSearching ? Icons.close : Icons.search), onPressed: () => setState(() { if (_isSearching) _searchQuery = ''; _isSearching = !_isSearching; })),
                // Filter button with label (opens a popup menu)
                PopupMenuButton<TaskFilter>(
                  tooltip: 'Filter tasks',
                  onSelected: (f) => setState(() => _filter = f),
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: TaskFilter.all,
                      child: Row(children: [
                        if (_filter == TaskFilter.all)
                          Icon(Icons.check, size: 18, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        const Text('All')
                      ]),
                    ),
                    PopupMenuItem(
                      value: TaskFilter.active,
                      child: Row(children: [
                        if (_filter == TaskFilter.active)
                          Icon(Icons.check, size: 18, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        const Text('Active')
                      ]),
                    ),
                    PopupMenuItem(
                      value: TaskFilter.completed,
                      child: Row(children: [
                        if (_filter == TaskFilter.completed)
                          Icon(Icons.check, size: 18, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        const Text('Completed')
                      ]),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.transparent),
                    child: Row(children: [const Icon(Icons.filter_list), const SizedBox(width: 6), const Text('Filter')]),
                  ),
                ),
                // theme toggle moved to a bottom corner button
              ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_selected.isNotEmpty)
                // selection header uses the primary AppBar color and no elevation so there's no visible divider line
                Container(
                  color: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            final visible = _visibleTasks;
                            if (visible.isNotEmpty && _selected.length == visible.length) {
                              _selected.clear();
                            } else {
                              _selected.addAll(visible.map((t) => t.id));
                            }
                          });
                        },
                        style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary),
                        child: const Text('Select All'),
                      ),
                      const Spacer(),
                      Text('${_selected.length} selected', style: TextStyle(color: theme.colorScheme.onPrimary)),
                      const SizedBox(width: 8),
                      TextButton(onPressed: () => setState(() => _selected.clear()), child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onPrimary))),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _visibleTasks.length,
                  itemBuilder: (context, i) {
          final t = _visibleTasks[i];
          final selected = _selected.contains(t.id);
          // precompute day difference between due date and today (normalized to dates)
          final int? daysDiffVar = t.dueDate == null
            ? null
            : DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day)
              .difference(DateTime(now.year, now.month, now.day))
              .inDays;
                    return Dismissible(
                      key: ValueKey(t.id),
                      background: Container(color: theme.colorScheme.error, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteTask(t),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        // stronger selected visual using primaryContainer for clearer contrast
                        color: selected ? theme.colorScheme.primaryContainer : null,
                        child: ListTile(
                          onLongPress: () => setState(() {
                            if (selected) {
                              _selected.remove(t.id);
                            } else {
                              _selected.add(t.id);
                            }
                          }),
                          leading: _selected.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => setState(() => selected ? _selected.remove(t.id) : _selected.add(t.id)),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: selected ? theme.colorScheme.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: selected ? null : Border.all(color: theme.colorScheme.onSurface.withAlpha((0.12 * 255).round())),
                                    ),
                                    child: Center(
                                      child: selected ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary) : const SizedBox.shrink(),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                            width: 28,
                                            child: Checkbox(
                                              value: t.completed,
                                              onChanged: (v) => _toggleCompleted(t, v),
                                              activeColor: Theme.of(context).colorScheme.primary,
                                              shape: const CircleBorder(),
                                            ),
                                          ),
                          title: Text(
                            t.title,
                            style: titleStyle?.copyWith(decoration: t.completed ? TextDecoration.lineThrough : null),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          subtitle: t.dueDate == null
                              ? (t.completed
                                  ? null
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())),
                                          const SizedBox(width: 6),
                                          IconButton(
                                            tooltip: 'Set due',
                                            onPressed: () async {
                                              final now = DateTime.now();
                                              final picked = await showDatePicker(
                                                context: context,
                                                initialDate: now,
                                                firstDate: DateTime(now.year, now.month, now.day),
                                                lastDate: DateTime(2100),
                                                selectableDayPredicate: (day) {
                                                  final today = DateTime(now.year, now.month, now.day);
                                                  final d = DateTime(day.year, day.month, day.day);
                                                  return !d.isBefore(today);
                                                },
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  final idx = _tasks.indexWhere((e) => e.id == t.id);
                                                  if (idx != -1) _tasks[idx] = _tasks[idx].copyWith(dueDate: picked);
                                                  _save();
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.add, size: 18, color: theme.colorScheme.onSurface),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                          ),
                                        ],
                                      ),
                                    ))
                              : Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
                                        child: Text(
                                          'Due: ${_formatDate(t.dueDate!)}',
                                          style: subtitleStyle?.copyWith(color: theme.colorScheme.onSurface),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      // show overdue or 1-day warning based on precomputed daysDiffVar
                                      if (!t.completed && daysDiffVar != null && daysDiffVar < 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.error.withAlpha((0.12 * 255).round()),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.error_outline, size: 14, color: theme.colorScheme.error),
                                              const SizedBox(width: 6),
                                              Text('Overdue', style: subtitleStyle?.copyWith(color: theme.colorScheme.error, fontSize: 11)),
                                            ],
                                          ),
                                        )
                                      else if (!t.completed && daysDiffVar != null && daysDiffVar == 1)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.error.withAlpha((0.12 * 255).round()),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text('1 day left', style: subtitleStyle?.copyWith(color: theme.colorScheme.error, fontSize: 11)),
                                        ),
                                    ],
                                  ),
                                ),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            // hide per-item edit & delete buttons when selecting
                            if (_selected.isEmpty) IconButton(onPressed: () => _addOrEditTask(task: t), icon: const Icon(Icons.edit)),
                            if (_selected.isEmpty) IconButton(onPressed: () => _deleteTask(t), icon: const Icon(Icons.delete_outline)),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Small theme toggle in bottom-left corner
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              onPressed: widget.onToggleTheme,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Icon(
                  widget.themeMode == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny,
                  key: ValueKey<bool>(widget.themeMode == ThemeMode.dark),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditTask(),
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
