import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { authApi } from '../api/authApi';
import AuthCard from '../components/AuthCard';
import FormInput from '../components/FormInput';

export default function ForgotPasswordPage() {
  const { t } = useTranslation();
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await authApi.forgotPassword({ email });
      setSuccess(true);
    } catch {
      setError(t('auth.forgotPassword.error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthCard title={t('auth.forgotPassword.title')} error={error}>
      {success ? (
        <div className="text-center space-y-4">
          <p className="text-green-400 text-sm bg-green-900/30 border border-green-700 rounded-lg px-3 py-2">
            {t('auth.forgotPassword.success')}
          </p>
          <Link to="/login" className="text-blue-400 hover:text-blue-300 hover:underline text-sm">
            {t('auth.forgotPassword.backToLogin')}
          </Link>
        </div>
      ) : (
        <>
          <p className="text-gray-400 text-sm mb-4 text-center">{t('auth.forgotPassword.hint')}</p>
          <form onSubmit={handleSubmit} className="space-y-4">
            <FormInput
              label={t('auth.email')}
              type="email"
              value={email}
              onChange={setEmail}
              required
              autoComplete="email"
            />
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-2 rounded-lg transition disabled:opacity-50"
            >
              {loading ? t('common.loading') : t('auth.forgotPassword.submit')}
            </button>
          </form>
          <p className="text-sm text-center text-gray-400 mt-4">
            <Link to="/login" className="text-blue-400 hover:text-blue-300 hover:underline">
              {t('auth.forgotPassword.backToLogin')}
            </Link>
          </p>
        </>
      )}
    </AuthCard>
  );
}
