using booking_app_BE.Apis.Schedule.Dtos;
using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace booking_app_BE.Apis.Schedule
{
    [ApiController]
    [Route("schedule")]
    public class ScheduleController : Controller
    {
        private readonly IAddSchedule _addSchedule;
        private readonly IGetBookingDaysByEmployee _getBookingDaysByEmployee;
        private readonly IUpdateStatusSchedule _updateStatusSchedule;
        private readonly IGetSchedulesByCustomer _getSchedulesByCustomer;
        private readonly IUpdateRatingSchedule _updateRatingSchedule;
        private readonly IGetRatingBySchedule _getRatingBySchedule;
        private readonly IUpdateRescheduleSchedule _updateRescheduleSchedule;
        private readonly IGetScheduleDetails _getScheduleDetails;
        private readonly IGetSchedulesByEmployee _getSchedulesByEmployee;
        private readonly IGetSchedules _getSchedules;
        public ScheduleController(IAddSchedule addSchedule,
            IGetBookingDaysByEmployee getBookingDaysByEmployee,
            IUpdateStatusSchedule updateStatusSchedule,
            IGetSchedulesByCustomer getSchedulesByCustomer,
            IUpdateRatingSchedule updateRatingSchedule,
            IGetRatingBySchedule getRatingBySchedule,
            IUpdateRescheduleSchedule updateRescheduleSchedule,
            IGetScheduleDetails getScheduleDetails,
            IGetSchedulesByEmployee getSchedulesByEmployee,
            IGetSchedules getSchedules
            )
        {
            _addSchedule = addSchedule;
            _getBookingDaysByEmployee = getBookingDaysByEmployee;
            _updateStatusSchedule = updateStatusSchedule;
            _getSchedulesByCustomer = getSchedulesByCustomer;
            _updateRatingSchedule = updateRatingSchedule;
            _getRatingBySchedule = getRatingBySchedule;
            _updateRescheduleSchedule = updateRescheduleSchedule;
            _getScheduleDetails = getScheduleDetails;
            _getSchedulesByEmployee = getSchedulesByEmployee;
            _getSchedules = getSchedules;
        }

        [HttpGet("getNextFourteenDaysDate")]
        //[Authorize]
        public async Task<IActionResult> getNextFourteenDaysDate()
        {
            List<string> allDates = new List<string>();

            DateTime startingDate = DateTime.Today.AddDays(1);
            DateTime endingDate = DateTime.Today.AddDays(+14);

            for (DateTime date = startingDate; date <= endingDate; date = date.AddDays(1))
            {
                allDates.Add(date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString());
            }
            return Ok(allDates);
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddEmployee([FromForm] IAddSchedule.AddScheduleRequest request)
        {
            var response = await _addSchedule.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpGet("getBookingDayByEmployee")]
        public async Task<List<DateDays>> getBookingDayByEmployee(int employeeId)
        {
            return await _getBookingDaysByEmployee.ExecuteAsync(employeeId);
        }

        [HttpPost("updateStatusSchedule")]
        public async Task UpdateStatusSchedule([FromQuery] IUpdateStatusSchedule.UpdateRequest request)
        {
            await _updateStatusSchedule.ExecuteAsync(request); 
        }

        [HttpGet("getSchedulesByCustomer")]
        public async Task<IEnumerable<dynamic>> GetSchedulesByCustomer([FromQuery] IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request)
        {
            return await _getSchedulesByCustomer.ExecuteAsync(request);
        }

        [HttpPost("updateRating")]
        public async Task UpdateRatingSchedule([FromQuery] IUpdateRatingSchedule.UpdateRatingRequest request)
        {
            await _updateRatingSchedule.ExecuteAsync(request);
        }

        [HttpGet("getRatingBySchedule")]
        public async Task<dynamic> GetRatingBySchedule(int scheduleId)
        {
            return await _getRatingBySchedule.ExecuteAsync(scheduleId);
        }

        [HttpPost("updateReschedule")]
        public async Task UpdateRatingSchedule([FromQuery] IUpdateRescheduleSchedule.UpdateRescheduleRequest request)
        {
            await _updateRescheduleSchedule.ExecuteAsync(request);
        }

        [HttpGet("getScheduleDetais")]
        public async Task<IGetScheduleDetails.ScheduleDetailsResponse> GetScheduleDetais(int scheduleId)
        {
            return await _getScheduleDetails.ExecuteAsync(scheduleId);
        }

        [HttpGet("getSchedulesByEmployee")]
        public async Task<IEnumerable<dynamic>> GetSchedulesByEmployee([FromQuery] IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request)
        {
            return await _getSchedulesByEmployee.ExecuteAsync(request);
        }

        [HttpGet("pagination")]
        public async Task<IActionResult> GetSchedulesByConditions(
            [FromQuery(Name = "Date")] string? date,
            [FromQuery(Name = "Status")] string? status,
            [FromQuery(Name = "SortHeader")] SortOrderDto.SortHeaderSchedule? sortHeader,
            [FromQuery(Name = "SortOrder")] SortOrderDto.SortOrderSchedule? sortOrder,
            [FromQuery(Name = "CurrentPage")] int currentPage,
            [FromQuery(Name = "RowsPerPage")] int rowsPerPage
            )
        {
            var response = await _getSchedules.ExecuteAsync(
                new IGetSchedules.GetSchedulesRequest(date, status, sortHeader, sortOrder, currentPage, rowsPerPage));
            return Ok(response);
        }
    }
}
