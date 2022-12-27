using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using static booking_app_BE.Businesses.Boundaries.Absence.IGetDayOffByEmployee;
using static booking_app_BE.Database.Repository.AbsenceRepository;

namespace booking_app_BE.Database.Repository
{
    public interface IAbsenceRepository : IBaseRepository<Absence>
    {
        Task<List<DateOff>> GetDayOffByEmployee(int employeeId);
        Task<IAddAbsence.AddAbsenceResponse> CreateAbsence(IAddAbsence.AddAbsenceRequest request);
        Task<List<IGetAbsencesByEmployee.GetAbsencesByEmployeeReponse>> GetAbsencesByEmployee(IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request);
        Task<IQueryable<dynamic>> GetAbsencesByCondition(string name);
    }
}
