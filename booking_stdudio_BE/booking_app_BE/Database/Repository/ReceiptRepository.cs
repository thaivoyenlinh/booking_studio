using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class ReceiptRepository : BaseRepository<Receipt>, IReceiptRepository
    {
        private readonly DbSet<Receipt> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public ReceiptRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Receipt>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task AddReceipt(IAddReceipt.AddReceiptRequest request)
        {
            /*try
            {*/
                if (request != null)
                {
                    var receipt = new Receipt
                    {
                        ScheduleId = request.ScheduleId,
                        Total = request.Total,
                        CreateDate = DateTime.Now
                    };
                    _dbContext.Set<Receipt>().Add(receipt);
                    await _dbContext.SaveChangesAsync();
                   // return new IAddSchedule.AddScheduleResponse(200, "success");
                }
                //else { return new IAddSchedule.AddScheduleResponse(200, "success"); }
            /*}
            catch
            {
                //return new IAddSchedule.AddScheduleResponse(500, "error");
            }*/
          
        }

        public async Task<dynamic> GetReceiptDataChart(int year)
        {
            //.Where(e => e.CreateDate.Year == 2022)
            var result = _dbSet.Where(e => e.CreateDate.Year == year).AsNoTracking();
            List<dynamic> lst = new List<dynamic>();
            var data = result.Select(k => new { k.CreateDate.Year, k.CreateDate.Month, k.Total }).GroupBy(x => new { x.Year, x.Month }, (key, group) => new
            {
                year = key.Year.ToString(),
                month = key.Month.ToString(),
                total = group.Sum(k => k.Total)
            }).ToList();
            data.ForEach(x => lst.Add(x));  
            return lst;
        }
    }
}
