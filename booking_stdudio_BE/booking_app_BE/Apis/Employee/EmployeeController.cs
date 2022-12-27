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
        private readonly IAddEmployee _addEmployee;
        private readonly IGetEmployees _getEmployees;
        private readonly IGetEmployeeDetails _getEmployeeDetails;
        private readonly IUpdateEmployee _updateEmployee;
        private readonly IDeleteEmployee _deleteEmployee;
        private readonly IGetEmployeesByServiceId _getEmployeesByServiceId;
        private readonly IUpdateAvatarEmployee _updateAvatarEmployee;

        public EmployeeController(
            IAddEmployee addEmployee,
            IGetEmployees getEmployees,
            IGetEmployeeDetails getEmployeeDetails,
            IUpdateEmployee updateEmployee,
            IDeleteEmployee deleteEmployee,
            IGetEmployeesByServiceId getEmployeesByServiceId,
            IUpdateAvatarEmployee updateAvatarEmployee
            )
        {
            _addEmployee = addEmployee;
            _getEmployees = getEmployees;
            _getEmployeeDetails = getEmployeeDetails;
            _updateEmployee = updateEmployee;
            _deleteEmployee = deleteEmployee;
            _getEmployeesByServiceId = getEmployeesByServiceId;
            _updateAvatarEmployee = updateAvatarEmployee;
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

        [HttpPost("details")]
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

        [HttpGet("getEmployeesByServiceId")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<List<IGetEmployeesByServiceId.DetailsEmployee>> GetEmployeesByServiceId([FromQuery] int serviceId)
        {
            return await _getEmployeesByServiceId.ExecuteAsync(serviceId);
        }

        [HttpPost("updateImageAvatar")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateImageAvatar([FromForm] IUpdateAvatarEmployee.RequestUpdateAvatar request)
        {
            await _updateAvatarEmployee.UpdateAsync(request);
            return Ok();
        }
    }
}
