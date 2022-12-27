namespace booking_app_BE.Businesses.Boundaries.MapEmployeeToService
{
    public interface IAddMapEmployeeToService
    {
        Task ExecuteAsync(int employeeId, int serviceId);
    }
}
