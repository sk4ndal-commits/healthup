import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { todoApi } from '../api/todoApi';
import type { TodoItem } from '../api/todoApi';
import LanguageSwitcher from '../components/LanguageSwitcher';
import { useAuth } from '../hooks/AuthContext';

export default function TodoPage() {
  const { t } = useTranslation();
  const { logout } = useAuth();

  const [todos, setTodos] = useState<TodoItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [newTitle, setNewTitle] = useState('');
  const [creating, setCreating] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editTitle, setEditTitle] = useState('');

  const load = async () => {
    try {
      setLoading(true);
      setError('');
      const data = await todoApi.getAll();
      setTodos(data);
    } catch {
      setError(t('todo.errorLoad'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTitle.trim()) return;
    try {
      setCreating(true);
      const created = await todoApi.create({ title: newTitle.trim() });
      setTodos((prev) => [created, ...prev]);
      setNewTitle('');
    } catch {
      setError(t('todo.errorCreate'));
    } finally {
      setCreating(false);
    }
  };

  const handleToggle = async (id: number) => {
    try {
      await todoApi.toggle(id);
      setTodos((prev) => prev.map((t) => (t.id === id ? { ...t, isDone: !t.isDone } : t)));
    } catch {
      setError(t('todo.errorUpdate'));
    }
  };

  const startEdit = (todo: TodoItem) => {
    setEditingId(todo.id);
    setEditTitle(todo.title);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditTitle('');
  };

  const handleUpdate = async (id: number, isDone: boolean) => {
    if (!editTitle.trim()) return;
    try {
      await todoApi.update(id, { title: editTitle.trim(), isDone });
      setTodos((prev) => prev.map((t) => (t.id === id ? { ...t, title: editTitle.trim() } : t)));
      cancelEdit();
    } catch {
      setError(t('todo.errorUpdate'));
    }
  };

  const handleDelete = async (id: number) => {
    if (!window.confirm(t('todo.confirmDelete'))) return;
    try {
      await todoApi.delete(id);
      setTodos((prev) => prev.filter((t) => t.id !== id));
    } catch {
      setError(t('todo.errorDelete'));
    }
  };

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 border-b border-gray-700 px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link to="/dashboard" className="text-gray-400 hover:text-white text-sm transition">
            ← {t('dashboard.title')}
          </Link>
          <h1 className="text-xl font-bold text-white">{t('todo.title')}</h1>
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

      <main className="max-w-2xl mx-auto p-6">
        {/* Create form */}
        <form onSubmit={handleCreate} className="flex gap-2 mb-6">
          <input
            type="text"
            value={newTitle}
            onChange={(e) => setNewTitle(e.target.value)}
            placeholder={t('todo.newPlaceholder')}
            className="flex-1 bg-gray-700 border border-gray-600 text-white placeholder-gray-400 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            disabled={creating || !newTitle.trim()}
            className="bg-blue-600 hover:bg-blue-500 disabled:opacity-50 text-white px-4 py-2 rounded-lg transition font-medium"
          >
            {creating ? t('common.loading') : t('todo.add')}
          </button>
        </form>

        {/* Error */}
        {error && (
          <div className="bg-red-900/50 border border-red-700 text-red-300 rounded-lg px-4 py-3 mb-4 text-sm">
            {error}
          </div>
        )}

        {/* List */}
        {loading ? (
          <p className="text-gray-400 text-center py-8">{t('common.loading')}</p>
        ) : todos.length === 0 ? (
          <p className="text-gray-500 text-center py-8">{t('todo.empty')}</p>
        ) : (
          <ul className="space-y-2">
            {todos.map((todo) => (
              <li
                key={todo.id}
                className="bg-gray-800 border border-gray-700 rounded-lg px-4 py-3 flex items-center gap-3"
              >
                {/* Checkbox */}
                <input
                  type="checkbox"
                  checked={todo.isDone}
                  onChange={() => handleToggle(todo.id)}
                  className="w-4 h-4 accent-blue-500 cursor-pointer flex-shrink-0"
                />

                {/* Title / edit field */}
                {editingId === todo.id ? (
                  <input
                    type="text"
                    value={editTitle}
                    onChange={(e) => setEditTitle(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') handleUpdate(todo.id, todo.isDone);
                      if (e.key === 'Escape') cancelEdit();
                    }}
                    autoFocus
                    className="flex-1 bg-gray-700 border border-blue-500 text-white rounded px-2 py-1 text-sm focus:outline-none"
                  />
                ) : (
                  <span
                    className={`flex-1 text-sm ${todo.isDone ? 'line-through text-gray-500' : 'text-gray-100'}`}
                  >
                    {todo.title}
                  </span>
                )}

                {/* Actions */}
                <div className="flex items-center gap-2 flex-shrink-0">
                  {editingId === todo.id ? (
                    <>
                      <button
                        onClick={() => handleUpdate(todo.id, todo.isDone)}
                        className="text-xs text-green-400 hover:text-green-300 transition"
                      >
                        {t('common.save')}
                      </button>
                      <button
                        onClick={cancelEdit}
                        className="text-xs text-gray-400 hover:text-gray-300 transition"
                      >
                        {t('common.cancel')}
                      </button>
                    </>
                  ) : (
                    <>
                      <button
                        onClick={() => startEdit(todo)}
                        className="text-xs text-blue-400 hover:text-blue-300 transition"
                      >
                        {t('common.edit')}
                      </button>
                      <button
                        onClick={() => handleDelete(todo.id)}
                        className="text-xs text-red-400 hover:text-red-300 transition"
                      >
                        {t('common.delete')}
                      </button>
                    </>
                  )}
                </div>
              </li>
            ))}
          </ul>
        )}
      </main>
    </div>
  );
}
