import { useState } from 'react';
import { Link, useSearchParams, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { authApi } from '../api/authApi';
import AuthCard from '../components/AuthCard';
import FormInput from '../components/FormInput';
import PasswordInput from '../components/PasswordInput';

export default function ResetPasswordPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const email = searchParams.get('email') ?? '';
  const token = searchParams.get('token') ?? '';

  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
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
      await authApi.resetPassword({ email, token, newPassword });
      navigate('/login?reset=1');
    } catch {
      setError(t('auth.resetPassword.error'));
    } finally {
      setLoading(false);
    }
  };

  if (!email || !token) {
    return (
      <AuthCard title={t('auth.resetPassword.title')}>
        <p className="text-red-400 text-sm text-center mb-4">
          {t('auth.resetPassword.invalidLink')}
        </p>
        <p className="text-sm text-center">
          <Link to="/forgot-password" className="text-blue-400 hover:text-blue-300 hover:underline">
            {t('auth.resetPassword.requestNew')}
          </Link>
        </p>
      </AuthCard>
    );
  }

  return (
    <AuthCard title={t('auth.resetPassword.title')} error={error}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <FormInput
          label={t('auth.email')}
          type="email"
          value={email}
          onChange={() => {}}
          required
          autoComplete="email"
        />
        <PasswordInput
          label={t('auth.resetPassword.newPassword')}
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
          {loading ? t('common.loading') : t('auth.resetPassword.submit')}
        </button>
      </form>
      <p className="text-sm text-center text-gray-400 mt-4">
        <Link to="/login" className="text-blue-400 hover:text-blue-300 hover:underline">
          {t('auth.forgotPassword.backToLogin')}
        </Link>
      </p>
    </AuthCard>
  );
}
