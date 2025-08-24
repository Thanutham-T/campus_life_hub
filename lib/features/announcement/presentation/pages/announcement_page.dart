import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/announcement_bloc.dart';
import '../bloc/announcement_event.dart';
import '../bloc/announcement_state.dart';
import '../widgets/improved_announcement_card.dart';
import 'announcement_detail_page.dart';
import 'create_announcement_page.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_state.dart';

class AnnouncementPage extends StatefulWidget {
  final bool showBackButton;
  final bool showBottomNav;
  
  const AnnouncementPage({
    super.key,
    this.showBackButton = false,
    this.showBottomNav = false,
  });

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> categories = ['ทั้งหมด', 'วิชาการ', 'กิจกรรม', 'ทั่วไป'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<AnnouncementBloc>().add(const LoadAnnouncements());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: widget.showBackButton,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'ข่าวประกาศ'),
            Tab(text: 'ที่บันทึกไว้'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnnouncementsList(),
          _buildBookmarkedList(),
        ],
      ),
      floatingActionButton: _buildAdminFAB(),
    );
  }

  Widget _buildAnnouncementsList() {
    return Column(
      children: [
        // Search bar and filter
        Container(
          color: const Color(0xFF1976D2),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหาข่าวประกาศ...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (query) {
                    context.read<AnnouncementBloc>()
                        .add(SearchAnnouncements(query));
                  },
                ),
              ),
              const SizedBox(height: 12),
              
              // Category filter
              BlocBuilder<AnnouncementBloc, AnnouncementState>(
                builder: (context, state) {
                  final selectedCategory = state is AnnouncementLoaded
                      ? state.selectedCategory
                      : 'ทั้งหมด';
                      
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF1976D2),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              context.read<AnnouncementBloc>()
                                  .add(FilterAnnouncementsByCategory(category));
                            },
                            selectedColor: const Color(0xFF1565C0),
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.white,
                            side: const BorderSide(color: Colors.transparent),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        // Announcements list
        Expanded(
          child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
            builder: (context, state) {
              if (state is AnnouncementLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1976D2),
                  ),
                );
              }
              
              if (state is AnnouncementError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AnnouncementBloc>()
                              .add(const RefreshAnnouncements());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('ลองใหม่'),
                      ),
                    ],
                  ),
                );
              }
              
              if (state is AnnouncementLoaded) {
                final announcements = state.filteredAnnouncements;
                
                if (announcements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.announcement_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.searchQuery.isNotEmpty
                              ? 'ไม่พบข่าวประกาศที่ตรงกับการค้นหา'
                              : 'ไม่มีข่าวประกาศในหมวดหมู่นี้',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnnouncementBloc>()
                        .add(const RefreshAnnouncements());
                  },
                  color: const Color(0xFF1976D2),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      final isBookmarked = state.bookmarkedIds
                          .contains(announcement.id);
                      
                      return ImprovedAnnouncementCard(
                        announcement: announcement,
                        isBookmarked: isBookmarked,
                        onTap: () {
                          // Debug: Print announcement ID
                          print('Tapped announcement with ID: "${announcement.id}"');
                          
                          // Mark as read when tapped (only if ID is not empty)
                          if (!announcement.isRead && announcement.id.isNotEmpty) {
                            context.read<AnnouncementBloc>()
                                .add(MarkAsRead(announcement.id));
                          } else if (announcement.id.isEmpty) {
                            print('Warning: Announcement has empty ID, skipping mark as read');
                          }
                          
                          // Navigate to detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnouncementDetailPage(
                                announcement: announcement,
                              ),
                            ),
                          );
                        },
                        onBookmarkTap: () {
                          context.read<AnnouncementBloc>()
                              .add(ToggleBookmark(announcement.id));
                        },
                      );
                    },
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkedList() {
    return BlocBuilder<AnnouncementBloc, AnnouncementState>(
      builder: (context, state) {
        if (state is AnnouncementLoaded) {
          final bookmarkedAnnouncements = state.announcements
              .where((announcement) => state.bookmarkedIds.contains(announcement.id))
              .toList();
          
          if (bookmarkedAnnouncements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีข่าวประกาศที่บันทึกไว้',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'แตะไอคอนบุ๊กมาร์กเพื่อบันทึกข่าวประกาศที่สำคัญ',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bookmarkedAnnouncements.length,
            itemBuilder: (context, index) {
              final announcement = bookmarkedAnnouncements[index];
              
              return ImprovedAnnouncementCard(
                announcement: announcement,
                isBookmarked: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementDetailPage(
                        announcement: announcement,
                      ),
                    ),
                  );
                },
                onBookmarkTap: () {
                  context.read<AnnouncementBloc>()
                      .add(ToggleBookmark(announcement.id));
                },
              );
            },
          );
        }
        
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1976D2),
          ),
        );
      },
    );
  }

  Widget? _buildAdminFAB() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // ตรวจสอบว่าผู้ใช้เป็น admin หรือไม่
        if (authState is! AuthAuthenticated || !authState.profile.isAdmin) {
          return const SizedBox.shrink();
        }
        
        return FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateAnnouncementPage(),
              ),
            );
            
            // ถ้าสร้างประกาศสำเร็จ ให้ refresh ข้อมูล
            if (result == true && mounted) {
              context.read<AnnouncementBloc>().add(const RefreshAnnouncements());
            }
          },
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text(
            'สร้างประกาศ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
