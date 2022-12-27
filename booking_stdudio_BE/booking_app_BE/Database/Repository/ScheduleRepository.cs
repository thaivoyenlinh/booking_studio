using booking_app_BE.Apis.Schedule.Dtos;
using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class ScheduleRepository : BaseRepository<Schedule>, IScheduleRepository
    {
        private readonly DbSet<Schedule> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public ScheduleRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Schedule>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddSchedule.AddScheduleResponse> CreateSchedule(IAddSchedule.AddScheduleRequest request)
        {
            try
            {
                if(request != null)
                {
                    var schedule = new Schedule
                    {
                        CustomerId = request.CustomerId,
                        EmployeeId = request.EmployeeId,
                        ServiceId = request.ServiceId,
                        Date = request.Date,
                        Status = request.Status.ToString(),
                        Total = request.Total,
                        CreatedDate = DateTime.Now
                        //ReScheduleType = "None"
                    };
                    _dbContext.Set<Schedule>().Add(schedule);
                    await _dbContext.SaveChangesAsync();
                    return new IAddSchedule.AddScheduleResponse(200, "success");
                } else { return new IAddSchedule.AddScheduleResponse(200, "success"); }
            } catch 
            {
                return new IAddSchedule.AddScheduleResponse(500, "error");
            }
        }

        public async Task<List<MyDate>> GetScheduleByEmployee(int employeeId)
        {
            var result = await _dbSet.AsNoTracking().Where(s => s.EmployeeId == employeeId && !s.Status.Equals("Completed") && !s.Status.Equals("Cancelled")).Select(s => new MyDate
            {
                Dates = s.Date,
                DatesReschedule = s.DateReSchedule
            }).ToListAsync();
            return result;
        }

        public async Task<IQueryable<dynamic>> GetSchedulesByCondition(string date, string status, SortOrderDto.SortHeaderSchedule? sortHeader, SortOrderDto.SortOrderSchedule? sortOrder)
        {
            var queryable = _dbSet.AsNoTracking();

            if (!string.IsNullOrEmpty(date))
            {
                queryable = queryable.Where(x => x.Date.Contains(date));
            }

            if (!string.IsNullOrEmpty(status))
            {
                queryable = queryable.Where(x => x.Status.Contains(status));
            }

            var result = queryable.Select(s => new
            {
                id = s.Id,
                status = s.Status,
                customerName = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.FullName).Single(),
                employeeName = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Name).Single(),
                serviceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                date = s.Date,
                dateReschedule = s.DateReSchedule,
                total = s.Total,
            });

            switch (sortHeader)
            {
                case SortOrderDto.SortHeaderSchedule.Date:
                    result = sortOrder == SortOrderDto.SortOrderSchedule.ASC
                        ? result.OrderBy(x => x.date).ThenBy(x => x.serviceName)
                        : result.OrderByDescending(x => x.date).ThenBy(x => x.serviceName);
                    break;
            }
            await Task.Delay(1);
            return result;
        }

        public async Task<List<IGetSchedulesByCustomer.GetSchedulesByCustomerReponse>> GetSchedulesByCustomer(IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request)
        {
            var queryable = _dbSet.AsNoTracking();
            if (request.ScheduleComplete)
            {
                var schedules = queryable
                    .Where(s => s.CustomerId == request.CustomerId && (s.Status.Equals("Completed") || (s.Status.Equals("Cancelled") && s.ReScheduleType.Equals("Cancel"))))
                    .OrderByDescending(s => s.Id).Select(s => new IGetSchedulesByCustomer.GetSchedulesByCustomerReponse
                {
                    Id = s.Id,
                    Date = s.Date,
                    Status = s.Status,
                    Total = s.Total,
                    EmployeeRating = s.EmployeeRating,
                    EmployeeName = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Name).Single(),
                    EmployeePhoneNumber = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.PhoneNumber).Single(),
                    EmployeeImage = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Image).Single(),
                    ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                    ServiceRating = s.ServiceRating
                }).ToList();
                return schedules;
            } else if(request.WaitingConfirmReschedule.HasValue && request.WaitingConfirmReschedule == true)
            {
                var schedules = queryable
                .Where(s => s.CustomerId == request.CustomerId && s.Status.Equals("WaitingConfirmRescheule"))
                .OrderByDescending(s => s.Id).Select(s => new IGetSchedulesByCustomer.GetSchedulesByCustomerReponse
                {
                    Id = s.Id,
                    Date = s.Date,
                    Status = s.Status,
                    ReScheduleType = s.ReScheduleType,
                    Total = s.Total,
                    EmployeeRating = s.EmployeeRating,
                    EmployeeName = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Name).Single(),
                    EmployeePhoneNumber = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.PhoneNumber).Single(),
                    EmployeeImage = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Image).Single(),
                    ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                    ServiceRating = s.ServiceRating
                }).ToList();
                return schedules;
            }
            else
            {
                var schedules = queryable.Where(s => s.CustomerId == request.CustomerId && (!s.Status.Equals("WaitingConfirmRescheule")) && (!s.Status.Equals("Completed") && !(s.Status.Equals("Cancelled") && s.ReScheduleType.Equals("Cancel")))).OrderBy(x => x.Date).Select(s => new IGetSchedulesByCustomer.GetSchedulesByCustomerReponse
                {
                    Id = s.Id,
                    Date = s.Date,
                    DateReschedule = s.DateReSchedule,
                    Status = s.Status,
                    Total = s.Total,
                    EmployeeRating = s.EmployeeRating,
                    EmployeeName = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Name).Single(),
                    EmployeePhoneNumber = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.PhoneNumber).Single(),
                    EmployeeImage = _dbContext.Set<Employee>().AsNoTracking().Where(e => e.Id == s.EmployeeId).Select(e => e.Image).Single(),
                    ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                    ServiceRating = s.ServiceRating
                }).ToList();
                return schedules;
            }
        }

        public async Task<List<IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse>> GetSchedulesByEmployee(IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request)
        {
            var queryable = _dbSet.AsNoTracking();
            //Appointment History Page of Staff
            if (request.History)
            {
                return queryable
                    .Where(s => s.EmployeeId == request.EmployeeId && (s.Status.Equals("Completed") || (s.Status.Equals("Cancelled") && s.ReScheduleType.Equals("Cancel"))))
                    .OrderByDescending(x => x.CreatedDate).Select(s => new IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse
                    {
                        Id = s.Id,
                        Date = s.Date,
                        Status = s.Status,
                        Total = s.Total,
                        EmployeeRating = s.EmployeeRating,
                        CustomerName = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.FullName).Single(),
                        CustomerPhoneNumber = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.PhoneNumber).Single(),
                        CustomerImage = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.Image).Single(),
                        ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                        ServiceRating = s.ServiceRating
                    }).ToList();
            } else
            {
                //Appointment Peding Page of Staff
                if (request.Status.ToString().Equals("Pending"))
                {
                    return queryable
                                .Where(s => s.EmployeeId == request.EmployeeId && (s.Status.Equals("Pending")))
                                .OrderBy(x => x.Date).Select(s => new IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse
                                {
                                    Id = s.Id,
                                    Date = s.Date,
                                    Status = s.Status,
                                    Total = s.Total,
                                    //EmployeeRating = s.EmployeeRating,
                                    CustomerName = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.FullName).Single(),
                                    CustomerPhoneNumber = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.PhoneNumber).Single(),
                                    CustomerImage = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.Image).Single(),
                                    ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                                    //ServiceRating = s.ServiceRating
                                }).ToList();
                } 
                //case for notify page
                else if (request.Status.ToString().Equals("WaitingConfirmRescheule"))
                {
                    return queryable
                            .Where(s => s.EmployeeId == request.EmployeeId 
                                && (s.Status.Equals("WaitingConfirmRescheule") 
                                || (s.Status.Equals("Cancelled") && s.ReScheduleType.Equals("Cancel") && s.UpdatedDate !=  null)
                                || (s.Status.Equals("Updated") && s.ReScheduleType.Equals("UpdateTime") && s.UpdatedDate != null)
                                ))
                            .OrderByDescending(x => x.UpdatedDate).Select(s => new IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse
                            {
                                Id = s.Id,
                                Date = s.Date,
                                Status = s.Status,
                                Total = s.Total,
                                CustomerName = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.FullName).Single(),
                                CustomerPhoneNumber = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.PhoneNumber).Single(),
                                CustomerImage = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.Image).Single(),
                                ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                                UpdateTime = s.UpdatedDate.ToString(),
                                ReScheduleType = s.ReScheduleType,
                                DateReschedule = s.DateReSchedule
                            }).ToList();
                }
                else 
                {
                    //Appointment Confirm page of Staff
                    return queryable 
                            .Where(s => s.EmployeeId == request.EmployeeId && ( s.Status.Equals("Confirmed") || ( s.Status.Equals("Updated") && s.ReScheduleType.Equals("UpdateTime") )) )
                            .OrderByDescending(x => x.ReScheduleType).ThenBy(x => x.Date).Select(s => new IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse
                            {
                                Id = s.Id,
                                Date = s.Date,
                                Status = s.Status,
                                Total = s.Total,
                                //EmployeeRating = s.EmployeeRating,
                                CustomerName = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.FullName).Single(),
                                CustomerPhoneNumber = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.PhoneNumber).Single(),
                                CustomerImage = _dbContext.Set<Customer>().AsNoTracking().Where(e => e.Id == s.CustomerId).Select(e => e.Image).Single(),
                                ServiceName = _dbContext.Set<Service>().AsNoTracking().Where(e => e.Id == s.ServiceId).Select(e => e.ServiceName).Single(),
                                //ServiceRating = s.ServiceRating
                                DateReschedule = s.DateReSchedule,
                                UpdateTime = s.UpdatedDate.ToString(),
                                ReScheduleType = s.ReScheduleType
                            }).ToList();
                }
            }
        }

        /*public async Task<dynamic> GetSchedulesDetails(int scheduleId)
        {
            await _dbSet.AsNoTracking().Where(s => s.Id == scheduleId);
        }
*/
        public class MyDate
        {
            public string Dates { get; set; }
            public string? DatesReschedule { get; set; }
        }
    }
}
