using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Receipt
{
    [Interactor]
    public class ReceiptChart : IReceiptChart
    {
        private readonly IReceiptService _receiptService;
        public ReceiptChart(IReceiptService receiptService)
        {
            _receiptService = receiptService;
        }

        public async Task<dynamic> ReceiptChartData(int year)
        {
            return await _receiptService.GetReceiptDataChart(year);
        }
    }
}
