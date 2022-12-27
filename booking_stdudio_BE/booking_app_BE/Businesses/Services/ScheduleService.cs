using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class ScheduleService : BaseService<Schedule, IScheduleRepository>, IScheduleService
    {
        private readonly BookingStudioContext _dbContext;
        private readonly IReceiptService _receiptService;
        public ScheduleService(
            IScheduleRepository scheduleRepository,
            IReceiptService receiptService,
            BookingStudioContext dbContext) : base(scheduleRepository)
        {
            _dbContext = dbContext;
            _receiptService = receiptService;   
        }

        public Task<IAddSchedule.AddScheduleResponse> CreateSchedule(IAddSchedule.AddScheduleRequest request)
        {
            var response = Repository.CreateSchedule(request);
            return response;
        }

        public async Task<List<DateDays>> GetDaysByEmployee(int employeeId)
        {
            var scheduleList = await Repository.GetScheduleByEmployee(employeeId);
            List<DateDays> allDates = new List<DateDays>();

            DateTime startingDate = DateTime.Today.AddDays(1);
            DateTime endingDate = DateTime.Today.AddDays(+14);

            for (DateTime date = startingDate; date <= endingDate; date = date.AddDays(1))
            {
                var tmpDate = date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString();
                var result = scheduleList.Where(s => s.Dates.Contains(tmpDate) && s.DatesReschedule==null).Any();
                var dateReschdeule = scheduleList.Where(s => s.DatesReschedule != null && s.Dates != null && s.DatesReschedule.Contains(tmpDate)).Any();
                var available = true;
                if ((result == false  && dateReschdeule == true) || (result == true && dateReschdeule == false))
                {
                    available = !available;
                }
                allDates.Add(
                    new DateDays()
                    {
                        MyDays = date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString(),
                        Available = available
                    }
                );
            }
            return allDates;
        }

        public async Task<IGetRatingBySchedule.RatingByScheduleResponse> GetRatingBySchedule(int scheduleId)
        {
            var result = await Repository.FindByIdAsync(x => x.Id == scheduleId);
            return new IGetRatingBySchedule.RatingByScheduleResponse
            {
                EmployeeRating = result.EmployeeRating
            };
        }

        public async Task<IGetScheduleDetails.ScheduleDetailsResponse> GetScheduleDetails(int scheduleId)
        {
            var result = await Repository.FindByIdAsync(x => x.Id == scheduleId);
            return new IGetScheduleDetails.ScheduleDetailsResponse
            {
                ScheduleId = result.Id,
                Date = result.Date,
                Status = result.Status,
                EmployeeId = result.EmployeeId,
                EmployeeName = _dbContext.Set<Employee>().Where(e => e.Id == result.EmployeeId).Select(e => e.Name).Single(),
                EmployeePhoneNumber = _dbContext.Set<Employee>().Where(e => e.Id == result.EmployeeId).Select(e => e.PhoneNumber).Single(),
                EmployeeImage = _dbContext.Set<Employee>().Where(e => e.Id == result.EmployeeId).Select(e => e.Image).Single(),
                ServiceName = _dbContext.Set<Service>().Where(e => e.Id == result.ServiceId).Select(e => e.ServiceName).Single(),
                Total = result.Total,
                CustomerName = _dbContext.Set<Customer>().Where(e => e.Id == result.CustomerId).Select(e => e.FullName).Single(),
                CustomerPhoneNumber = _dbContext.Set<Customer>().Where(e => e.Id == result.CustomerId).Select(e => e.PhoneNumber).Single(),
                CustomerImage = _dbContext.Set<Customer>().Where(e => e.Id == result.CustomerId).Select(e => e.Image).Single(),
                EmployeeBookingDays = await GetDaysByEmployee(result.EmployeeId)
            };
        }

        public async Task<PaginatedList<dynamic>> GetSchedules(IGetSchedules.GetSchedulesRequest request)
        {
            var scheduleList = await Repository.GetSchedulesByCondition(request.Date, request.Status, request.SortHeader, request.SortOrder);
            return await PaginatedList<dynamic>.CreateAsync(scheduleList, request.CurrentPage, request.RowsPerPage);
        }

        public async Task<IEnumerable<dynamic>> GetSchedulesByCustomer(IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request)
        {
            return await Repository.GetSchedulesByCustomer(request);
        }

        public async Task<IEnumerable<dynamic>> GetSchedulesByEmployee(IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request)
        {
            return await Repository.GetSchedulesByEmployee(request);
        }

        public async Task UpdateRatingSchedule(IUpdateRatingSchedule.UpdateRatingRequest request)
        {
            var schedule = await Repository.FindByIdAsync(x => x.Id == request.ScheduleId && x.Status.Equals("Completed"));
            if(schedule != null)
            {
                schedule.EmployeeRating = request.EmployeeRating;
                schedule.ServiceRating = request.ServiceRating;
            }
            await Repository.UpdateAsync(schedule);
        }

        public async Task UpdateRescheduleSchedule(IUpdateRescheduleSchedule.UpdateRescheduleRequest request)
        {
            var schedule = await Repository.FindByIdAsync(x => x.Id == request.ScheduleId);
            if(schedule != null)
            {
                //case user cancel or update time and schedule does not any confirm by staff 
                //with update time can update many time if schedule does not any confirm And dont save UpdateDate
                if(schedule.Status == "Pending" || schedule.Status == "Updated")
                {
                    schedule.ReScheduleType = request.RescheduleType.ToString();
                    if (request.RescheduleType.ToString().Equals("UpdateTime") && request.Days != null)
                    {
                        schedule.Status = "Updated";
                        schedule.Date = request.Days;
                    }
                    if (request.RescheduleType.ToString().Equals("Cancel"))
                    {
                        schedule.Status = "Cancelled";
                        //schedule.Date = "";
                    }
                    await Repository.UpdateAsync(schedule);
                }
   
                if(schedule.Status == "WaitingConfirmRescheule" && schedule.ReScheduleType == "Cancel")
                {
                    schedule.Status = "Cancelled";
                    //schedule.Date = "";
                    schedule.UpdatedDate = DateTime.Now;
                    await Repository.UpdateAsync(schedule);
                }
                if (schedule.Status == "WaitingConfirmRescheule" && schedule.ReScheduleType == "UpdateTime")
                {
                    schedule.Status = "Updated";
                    schedule.UpdatedDate = DateTime.Now;
                    await Repository.UpdateAsync(schedule);
                }

                //case schedule was confirm.
                //If user cancel or update time will update status is "WaitingConfirmRescheule" and wait a confirmation from staff
                if (schedule.Status == "Confirmed" && request.RescheduleType.ToString().Equals("Cancel"))
                {
                    schedule.ReScheduleType = request.RescheduleType.ToString();
                    schedule.Status = "WaitingConfirmRescheule";
                    schedule.UpdatedDate = DateTime.Now;
                    await Repository.UpdateAsync(schedule);
                }
                if (schedule.Status == "Confirmed" && request.RescheduleType.ToString().Equals("UpdateTime"))
                {
                    schedule.ReScheduleType = request.RescheduleType.ToString();
                    schedule.Status = "WaitingConfirmRescheule";
                    schedule.DateReSchedule = request.Days;
                    schedule.UpdatedDate = DateTime.Now;
                    await Repository.UpdateAsync(schedule);
                }
            }
        }

        public async Task UpdateStatusSchedule(IUpdateStatusSchedule.UpdateRequest request)
        {
            var schedule = await Repository.FindByIdAsync(x => x.Id == request.ScheduleId);
            if (schedule != null)
            {
                schedule.Status = request.Status.ToString();
            }
            await Repository.UpdateAsync(schedule);
            if (request.Status.ToString().Equals("Completed"))
            {
                IAddReceipt.AddReceiptRequest requestAddReceipt = new IAddReceipt.AddReceiptRequest
                {
                    ScheduleId = request.ScheduleId,
                    Total = decimal.Parse(schedule.Total),
                    CreateDate = DateTime.Now
                };
                await _receiptService.CreateReceipt(requestAddReceipt);
            }
        }
    }

    public class DateDays
    {
        public string MyDays { get; set; }
        public bool Available { get; set; }
    }
}
