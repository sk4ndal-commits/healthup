import { useTranslation } from 'react-i18next';

export default function LanguageSwitcher() {
  const { i18n, t } = useTranslation();

  const toggle = () => {
    i18n.changeLanguage(i18n.language.startsWith('de') ? 'en' : 'de');
  };

  return (
    <button
      onClick={toggle}
      className="text-sm text-gray-400 hover:text-gray-200 underline"
      title={t('language.switch')}
    >
      {i18n.language.startsWith('de') ? t('language.en') : t('language.de')}
    </button>
  );
}
