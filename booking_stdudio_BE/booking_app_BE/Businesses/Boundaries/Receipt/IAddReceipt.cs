namespace booking_app_BE.Businesses.Boundaries.Receipt
{
    public class IAddReceipt
    {
       public class AddReceiptRequest
        {
            public int ScheduleId { get; set; }
            public decimal Total { get; set; }
            public DateTime CreateDate { get; set; }
        }
    }
}
