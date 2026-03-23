import { apiClient } from './client';

export interface TodoItem {
  id: number;
  title: string;
  isDone: boolean;
  dueDate?: string;
  createdAt: string;
}

export interface CreateTodoRequest {
  title: string;
}

export interface UpdateTodoRequest {
  title: string;
  isDone: boolean;
}

export const todoApi = {
  getAll: async (): Promise<TodoItem[]> => {
    const { data } = await apiClient.get<TodoItem[]>('/api/v1/todo');
    return data;
  },

  getById: async (id: number): Promise<TodoItem> => {
    const { data } = await apiClient.get<TodoItem>(`/api/v1/todo/${id}`);
    return data;
  },

  create: async (req: CreateTodoRequest): Promise<TodoItem> => {
    const { data } = await apiClient.post<TodoItem>('/api/v1/todo', req);
    return data;
  },

  update: async (id: number, req: UpdateTodoRequest): Promise<void> => {
    await apiClient.put(`/api/v1/todo/${id}`, req);
  },

  delete: async (id: number): Promise<void> => {
    await apiClient.delete(`/api/v1/todo/${id}`);
  },

  toggle: async (id: number): Promise<void> => {
    await apiClient.post(`/api/v1/todo/${id}/toggle`);
  },
};
