import { apiClient, tokenStorage } from './client';

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  expiresInSeconds: number;
}

export interface RegisterRequest {
  email: string;
  password: string;
  accountName: string;
}

export interface ForgotPasswordRequest {
  email: string;
}

export interface ChangePasswordRequest {
  oldPassword: string;
  newPassword: string;
}

export interface ResetPasswordRequest {
  email: string;
  token: string;
  newPassword: string;
}

export const authApi = {
  login: async (email: string, password: string): Promise<LoginResponse> => {
    const { data } = await apiClient.post<LoginResponse>('/api/v1/auth/login', { email, password });
    tokenStorage.setAccessToken(data.accessToken);
    tokenStorage.setRefreshToken(data.refreshToken);
    return data;
  },

  logout: async (): Promise<void> => {
    const refreshToken = tokenStorage.getRefreshToken();
    if (refreshToken) {
      await apiClient.post('/api/v1/auth/logout', { refreshToken }).catch(() => {});
    }
    tokenStorage.clear();
  },

  register: async (req: RegisterRequest): Promise<void> => {
    await apiClient.post('/api/v1/auth/register', req);
  },

  forgotPassword: async (req: ForgotPasswordRequest): Promise<void> => {
    await apiClient.post('/api/v1/auth/forgot-password', req);
  },

  resetPassword: async (req: ResetPasswordRequest): Promise<void> => {
    await apiClient.post('/api/v1/auth/reset-password', req);
  },

  changePassword: async (req: ChangePasswordRequest): Promise<void> => {
    await apiClient.post('/api/v1/auth/change-password', req);
  },
};

export const register = authApi.register;
