import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../hooks/AuthContext';
import AuthCard from '../components/AuthCard';
import FormInput from '../components/FormInput';
import PasswordInput from '../components/PasswordInput';

export default function LoginPage() {
  const { t } = useTranslation();
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await login(email, password);
      navigate('/dashboard');
    } catch {
      setError(t('auth.login.error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthCard title={t('auth.login.title')} error={error}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <FormInput
          label={t('auth.login.email')}
          type="email"
          value={email}
          onChange={setEmail}
          required
          autoComplete="email"
        />
        <div>
          <PasswordInput
            label={t('auth.login.password')}
            value={password}
            onChange={setPassword}
            required
            autoComplete="current-password"
          />
          <div className="text-right mt-1">
            <Link
              to="/forgot-password"
              className="text-xs text-blue-400 hover:text-blue-300 hover:underline"
            >
              {t('auth.login.forgotPassword')}
            </Link>
          </div>
        </div>
        <button
          type="submit"
          disabled={loading}
          className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-2 rounded-lg transition disabled:opacity-50"
        >
          {loading ? t('common.loading') : t('auth.login.submit')}
        </button>
      </form>
      <p className="text-sm text-center text-gray-400 mt-4">
        {t('auth.login.noAccount')}{' '}
        <Link to="/register" className="text-blue-400 hover:text-blue-300 hover:underline">
          {t('auth.login.createOne')}
        </Link>
      </p>
    </AuthCard>
  );
}
