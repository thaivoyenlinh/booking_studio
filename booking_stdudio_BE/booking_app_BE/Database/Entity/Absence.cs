using System.ComponentModel.DataAnnotations;

namespace booking_app_BE.Database.Entity
{
    public class Absence
    {
        [Key]
        public int Id { get; set; }
        public int EmployeeId { get; set; }
        public List<string> Date { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
    }
}
