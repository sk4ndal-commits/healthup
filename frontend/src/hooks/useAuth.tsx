import { useState, useCallback } from 'react';
import type { ReactNode } from 'react';
import { authApi } from '../api/authApi';
import { tokenStorage } from '../api/client';
import { AuthContext } from './AuthContext';
import type { AuthUser } from './AuthContext';

function parseUserFromToken(token: string): AuthUser | null {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return {
      email:
        payload.email ??
        payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
        '',
      role: payload.role ?? payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'],
    };
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(() => {
    const token = tokenStorage.getAccessToken();
    return token ? parseUserFromToken(token) : null;
  });

  const login = useCallback(async (email: string, password: string) => {
    const response = await authApi.login(email, password);
    setUser(parseUserFromToken(response.accessToken) ?? { email });
  }, []);

  const logout = useCallback(async () => {
    await authApi.logout();
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: user !== null, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}
