import 'package:campus_life_hub/core/widgets/widgets.dart';
import 'package:campus_life_hub/core/constants/constants.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_bloc.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_event.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Fluttertoast.showToast(
            msg: "ออกจากระบบสำเร็จ",
            gravity: ToastGravity.TOP,
          );
          context.go('/login');
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            gravity: ToastGravity.TOP,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Campus Life Hub'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return IconButton(
                  onPressed: isLoading 
                      ? null 
                      : () => _showLogoutDialog(context),
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.logout),
                  tooltip: 'ออกจากระบบ',
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.spaceL),
                
                // Welcome Section
                AppCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: AppSizes.iconXL * 2,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      Text(
                        'ยินดีต้อนรับสู่ Campus Life Hub',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      Text(
                        'ศูนย์กลางการใช้ชีวิตในมหาวิทยาลัย',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),

                // Feature Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: AppSizes.spaceM,
                  mainAxisSpacing: AppSizes.spaceM,
                  children: [
                    _buildFeatureCard(
                      context,
                      'ตารางเรียน',
                      Icons.schedule,
                      AppColors.primary,
                      () => context.push('/schedule'),
                    ),
                    _buildFeatureCard(
                      context,
                      'ประกาศ',
                      Icons.announcement,
                      AppColors.secondary,
                      () => context.push('/announcements'),
                    ),
                    _buildFeatureCard(
                      context,
                      'กิจกรรม',
                      Icons.event,
                      AppColors.info,
                      () => context.push('/events'),
                    ),
                    _buildFeatureCard(
                      context,
                      'แผนที่',
                      Icons.map,
                      AppColors.warning,
                      () => context.push('/map'),
                    ),
                    _buildFeatureCard(
                      context,
                      'กลุ่มศึกษา',
                      Icons.group,
                      AppColors.success,
                      () => context.push('/groups'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),

                // Quick Actions
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'การทำงานด่วน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      AppButton(
                        text: 'ดูตารางเรียนวันนี้',
                        type: AppButtonType.outline,
                        isFullWidth: true,
                        icon: Icons.today,
                        onPressed: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      AppButton(
                        text: 'ตรวจสอบประกาศใหม่',
                        type: AppButtonType.outline,
                        isFullWidth: true,
                        icon: Icons.notifications,
                        onPressed: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.iconL * 1.5,
            color: color,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'เร็วๆ นี้',
        content: 'ฟีเจอร์นี้จะพร้อมใช้งานเร็วๆ นี้',
        actions: [
          AppButton(
            text: 'ตกลง',
            type: AppButtonType.primary,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'ออกจากระบบ',
        content: 'คุณต้องการออกจากระบบหรือไม่?',
        actions: [
          AppButton(
            text: 'ยกเลิก',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            text: 'ออกจากระบบ',
            type: AppButtonType.danger,
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}


