import 'dart:convert';
import 'package:http/http.dart' as http;

class SupabaseAdmin {
  final String supabaseUrl;
  final String serviceRoleKey;

  SupabaseAdmin(this.supabaseUrl, this.serviceRoleKey);

  // Fetch all users
  Future<List<String>> fetchAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$supabaseUrl/auth/v1/admin/users'),
        headers: {
          'Authorization': 'Bearer $serviceRoleKey',
          'apikey': serviceRoleKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) ;
        final userList = data["users"] as List<dynamic>;
        print(userList);
        return userList.map((user) => user['id'] as String).toList();
      } else {
        print('Failed to fetch users: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error fetching users: $error');
      return [];
    }
  }

  // Delete a single user by ID
  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$supabaseUrl/auth/v1/admin/users/$userId'),
        headers: {
          'Authorization': 'Bearer $serviceRoleKey',
          'apikey': serviceRoleKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('User $userId deleted successfully.');
      } else {
        print('Failed to delete user $userId: ${response.body}');
      }
    } catch (error) {
      print('Error deleting user $userId: $error');
    }
  }

  // Delete all users
  Future<void> deleteAllUsers() async {
    final userIds = await fetchAllUsers();

    if (userIds.isEmpty) {
      print('No users to delete.');
      return;
    }

    for (final userId in userIds) {
      await deleteUser(userId);
    }

    print('All users deleted successfully.');
  }
}

void main() async {
  const supabaseUrl = 'https://wvhqcdufeikptabucbhr.supabase.co'; // Replace with your Supabase URL
  const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2aHFjZHVmZWlrcHRhYnVjYmhyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk1MjI5OSwiZXhwIjoyMDQzNTI4Mjk5fQ.Hncsm-7zdLVAJNbKIFKY3lYanREBSQQePjgG60oqoi0'; // Replace with your Service Role Key

  final supabaseAdmin = SupabaseAdmin(supabaseUrl, serviceRoleKey);

  // Delete all users
  await supabaseAdmin.deleteAllUsers();
}