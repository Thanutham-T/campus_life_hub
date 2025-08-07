import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_event.dart';
import '../../../user/presentation/bloc/auth_state.dart';
import '../../../user/domain/entities/profile_entity.dart';
import '../widgets/profile_card.dart';
import '../widgets/virtual_student_card.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/app_version_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _hasRequestedProfile = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request fresh profile data when the page loads (only once)
    if (!_hasRequestedProfile) {
      _hasRequestedProfile = true;
      
      // Check auth status first, then request profile if needed
      context.read<AuthBloc>().add(AuthStatusRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          print('DEBUG: Current AuthState: ${state.runtimeType}');
          
          if (state is AuthLoading || state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle both AuthAuthenticated and ProfileLoaded states
          ProfileEntity? profile;
          if (state is AuthAuthenticated) {
            profile = state.profile;
          } else if (state is ProfileLoaded) {
            profile = state.profile;
          }

          if (profile != null) {
            print('DEBUG: Profile data: $profile');
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Virtual Student Card
                  VirtualStudentCard(profile: profile),
                  
                  const SizedBox(height: 16),
                  
                  // Profile Information Card
                  ProfileCard(profile: profile),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  ProfileActionButtons(),
                  
                  const SizedBox(height: 16),
                  
                  // App Version
                  const AppVersionWidget(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          // Handle error states
          if (state is AuthError || state is ProfileFailure) {
            String errorMessage = 'เกิดข้อผิดพลาด';
            if (state is AuthError) {
              errorMessage = state.message;
            } else if (state is ProfileFailure) {
              errorMessage = state.message;
            }
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(ProfileRequested());
                    },
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('ไม่สามารถโหลดข้อมูลได้'),
          );
        },
      ),
    );
  }
}
