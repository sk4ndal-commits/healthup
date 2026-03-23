import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { authApi } from '../api/authApi';
import AuthCard from '../components/AuthCard';
import PasswordInput from '../components/PasswordInput';

export default function ChangePasswordPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (newPassword !== confirmPassword) {
      setError(t('auth.register.passwordMismatch'));
      return;
    }
    setLoading(true);
    try {
      await authApi.changePassword({ oldPassword, newPassword });
      setSuccess(true);
      setTimeout(() => navigate('/dashboard'), 2000);
    } catch {
      setError(t('auth.changePassword.error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthCard title={t('auth.changePassword.title')} error={error}>
      {success ? (
        <p className="text-green-400 text-sm text-center bg-green-900/30 border border-green-700 rounded-lg px-3 py-2">
          {t('auth.changePassword.success')}
        </p>
      ) : (
        <>
          <form onSubmit={handleSubmit} className="space-y-4">
            <PasswordInput
              label={t('auth.changePassword.oldPassword')}
              value={oldPassword}
              onChange={setOldPassword}
              required
              autoComplete="current-password"
            />
            <PasswordInput
              label={t('auth.changePassword.newPassword')}
              value={newPassword}
              onChange={setNewPassword}
              required
              autoComplete="new-password"
            />
            <PasswordInput
              label={t('auth.register.confirmPassword')}
              value={confirmPassword}
              onChange={setConfirmPassword}
              required
              autoComplete="new-password"
            />
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-2 rounded-lg transition disabled:opacity-50"
            >
              {loading ? t('common.loading') : t('auth.changePassword.submit')}
            </button>
          </form>
          <p className="text-sm text-center text-gray-400 mt-4">
            <Link to="/dashboard" className="text-blue-400 hover:text-blue-300 hover:underline">
              {t('common.back')}
            </Link>
          </p>
        </>
      )}
    </AuthCard>
  );
}
