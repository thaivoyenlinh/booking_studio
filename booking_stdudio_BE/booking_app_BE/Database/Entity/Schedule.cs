using System.ComponentModel.DataAnnotations;

namespace booking_app_BE.Database.Entity
{
    public class Schedule
    {
        [Key]
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public int EmployeeId { get; set; }
        public int ServiceId { get; set; }
        public string Date { get; set; }
        public string Status { get; set; }
        public string Total { get; set; }
        public string? ReScheduleType { get; set; }
        public string? DateReSchedule { get; set; }
        public double? EmployeeRating { get; set; }
        public double? ServiceRating { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
