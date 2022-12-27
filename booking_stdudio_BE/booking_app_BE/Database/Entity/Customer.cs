using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations.Schema;

namespace booking_app_BE.Database.Entity
{
    public class Customer
    {
        public int Id { get; set; }
        public string? FullName { get; set; }
        public string? Address { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Image { get; set; }
        [ForeignKey("CustomerAccountId")]
        public string CustomerAccountId { get; set; }
        public virtual IdentityUser UserAccount { get; set; }
    }
}
