using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database
{
    public class BookingStudioContext : DbContext
    {
        public BookingStudioContext(DbContextOptions options) : base(options)
        {
        }

        //User
        public DbSet<User> User { get; set; }
        public DbSet<Role> Role { get; set; }

    }
}
