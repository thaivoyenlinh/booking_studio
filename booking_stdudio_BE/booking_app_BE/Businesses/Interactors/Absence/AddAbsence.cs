using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Absence
{
    [Interactor]
    public class AddAbsence : IAddAbsence
    {
        private readonly IAbsenceService _absenceService;
        public AddAbsence(IAbsenceService absenceService)
        {
            _absenceService = absenceService;
        }

        public async Task<IAddAbsence.AddAbsenceResponse> ExecuteAsync(IAddAbsence.AddAbsenceRequest request)
        {
            var response = await _absenceService.CreateAbsence(request);
            return response;
        }
    }
}
