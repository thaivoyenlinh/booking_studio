using booking_app_BE.Businesses.Boundaries.Employee;
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
    public class EmployeeService : BaseService<Employee, IEmployeeRepository>, IEmployeeService
    {
        private readonly BookingStudioContext _dbContext;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public EmployeeService(
            IEmployeeRepository employeeRepository,
            BookingStudioContext dbContext,
            UserManager<IdentityUser> userManager,
            IWebHostEnvironment webHostEnvironment) : base(employeeRepository)
        {
            _dbContext = dbContext;
            _userManager = userManager;
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddEmployee.Response> CreateEmployee(IAddEmployee.Request request)
        {
            var response = await Repository.CreateEmployee(request);
            return response;
        }
        public async Task<PaginatedList<dynamic>> GetEmployee(IGetEmployees.Request request)
        {
            var employeesList = await Repository.GetEmployeeByCondition(request.Name, request.SortHeader, request.SortOrder);
            return await PaginatedList<dynamic>.CreateAsync(employeesList, request.CurrentPage, request.RowsPerPage);
        }

        public async Task<IGetEmployeeDetails.Response> GetEmployeeDetails(IGetEmployeeDetails.Request request)
        {
            var user = await Repository.FindByIdAsync(x => x.EmployeeAccountId == request.EmployeeAccountId.ToString());  
            var account = await _userManager.FindByIdAsync(user.EmployeeAccountId);
            return new IGetEmployeeDetails.Response
            {
                    Id = user.Id,
                    BadgeId = user.BadgeId,
                    Name = user.Name,
                    Email = user.Email,
                    Image = user.Image,
                    Username = account.UserName,
                    Password = user.AccountPasswordGenerate,
                    PhoneNumber = user.PhoneNumber,
                    Rating = _dbContext.Set<Schedule>().Where(e => e.EmployeeId == user.Id).Select(e => e.EmployeeRating).Average().ToString(),
            };
        }

        public async Task UpdateEmployee(IUpdateEmployee.Request request)
        {
            var employee = await Repository.FindByIdAsync(x => x.Id == request.Id);
            if(employee != null)
            {
                /*employee.Id = employee.Id;
                employee.BadgeId = employee.BadgeId;*/
                employee.Name = request.FirstName + ' ' + request.LastName;
                employee.Email = request.Email;
                employee.PhoneNumber = request.PhoneNumber;
            }
            await Repository.UpdateAsync(employee);
        }

        public async Task<List<IGetEmployeesByServiceId.DetailsEmployee>> GetEmployeesByService(List<int> employeeId)
        {
            var result = await Repository.GetEmployeesByService(employeeId);
            return result;
        }

        public async Task UpdateAvatarEmployee(IUpdateAvatarEmployee.RequestUpdateAvatar request)
        {
            var employee = await Repository.FindByIdAsync(e => e.Id.Equals(request.Id));
            var fileName = "";
            if (request.Image != null)
            {
                string folder = "Images\\";
                fileName = request.Id + "_" + request.Image.FileName;
                string path = _webHostEnvironment.WebRootPath + '\\' + folder;
                string serverFolder = Path.Combine(path, fileName);
                await request.Image.CopyToAsync(new FileStream(serverFolder, FileMode.Create));
            }
            if (employee != null)
            {
                employee.Image = fileName;
            }
            await Repository.UpdateAsync(employee);
        }
    }
}
