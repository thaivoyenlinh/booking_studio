using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;
using static booking_app_BE.Businesses.Boundaries.Absence.IGetDayOffByEmployee;

namespace booking_app_BE.Businesses.Interactors.Absence
{
    [Interactor]
    public class GetDayOffByEmployee : IGetDayOffByEmployee
    {
        private readonly IAbsenceService _absenceService;
        public GetDayOffByEmployee(IAbsenceService absenceService)
        {
            _absenceService = absenceService;
        }
        public async Task<List<DayOffSDate>> ExecuteAsync(int employeeId)
        {
            return await _absenceService.GetDayOffByEmployee(employeeId);
        }
    }
}
