using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace booking_app_BE.Database.Entity
{
    [Index(nameof(BadgeId), IsUnique = true)]
    public class Employee
    {
        [Key]
        public int Id { get; set; }
        public int BadgeId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Image { get; set; }
    }
}
