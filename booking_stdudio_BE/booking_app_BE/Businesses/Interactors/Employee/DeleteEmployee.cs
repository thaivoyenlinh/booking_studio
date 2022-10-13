using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class DeleteEmployee : IDeleteEmployee
    {
        private readonly IEmployeeService _employeeService;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public DeleteEmployee(IEmployeeService employeeService,
            IWebHostEnvironment webHostEnvironment)
        {
            _employeeService = employeeService;
            _webHostEnvironment = webHostEnvironment;
        }
        public async Task<IDeleteEmployee.Response> DeleteAsync(IDeleteEmployee.Request request)
        {
            var employee = await _employeeService.FindByIdAsync(e => e.Id.Equals(request.EmployeeId));
            if (employee != null)
            {

                string fileName = employee.Image;
                string path = _webHostEnvironment.WebRootPath + '\\' + "Images";
                System.GC.Collect();
                System.GC.WaitForPendingFinalizers();
                if (File.Exists(Path.Combine(path, fileName)))
                {  
                    File.Delete(Path.Combine(path, fileName));
                }   

                await _employeeService.DeleteAsync(employee);
                return new IDeleteEmployee.Response(200, "success");
            }
            return new IDeleteEmployee.Response(500, "error");
        }

    }
}
