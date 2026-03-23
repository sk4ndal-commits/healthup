namespace Domain;

public class Account
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

    public ICollection<User> Users { get; set; } = new List<User>();
    public ICollection<TodoItem> TodoItems { get; set; } = new List<TodoItem>();
}
