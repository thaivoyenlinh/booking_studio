using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Businesses.Services
{
    public interface IReceiptService : IBaseService<Receipt>
    {
        Task CreateReceipt(IAddReceipt.AddReceiptRequest request);
        Task<dynamic> GetReceiptDataChart(int year);
    }
}
