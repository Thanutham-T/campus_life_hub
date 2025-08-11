import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/study_group.dart';
import '../bloc/study_group_bloc.dart';
import '../bloc/study_group_state.dart';
import '../bloc/study_group_event.dart';
import '../widgets/create_group_dialog.dart';
import 'study_group_chat_page.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import 'package:get_it/get_it.dart';

class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<StudyGroupBloc>().add(GetStudyGroupsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar per request
      body: SafeArea(
        child: Column(
        children: [
          // Search bar and create button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                // Search bar
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหากลุ่มศึกษา...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          context.read<StudyGroupBloc>().add(GetStudyGroupsEvent());
                        } else {
                          context.read<StudyGroupBloc>().add(SearchStudyGroups(value.trim()));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Create group button
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      CreateGroupDialog.show(context);
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 24),
                    tooltip: 'สร้างกลุ่มใหม่',
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Study groups list
          Expanded(
            child: BlocBuilder<StudyGroupBloc, StudyGroupState>(
              builder: (context, state) {
                if (state is StudyGroupLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StudyGroupsLoaded) {
                  if (state.studyGroups.isEmpty) {
                    return const Center(
                      child: Text(
                        'ไม่พบกลุ่มศึกษา',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.studyGroups.length,
                    itemBuilder: (context, index) {
                      final group = state.studyGroups[index];
                      return _buildStudyGroupCard(group);
                    },
                  );
                } else if (state is StudyGroupSearchResults) {
                  if (state.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'ไม่พบผลลัพธ์สำหรับ "${state.query}"',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final group = state.results[index];
                      return _buildStudyGroupCard(group);
                    },
                  );
                } else if (state is StudyGroupError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เกิดข้อผิดพลาด: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<StudyGroupBloc>().add(GetStudyGroupsEvent());
                          },
                          child: const Text('ลองใหม่'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('ไม่มีข้อมูล'));
              },
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildStudyGroupCard(StudyGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Provide ChatBloc for the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => ChatBloc(repository: GetIt.instance())..add(GetChatMessagesEvent(group.id)),
                child: StudyGroupChatPage(
                  studyGroupId: group.id,
                  groupName: group.name,
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'group_title_${group.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(group.category).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.category,
                      style: TextStyle(
                        color: _getCategoryColor(group.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Subject hidden per new requirement
              const SizedBox(height: 4),
              Text(
                group.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Removed location, schedule, and latest message per updated requirement
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'mathematics':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'english':
        return Colors.purple;
      case 'social':
        return Colors.orange;
      case 'art':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
