using booking_app_BE.Database.Entity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Newtonsoft.Json;

namespace booking_app_BE.Database
{
    public class BookingStudioContext : IdentityDbContext
    {
        public BookingStudioContext(DbContextOptions<BookingStudioContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Service>().Property(p => p.Image)
                .HasConversion(
                    v => JsonConvert.SerializeObject(v),
                    v => JsonConvert.DeserializeObject<List<string>>(v));
            modelBuilder.Entity<Absence>().Property(p => p.Date)
                .HasConversion(
                    v => JsonConvert.SerializeObject(v),
                    v => JsonConvert.DeserializeObject<List<string>>(v));
        }


        //User
        public DbSet<User> User { get; set; }
        public DbSet<Role> Role { get; set; }
        public DbSet<Employee> Employee { get; set; }
        public DbSet<Service> Service { get; set; }
        public DbSet<Customer> Customer { get; set; }
        public DbSet<MapEmployeeToService> MapEmployeeToService { get; set; }
        public DbSet<Schedule> Schedule { get; set; }
        public DbSet<Receipt> Receipt { get; set; }
        public DbSet<Absence> Absence { get; set; }
    }
}
