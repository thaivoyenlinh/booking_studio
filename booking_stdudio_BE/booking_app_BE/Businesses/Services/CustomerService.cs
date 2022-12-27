using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;
using Microsoft.AspNetCore.Identity;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class CustomerService : BaseService<Customer, ICustomerRepository>, ICustomerService
    {
        private readonly BookingStudioContext _dbContext;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public CustomerService(
            ICustomerRepository customerRepository,
            BookingStudioContext dbContext,
            UserManager<IdentityUser> userManager,
            IWebHostEnvironment webHostEnvironment) : base(customerRepository)
        {
            _dbContext = dbContext;
            _userManager = userManager;
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddCustomer.Response> CreateCustomer(IAddCustomer.Request request)
        {
            var response = await Repository.CreateCustomer(request);
            return response;
        }

        public async Task<IGetCustomerDetails.Response> GetCustomerDetails(IGetCustomerDetails.Request request)
        {
            var customer = await Repository.FindByIdAsync(x => x.CustomerAccountId  == request.CustomerAccountId.ToString());
            var account = await _userManager.FindByIdAsync(customer.CustomerAccountId);
            return new IGetCustomerDetails.Response
            {
                Id = customer.Id,
                FullName = customer.FullName,
                Address = customer.Address,
                PhoneNumber = customer.PhoneNumber,
                Email = account.Email,
                Image = customer.Image,    
            };
        }

        public async Task UpdateCustomer(IUpdateCustomer.RequestUpdateCustomer request)
        {
            var customer = await Repository.FindByIdAsync(x => x.Id == request.Id);
            if (customer != null)
            {
                /*employee.Id = employee.Id;
                employee.BadgeId = employee.BadgeId;*/
                customer.FullName = request.FullName;
                customer.Address = request.Address;
                customer.PhoneNumber = request.PhoneNumber;
            }
            await Repository.UpdateAsync(customer);
        }

        public async Task UpdateAvatarCustomer(IUpdateAvatarCustomer.RequestUpdateAvatar request)
        {
            var customer = await Repository.FindByIdAsync(e => e.Id.Equals(request.Id));
            var fileName = "";
            if (request.Image != null)
            {
                string folder = "Images\\Customers";
                fileName = request.Id + "_" + request.Image.FileName;
                string path = _webHostEnvironment.WebRootPath + '\\' + folder;
                string serverFolder = Path.Combine(path, fileName);
                await request.Image.CopyToAsync(new FileStream(serverFolder, FileMode.Create));
            }
            if (customer != null)
            {
                customer.Image = fileName;
            }
            await Repository.UpdateAsync(customer);
        }

        public async Task<dynamic> GetAllCustomer()
        {
            return await Repository.GetAllCustomer();
        }

        public async Task<PaginatedList<dynamic>> GetCustomers(IGetCustomers.GetCustomersRequest request)
        {
            var customerList = await Repository.GetCustomersByCondition(request.Name, request.Address);
            return await PaginatedList<dynamic>.CreateAsync(customerList, request.CurrentPage, request.RowsPerPage);
        }
    }
}
