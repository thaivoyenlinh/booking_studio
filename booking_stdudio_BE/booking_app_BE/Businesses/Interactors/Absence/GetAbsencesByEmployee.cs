using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Absence
{
    [Interactor]
    public class GetAbsencesByEmployee : IGetAbsencesByEmployee
    {
        private readonly IAbsenceService _absenceService;
        public GetAbsencesByEmployee(IAbsenceService absenceService)
        {
            _absenceService = absenceService;
        }

        public async Task<IEnumerable<dynamic>> ExecuteAsync(IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request)
        {
            return await _absenceService.GetAbsencesByEmployee(request);
        }
    }
}
