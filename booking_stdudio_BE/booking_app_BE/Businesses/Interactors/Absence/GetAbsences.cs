using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Absence
{
    [Interactor]
    public class GetAbsences : IGetAbsences
    {
        private readonly IAbsenceService _absenceService;
        public GetAbsences(IAbsenceService absenceService)
        {
            _absenceService = absenceService;
        }

        public Task<PaginatedList<dynamic>> ExecuteAsync(IGetAbsences.GetAbsencesRequest request)
        {
            return _absenceService.GetAbsences(request);
        }
    }
}
