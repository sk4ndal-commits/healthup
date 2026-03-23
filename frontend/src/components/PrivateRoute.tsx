import { Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/AuthContext';
import type { ReactNode } from 'react';

interface Props {
  children: ReactNode;
}

export default function PrivateRoute({ children }: Props) {
  const { isAuthenticated } = useAuth();
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />;
}
