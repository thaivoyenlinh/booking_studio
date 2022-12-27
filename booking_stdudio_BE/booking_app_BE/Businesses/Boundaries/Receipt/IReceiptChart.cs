namespace booking_app_BE.Businesses.Boundaries.Receipt
{
    public interface IReceiptChart
    {
        Task<dynamic> ReceiptChartData(int year);
    }
}
