using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Employee
{
    [ApiController]
    [Route("employee")]
    public class EmployeeController : ControllerBase
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IAddEmployee _addEmployee;
        private readonly IGetEmployees _getEmployees;
        private readonly IGetEmployeeDetails _getEmployeeDetails;
        private readonly IUpdateEmployee _updateEmployee;
        private readonly IDeleteEmployee _deleteEmployee;

        public EmployeeController(
            IWebHostEnvironment webHostEnvironment,
            IAddEmployee addEmployee,
            IGetEmployees getEmployees,
            IGetEmployeeDetails getEmployeeDetails,
            IUpdateEmployee updateEmployee,
            IDeleteEmployee deleteEmployee
            )
        {
            _webHostEnvironment = webHostEnvironment;
            _addEmployee = addEmployee;
            _getEmployees = getEmployees;
            _getEmployeeDetails = getEmployeeDetails;
            _updateEmployee = updateEmployee;
            _deleteEmployee = deleteEmployee;
        }

        [HttpPost("add")]
        //[Authorize]
        public async Task<IActionResult> AddEmployee([FromForm] IAddEmployee.Request request)
        {
            var response = await _addEmployee.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpGet("pagination")]
        public async Task<IActionResult> GetEmployeesByConditions(
            [FromQuery(Name = "Name")] string? name,
            [FromQuery(Name = "SortHeader")] SortOrderDto.SortHeader? sortHeader,
            [FromQuery(Name = "SortOrder")] SortOrderDto.SortOrder? sortOrder,
            [FromQuery(Name = "CurrentPage")] int currentPage,
            [FromQuery(Name = "RowsPerPage")] int rowsPerPage
            )
        {
            var response = await _getEmployees.ExecuteAsync(
                new IGetEmployees.Request(name, sortHeader, sortOrder, currentPage, rowsPerPage));
            return Ok(response);
        }

        [HttpGet("details")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetEmployeeDetails([FromQuery] IGetEmployeeDetails.Request request)
        {
            var response = await _getEmployeeDetails.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpPut("update")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IUpdateEmployee.Request))]
        public async Task<IActionResult> UpdateEmployee([FromBody] IUpdateEmployee.Request request)
        {
            await _updateEmployee.ExecuteAsync(request);
            return Ok();
        }

        [HttpDelete("delete")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> DeleteEmployee([FromQuery] IDeleteEmployee.Request request)
        {
            var response = await _deleteEmployee.DeleteAsync(request);
            return Ok(response);
        }

    }
}
