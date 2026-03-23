interface FormInputProps {
  label: string;
  type?: string;
  value: string;
  onChange: (value: string) => void;
  required?: boolean;
  autoComplete?: string;
}

export default function FormInput({
  label,
  type = 'text',
  value,
  onChange,
  required = false,
  autoComplete,
}: FormInputProps) {
  return (
    <div>
      <label className="block text-sm font-medium text-gray-300 mb-1">{label}</label>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required={required}
        autoComplete={autoComplete}
        className="w-full bg-gray-700/50 border border-gray-600 rounded-lg px-4 py-2.5 text-sm text-white placeholder-gray-500 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 hover:border-gray-500"
      />
    </div>
  );
}
