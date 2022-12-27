using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Absence
{
    [Interactor]
    public class UpdateStatusAbsence : IUpdateStatusAbsence
    {
        private readonly IAbsenceService _absenceService;
        public UpdateStatusAbsence(IAbsenceService absenceService)
        {
            _absenceService = absenceService;
        }

        public async Task ExecuteAsync(IUpdateStatusAbsence.UpdateStatusRequest request)
        {
            await _absenceService.UpdateStatusAbsence(request);
        }
    }
}
