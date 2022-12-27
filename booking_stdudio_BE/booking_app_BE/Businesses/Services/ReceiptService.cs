using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class ReceiptService : BaseService<Receipt, IReceiptRepository>, IReceiptService
    {
        private readonly BookingStudioContext _dbContext;
        public ReceiptService(
            IReceiptRepository receiptRepository,
            BookingStudioContext dbContext) : base(receiptRepository)
        {
            _dbContext = dbContext;
        }

        public async Task CreateReceipt(IAddReceipt.AddReceiptRequest request)
        {
            await Repository.AddReceipt(request);
        }

        public async Task<dynamic> GetReceiptDataChart(int year)
        {
            return await Repository.GetReceiptDataChart(year);
        }
    }
}
