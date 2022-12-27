using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Database.Repository
{
    public interface IReceiptRepository : IBaseRepository<Receipt>
    {
        Task AddReceipt(IAddReceipt.AddReceiptRequest request);
        Task<dynamic> GetReceiptDataChart(int year);
    }
}
