using System.ComponentModel.DataAnnotations;

namespace booking_app_BE.Database.Entity
{
    public class MapEmployeeToService
    {
        [Key]
        public int Id { get; set; }
        public int EmployeeID { get; set; }
        public int ServiceID { get; set; }
    }
}
