namespace booking_app_BE.Database.Entity
{
    public class Receipt
    {
        public int Id { get; set; }
        public int ScheduleId { get; set; }
        public decimal Total { get; set; }
        public DateTime CreateDate { get; set; }
    }
}
