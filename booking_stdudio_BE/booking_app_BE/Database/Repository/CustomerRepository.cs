using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class CustomerRepository : BaseRepository<Customer>, ICustomerRepository
    {
        private readonly DbSet<Customer> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public CustomerRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Customer>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddCustomer.Response> CreateCustomer(IAddCustomer.Request request)
        {
            try
            {
                var customer = new Customer()
                {
                    FullName = request.FullName,
                    PhoneNumber = request.PhoneNumber,
                    //Image = fileName,
                    CustomerAccountId = request.CustomerAccountId,
                };
                _dbContext.Set<Customer>().Add(customer);
                await _dbContext.SaveChangesAsync();
                return new IAddCustomer.Response(200, "success");
            } catch
            {
                return new IAddCustomer.Response(500, "error");
            } 
        }

        public async Task<dynamic> GetAllCustomer()
        {
            return await _dbSet.AsNoTracking().ToListAsync();
        }

        public async Task<IQueryable<dynamic>> GetCustomersByCondition(string name, string address)
        {
            var queryable = _dbSet.AsNoTracking();

            if (!string.IsNullOrEmpty(name))
            {
                queryable = queryable.Where(x => x.FullName.Contains(name));
            }

            if (!string.IsNullOrEmpty(address))
            {
                queryable = queryable.Where(x => x.Address.Contains(address));
            }

            var result = queryable.Select(s => new
            {
                id = s.Id,
                fullName = s.FullName,
                address = s.Address,
                phoneNumber = s.PhoneNumber,
                image = s.Image,
                customerAccountId = s.CustomerAccountId,
            });

            /*switch (sortHeader)
            {
                case SortOrderDto.SortHeader.Name:
                    result = sortOrder == SortOrderDto.SortOrder.ASC
                        ? result.OrderBy(x => x.name).ThenBy(x => x.badgeId)
                        : result.OrderByDescending(x => x.name).ThenBy(x => x.badgeId);
                    break;
                case SortOrderDto.SortHeader.BadgeId:
                    result = sortOrder == SortOrderDto.SortOrder.ASC
                        ? result.OrderBy(x => x.badgeId).ThenBy(x => x.name)
                        : result.OrderByDescending(x => x.badgeId).ThenBy(x => x.name);
                    break;
            }*/
            await Task.Delay(1);
            return result;
        }
    }
}
