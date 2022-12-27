using booking_app_BE.Businesses.Services;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetBookingDaysByEmployee
    {
        Task<List<DateDays>> ExecuteAsync(int employeeId);
    }
}
