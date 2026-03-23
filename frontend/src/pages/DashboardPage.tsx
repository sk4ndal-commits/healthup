import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { useAuth } from '../hooks/AuthContext';
import LanguageSwitcher from '../components/LanguageSwitcher';

export default function DashboardPage() {
  const { t } = useTranslation();
  const { user, logout } = useAuth();

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 border-b border-gray-700 px-6 py-4 flex items-center justify-between">
        <h1 className="text-xl font-bold text-white">{t('dashboard.title')}</h1>
        <div className="flex items-center gap-4">
          <LanguageSwitcher />
          <button
            onClick={logout}
            className="text-sm bg-red-600 hover:bg-red-500 text-white px-4 py-2 rounded-lg transition"
          >
            {t('auth.logout')}
          </button>
        </div>
      </header>
      <main className="p-6">
        <p className="text-gray-200">
          {t('dashboard.welcome')}
          {user?.email ? `, ${user.email}` : ''}!
        </p>
        {user?.role && (
          <p className="text-gray-400 text-sm mt-1">
            {t('dashboard.role')}: {user.role}
          </p>
        )}
        <div className="mt-6 grid grid-cols-1 sm:grid-cols-2 gap-4 max-w-lg">
          <Link
            to="/todos"
            className="bg-gray-800 hover:bg-gray-700 border border-gray-700 rounded-lg px-5 py-4 text-white transition"
          >
            <div className="text-lg font-semibold">✅ {t('todo.title')}</div>
            <div className="text-sm text-gray-400 mt-1">{t('todo.newPlaceholder')}</div>
          </Link>
          <Link
            to="/change-password"
            className="bg-gray-800 hover:bg-gray-700 border border-gray-700 rounded-lg px-5 py-4 text-white transition"
          >
            <div className="text-lg font-semibold">🔑 {t('auth.changePassword.title')}</div>
            <div className="text-sm text-gray-400 mt-1">{t('auth.changePassword.hint')}</div>
          </Link>
          {user?.role === 'Admin' && (
            <Link
              to="/admin"
              className="bg-gray-800 hover:bg-gray-700 border border-gray-700 rounded-lg px-5 py-4 text-white transition"
            >
              <div className="text-lg font-semibold">🛡️ {t('admin.title')}</div>
              <div className="text-sm text-gray-400 mt-1">{t('admin.dashboardHint')}</div>
            </Link>
          )}
        </div>
      </main>
    </div>
  );
}
