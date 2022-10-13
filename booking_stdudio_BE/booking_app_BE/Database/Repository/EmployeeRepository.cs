using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class EmployeeRepository : BaseRepository<Employee>, IEmployeeRepository
    {
        private readonly DbSet<Employee> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public EmployeeRepository(BookingStudioContext bookingStudioContext, IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Employee>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddEmployee.Response> CreateEmployee(IAddEmployee.Request request)
        {
            try
            {
                var fileName = "";
                if (request.Image != null)
                {
                    string folder = "Images";
                    fileName = request.BadgeId + "_" + request.Image.FileName;
                    string path = _webHostEnvironment.WebRootPath + '\\' + folder;
                    string serverFolder = Path.Combine(path, fileName);
                    await request.Image.CopyToAsync(new FileStream(serverFolder, FileMode.Create));
                }
                if (!_dbSet.Any(x => x.BadgeId == request.BadgeId))
                {
                    var employee = new Employee()
                    {
                        BadgeId = request.BadgeId,
                        Name = request.FirstName + ' ' + request.LastName,
                        Email = request.Email,
                        Image = fileName
                    };
                    _dbContext.Set<Employee>().Add(employee);
                    await _dbContext.SaveChangesAsync();
                }
                return new IAddEmployee.Response(200, "success");  
            } catch
            {
                return new IAddEmployee.Response(500, "error");
            }
            
        }

        public async Task<IQueryable<dynamic>> GetEmployeeByCondition(string name, SortOrderDto.SortHeader? sortHeader, SortOrderDto.SortOrder? sortOrder)
        {
            var queryable = _dbSet.AsNoTracking();
            
            if (!string.IsNullOrEmpty(name))
            {
                queryable = queryable.Where(x => x.Name.Contains(name));   
            }
            
            var result = queryable.Select(s => new
            {
                id = s.Id,
                badgeId = s.BadgeId,
                name = s.Name,
                email = s.Email,
                image = s.Image
            });
            
            switch (sortHeader)
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
            }
            await Task.Delay(1);
            return result;
        }

    }
}
