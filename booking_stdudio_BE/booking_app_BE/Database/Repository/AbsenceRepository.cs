using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class AbsenceRepository : BaseRepository<Absence>, IAbsenceRepository
    {
        private readonly DbSet<Absence> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public AbsenceRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Absence>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddAbsence.AddAbsenceResponse> CreateAbsence(IAddAbsence.AddAbsenceRequest request)
        {
            try
            {
                if (request != null)
                {
                    var absence = new Absence
                    {
                        EmployeeId = request.EmployeeId,
                        Date = request.Date,
                        Status = request.Status.ToString(),
                        Reason = request.Reason,
                    };
                    _dbContext.Set<Absence>().Add(absence);
                    await _dbContext.SaveChangesAsync();
                    return new IAddAbsence.AddAbsenceResponse(200, "Your request has been sent successfully!");
                }
                else { return new IAddAbsence.AddAbsenceResponse(200, "success"); }
            }
            catch
            {
                return new IAddAbsence.AddAbsenceResponse(500, "Your request has been sent failed!");
            }
        }

        public async Task<IQueryable<dynamic>> GetAbsencesByCondition(string name)
        {
            var queryable = _dbSet.AsNoTracking();

            /*if (!string.IsNullOrEmpty(name))
            {
                queryable = queryable.Where(x => x.Em.Contains(name));
            }*/

            /*if (!string.IsNullOrEmpty(status))
            {
                queryable = queryable.Where(x => x.Status.Contains(status));
            }*/

            var result = queryable.Select(s => new
            {
                id = s.Id,
                status = s.Status,
                employeeName = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Name).Single(),
                date = s.Date,
            });

            if (!string.IsNullOrEmpty(name))
            {
                result = result.Where(x => x.employeeName.Contains(name));
            }

            /*switch (sortHeader)
            {
                case SortOrderDto.SortHeaderSchedule.Date:
                    result = sortOrder == SortOrderDto.SortOrderSchedule.ASC
                        ? result.OrderBy(x => x.date).ThenBy(x => x.serviceName)
                        : result.OrderByDescending(x => x.date).ThenBy(x => x.serviceName);
                    break;
            }*/
            await Task.Delay(1);
            return result;
        }

        public async Task<List<IGetAbsencesByEmployee.GetAbsencesByEmployeeReponse>> GetAbsencesByEmployee(IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request)
        {
            var queryable = _dbSet.AsNoTracking();
            return queryable.Where(s => s.EmployeeId == request.EmployeeId).Select(s => new IGetAbsencesByEmployee.GetAbsencesByEmployeeReponse
            {
                Date = s.Date,
                Reason = s.Reason,
                Status = s.Status.ToString(),
            }).ToList();
        }

        public async Task<List<DateOff>> GetDayOffByEmployee(int employeeId)
        {
            var result = await _dbSet.AsNoTracking().Where(s => s.EmployeeId == employeeId).Select(s => new DateOff
            {
                Dates = s.Date,
            }).ToListAsync();
            return result;
        }

        public class DateOff
        {
            public List<string> Dates { get; set; }
        }
    }
}
