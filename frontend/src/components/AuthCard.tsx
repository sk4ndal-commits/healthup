import type { ReactNode } from 'react';
import LanguageSwitcher from './LanguageSwitcher';

interface AuthCardProps {
  title: string;
  error?: string;
  children: ReactNode;
}

export default function AuthCard({ title, error, children }: AuthCardProps) {
  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center px-4">
      <div className="bg-gray-800 rounded-2xl shadow-xl w-full max-w-md p-8 border border-gray-700">
        <div className="flex justify-end mb-4">
          <LanguageSwitcher />
        </div>
        <h1 className="text-2xl font-bold text-white mb-6 text-center">{title}</h1>
        {error && (
          <p className="text-red-400 text-sm mb-4 text-center bg-red-900/30 border border-red-700 rounded-lg px-3 py-2">
            {error}
          </p>
        )}
        {children}
      </div>
    </div>
  );
}
