import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { register } from '../api/authApi';
import AuthCard from '../components/AuthCard';
import FormInput from '../components/FormInput';
import PasswordInput from '../components/PasswordInput';

export default function RegisterPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [accountName, setAccountName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (password !== confirmPassword) {
      setError(t('auth.register.passwordMismatch'));
      return;
    }
    setLoading(true);
    try {
      await register({ email, password, accountName });
      navigate('/login', { state: { registered: true } });
    } catch {
      setError(t('auth.register.error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthCard title={t('auth.register.title')} error={error}>
      <form onSubmit={handleSubmit} className="space-y-4">
        <FormInput
          label={t('auth.register.organisation')}
          value={accountName}
          onChange={setAccountName}
          required
          autoComplete="organization"
        />
        <FormInput
          label={t('auth.register.email')}
          type="email"
          value={email}
          onChange={setEmail}
          required
          autoComplete="email"
        />
        <PasswordInput
          label={t('auth.register.password')}
          value={password}
          onChange={setPassword}
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
          {loading ? t('common.loading') : t('auth.register.submit')}
        </button>
      </form>
      <p className="text-sm text-center text-gray-400 mt-4">
        {t('auth.register.alreadyHaveAccount')}{' '}
        <Link to="/login" className="text-blue-400 hover:text-blue-300 hover:underline">
          {t('auth.register.signIn')}
        </Link>
      </p>
    </AuthCard>
  );
}
