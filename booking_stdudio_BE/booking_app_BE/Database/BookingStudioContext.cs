using booking_app_BE.Database.Entity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database
{
    public class BookingStudioContext : IdentityDbContext
    {
        public BookingStudioContext(DbContextOptions<BookingStudioContext> options) : base(options)
        {
        }
        
        //User
        public DbSet<User> User { get; set; }
        public DbSet<Role> Role { get; set; }

        public DbSet<Employee> Employee { get; set; }

    }
}
