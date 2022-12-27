using booking_app_BE.Businesses.Boundaries.Receipt;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Receipt
{
    [ApiController]
    [Route("receipt")]
    public class ReceiptController : ControllerBase
    {
        private IReceiptChart _receiptChart;

        public ReceiptController(IReceiptChart receiptChart)
        {
            _receiptChart = receiptChart;
        }

        [HttpGet("getReceiptChartData")]
        public async Task<dynamic> GetReceiptChartData(int year)
        {
            return await _receiptChart.ReceiptChartData(year);
        }
    }
}
