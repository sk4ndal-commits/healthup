import { apiClient } from './client';

export interface AdminUser {
  id: number;
  email: string;
  role: string;
  isActive: boolean;
  createdAtUtc: string;
  accountId: number;
}

export interface CreateUserRequest {
  email: string;
  password: string;
  role: string;
  accountId: number;
}

export const adminApi = {
  getUsers: async (): Promise<AdminUser[]> => {
    const res = await apiClient.get<AdminUser[]>('/api/v1/admin/users');
    return res.data;
  },

  getUser: async (id: number): Promise<AdminUser> => {
    const res = await apiClient.get<AdminUser>(`/api/v1/admin/users/${id}`);
    return res.data;
  },

  createUser: async (req: CreateUserRequest): Promise<AdminUser> => {
    const res = await apiClient.post<AdminUser>('/api/v1/admin/users', req);
    return res.data;
  },

  resetPassword: async (id: number, newPassword: string): Promise<void> => {
    await apiClient.post(`/api/v1/admin/users/${id}/reset-password`, { newPassword });
  },

  toggleActive: async (id: number): Promise<void> => {
    await apiClient.post(`/api/v1/admin/users/${id}/toggle-active`);
  },
};
