using booking_app_BE.Businesses.Boundaries.Absence;
using Microsoft.AspNetCore.Mvc;
using static booking_app_BE.Businesses.Boundaries.Absence.IGetDayOffByEmployee;

namespace booking_app_BE.Apis.Absence
{
    [ApiController]
    [Route("absence")]
    public class AbsenceController : Controller
    {
        private readonly IGetDayOffByEmployee _getDayOffByEmployee;
        private readonly IAddAbsence _addAbsence;
        private readonly IGetAbsencesByEmployee _getAbsenceByEmployee;
        private readonly IUpdateStatusAbsence _updateStatusAbsence;
        private readonly IGetAbsences _getAbsences;

        public AbsenceController(IGetDayOffByEmployee getDayOffByEmployee, IAddAbsence addAbsence,
            IGetAbsencesByEmployee getAbsenceByEmployee, IUpdateStatusAbsence updateStatusAbsence, 
            IGetAbsences getAbsences)
        {
            _getDayOffByEmployee = getDayOffByEmployee;
            _addAbsence = addAbsence;
            _getAbsenceByEmployee = getAbsenceByEmployee;
            _updateStatusAbsence = updateStatusAbsence;
            _getAbsences = getAbsences;
        }

        [HttpGet("getNextThirdtyDaysDate")]
        public async Task<IActionResult> GetNextThirdtyDaysDate()
        {
            List<string> allDates = new List<string>();

            DateTime startingDate = DateTime.Today.AddDays(+15);
            DateTime endingDate = DateTime.Today.AddDays(+30);

            for (DateTime date = startingDate; date <= endingDate; date = date.AddDays(1))
            {
                allDates.Add(date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString());
            }
            return Ok(allDates);
        }

        [HttpGet("getDayOffDayByEmployee")]
        public async Task<List<DayOffSDate>> GetBookingDayByEmployee(int employeeId)
        {
            return await _getDayOffByEmployee.ExecuteAsync(employeeId);
        }

        [HttpPost("addAbsence")]
        public async Task<IActionResult> AddAbsence([FromBody] IAddAbsence.AddAbsenceRequest request)
        {
            var response = await _addAbsence.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpGet("getAbsencesByEmployee")]
        public async Task<IEnumerable<dynamic>> GetAbsencesByEmployee([FromQuery] IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request)
        {
            return await _getAbsenceByEmployee.ExecuteAsync(request);
        }
        [HttpPost("updateStatusAbsence")]
        public async Task UpdateStatusAbsence([FromQuery] IUpdateStatusAbsence.UpdateStatusRequest request)
        {
            await _updateStatusAbsence.ExecuteAsync(request);
        }

        [HttpGet("pagination")]
        public async Task<IActionResult> GetAbsencesByConditions(
            [FromQuery(Name = "Name")] string? name,
            /*[FromQuery(Name = "SortHeader")] SortOrderDto.SortHeader? sortHeader,
            [FromQuery(Name = "SortOrder")] SortOrderDto.SortOrder? sortOrder,*/
            [FromQuery(Name = "CurrentPage")] int currentPage,
            [FromQuery(Name = "RowsPerPage")] int rowsPerPage
            )
        {
            var response = await _getAbsences.ExecuteAsync(
                new IGetAbsences.GetAbsencesRequest(name, currentPage, rowsPerPage));
            return Ok(response);
        }

    }
}
