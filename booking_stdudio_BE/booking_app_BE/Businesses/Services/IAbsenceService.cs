using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Core;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;
using static booking_app_BE.Businesses.Boundaries.Absence.IGetDayOffByEmployee;

namespace booking_app_BE.Businesses.Services
{
    public interface IAbsenceService : IBaseService<Absence>
    {
        Task<List<DayOffSDate>> GetDayOffByEmployee(int employeeId);
        Task<IAddAbsence.AddAbsenceResponse> CreateAbsence(IAddAbsence.AddAbsenceRequest request);
        Task<IEnumerable<dynamic>> GetAbsencesByEmployee(IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request);
        Task UpdateStatusAbsence(IUpdateStatusAbsence.UpdateStatusRequest request);
        Task<PaginatedList<dynamic>> GetAbsences(IGetAbsences.GetAbsencesRequest request);
    }
}
