import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { adminApi } from '../api/adminApi';
import type { AdminUser, CreateUserRequest } from '../api/adminApi';
import LanguageSwitcher from '../components/LanguageSwitcher';
import { useAuth } from '../hooks/AuthContext';
import PasswordInput from '../components/PasswordInput';
import FormInput from '../components/FormInput';

export default function AdminPage() {
  const { t } = useTranslation();
  const { logout } = useAuth();

  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Reset password modal
  const [resetUserId, setResetUserId] = useState<number | null>(null);
  const [resetPassword, setResetPassword] = useState('');
  const [resetError, setResetError] = useState('');
  const [resetSuccess, setResetSuccess] = useState(false);

  // Create user modal
  const [showCreate, setShowCreate] = useState(false);
  const [createForm, setCreateForm] = useState<CreateUserRequest>({
    email: '',
    password: '',
    role: 'AppUser',
    accountId: 1,
  });
  const [createError, setCreateError] = useState('');

  const load = async () => {
    try {
      setLoading(true);
      setError('');
      const data = await adminApi.getUsers();
      setUsers(data);
    } catch {
      setError(t('admin.errorLoad'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const handleToggleActive = async (id: number) => {
    try {
      await adminApi.toggleActive(id);
      setUsers((prev) => prev.map((u) => (u.id === id ? { ...u, isActive: !u.isActive } : u)));
    } catch {
      setError(t('admin.errorToggle'));
    }
  };

  const handleResetPassword = async () => {
    if (!resetUserId) return;
    setResetError('');
    try {
      await adminApi.resetPassword(resetUserId, resetPassword);
      setResetSuccess(true);
      setTimeout(() => {
        setResetUserId(null);
        setResetPassword('');
        setResetSuccess(false);
      }, 1500);
    } catch {
      setResetError(t('admin.errorReset'));
    }
  };

  const handleCreateUser = async () => {
    setCreateError('');
    try {
      const newUser = await adminApi.createUser(createForm);
      setUsers((prev) => [...prev, newUser]);
      setShowCreate(false);
      setCreateForm({ email: '', password: '', role: 'AppUser', accountId: 1 });
    } catch {
      setCreateError(t('admin.errorCreate'));
    }
  };

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 border-b border-gray-700 px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link to="/dashboard" className="text-gray-400 hover:text-white text-sm transition">
            ← {t('common.back')}
          </Link>
          <h1 className="text-xl font-bold text-white">{t('admin.title')}</h1>
        </div>
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

      <main className="p-6 max-w-5xl mx-auto">
        {error && (
          <div className="mb-4 bg-red-900/40 border border-red-700 text-red-300 px-4 py-3 rounded-lg text-sm">
            {error}
          </div>
        )}

        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-white">{t('admin.users')}</h2>
          <button
            onClick={() => setShowCreate(true)}
            className="bg-blue-600 hover:bg-blue-500 text-white text-sm px-4 py-2 rounded-lg transition"
          >
            + {t('admin.createUser')}
          </button>
        </div>

        {loading ? (
          <p className="text-gray-400">{t('common.loading')}</p>
        ) : (
          <div className="bg-gray-800 rounded-lg border border-gray-700 overflow-hidden">
            <table className="w-full text-sm text-left">
              <thead className="bg-gray-700 text-gray-300 uppercase text-xs">
                <tr>
                  <th className="px-4 py-3">{t('admin.colEmail')}</th>
                  <th className="px-4 py-3">{t('admin.colRole')}</th>
                  <th className="px-4 py-3">{t('admin.colAccount')}</th>
                  <th className="px-4 py-3">{t('admin.colStatus')}</th>
                  <th className="px-4 py-3">{t('admin.colCreated')}</th>
                  <th className="px-4 py-3 text-right">{t('admin.colActions')}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-700">
                {users.map((u) => (
                  <tr key={u.id} className="text-gray-200 hover:bg-gray-750">
                    <td className="px-4 py-3">{u.email}</td>
                    <td className="px-4 py-3">
                      <span
                        className={`px-2 py-0.5 rounded text-xs font-medium ${
                          u.role === 'Admin'
                            ? 'bg-purple-900 text-purple-300'
                            : 'bg-blue-900 text-blue-300'
                        }`}
                      >
                        {u.role}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-400">{u.accountId}</td>
                    <td className="px-4 py-3">
                      <span
                        className={`px-2 py-0.5 rounded text-xs font-medium ${
                          u.isActive ? 'bg-green-900 text-green-300' : 'bg-red-900 text-red-300'
                        }`}
                      >
                        {u.isActive ? t('admin.active') : t('admin.inactive')}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-400">
                      {new Date(u.createdAtUtc).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3 text-right flex justify-end gap-2">
                      <button
                        onClick={() => handleToggleActive(u.id)}
                        className="text-xs bg-gray-700 hover:bg-gray-600 text-gray-200 px-3 py-1 rounded transition"
                      >
                        {u.isActive ? t('admin.deactivate') : t('admin.activate')}
                      </button>
                      <button
                        onClick={() => {
                          setResetUserId(u.id);
                          setResetPassword('');
                          setResetError('');
                          setResetSuccess(false);
                        }}
                        className="text-xs bg-yellow-700 hover:bg-yellow-600 text-white px-3 py-1 rounded transition"
                      >
                        {t('admin.resetPassword')}
                      </button>
                    </td>
                  </tr>
                ))}
                {users.length === 0 && (
                  <tr>
                    <td colSpan={6} className="px-4 py-6 text-center text-gray-500">
                      {t('admin.noUsers')}
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </main>

      {/* Reset Password Modal */}
      {resetUserId !== null && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50">
          <div className="bg-gray-800 border border-gray-700 rounded-xl p-6 w-full max-w-sm shadow-xl">
            <h3 className="text-white font-semibold text-lg mb-4">
              {t('admin.resetPasswordTitle')}
            </h3>
            {resetSuccess ? (
              <p className="text-green-400 text-sm">{t('admin.resetSuccess')}</p>
            ) : (
              <>
                {resetError && <p className="text-red-400 text-sm mb-3">{resetError}</p>}
                <PasswordInput
                  label={t('admin.newPassword')}
                  value={resetPassword}
                  onChange={(v) => setResetPassword(v)}
                />
                <div className="flex gap-3 mt-4">
                  <button
                    onClick={handleResetPassword}
                    className="flex-1 bg-yellow-600 hover:bg-yellow-500 text-white py-2 rounded-lg text-sm transition"
                  >
                    {t('admin.resetPassword')}
                  </button>
                  <button
                    onClick={() => setResetUserId(null)}
                    className="flex-1 bg-gray-700 hover:bg-gray-600 text-gray-200 py-2 rounded-lg text-sm transition"
                  >
                    {t('common.cancel')}
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}

      {/* Create User Modal */}
      {showCreate && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50">
          <div className="bg-gray-800 border border-gray-700 rounded-xl p-6 w-full max-w-sm shadow-xl">
            <h3 className="text-white font-semibold text-lg mb-4">{t('admin.createUserTitle')}</h3>
            {createError && <p className="text-red-400 text-sm mb-3">{createError}</p>}
            <FormInput
              label={t('auth.email')}
              type="email"
              value={createForm.email}
              onChange={(v) => setCreateForm((f) => ({ ...f, email: v }))}
            />
            <PasswordInput
              label={t('auth.password')}
              value={createForm.password}
              onChange={(v) => setCreateForm((f) => ({ ...f, password: v }))}
            />
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-300 mb-1">
                {t('admin.colRole')}
              </label>
              <select
                value={createForm.role}
                onChange={(e) => setCreateForm((f) => ({ ...f, role: e.target.value }))}
                className="w-full bg-gray-700 border border-gray-600 text-white rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="AppUser">AppUser</option>
                <option value="Admin">Admin</option>
              </select>
            </div>
            <FormInput
              label={t('admin.accountId')}
              type="number"
              value={String(createForm.accountId)}
              onChange={(v) => setCreateForm((f) => ({ ...f, accountId: Number(v) }))}
            />
            <div className="flex gap-3 mt-4">
              <button
                onClick={handleCreateUser}
                className="flex-1 bg-blue-600 hover:bg-blue-500 text-white py-2 rounded-lg text-sm transition"
              >
                {t('admin.createUser')}
              </button>
              <button
                onClick={() => setShowCreate(false)}
                className="flex-1 bg-gray-700 hover:bg-gray-600 text-gray-200 py-2 rounded-lg text-sm transition"
              >
                {t('common.cancel')}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
