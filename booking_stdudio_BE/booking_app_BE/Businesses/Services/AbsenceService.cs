using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;
using static booking_app_BE.Businesses.Boundaries.Absence.IGetDayOffByEmployee;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class AbsenceService : BaseService<Absence, IAbsenceRepository>, IAbsenceService
    {
        private readonly BookingStudioContext _dbContext;
        public AbsenceService(
            IAbsenceRepository absenceRepository,
            BookingStudioContext dbContext) : base(absenceRepository)
        {
            _dbContext = dbContext;
        }

        public async Task<IAddAbsence.AddAbsenceResponse> CreateAbsence(IAddAbsence.AddAbsenceRequest request)
        {
            var response = await Repository.CreateAbsence(request);
            return response;
        }

        public async Task<PaginatedList<dynamic>> GetAbsences(IGetAbsences.GetAbsencesRequest request)
        {
            var absencesList = await Repository.GetAbsencesByCondition(request.Name);
            return await PaginatedList<dynamic>.CreateAsync(absencesList, request.CurrentPage, request.RowsPerPage);
        }

        public async Task<IEnumerable<dynamic>> GetAbsencesByEmployee(IGetAbsencesByEmployee.GetAbsencesByEmployeeRequest request)
        {
            return await Repository.GetAbsencesByEmployee(request);
        }

        public async Task<List<DayOffSDate>> GetDayOffByEmployee(int employeeId)
        {
            var dayOffList = await Repository.GetDayOffByEmployee(employeeId);
            List<DayOffSDate> allDates = new List<DayOffSDate>();

            DateTime startingDate = DateTime.Today.AddDays(+15);
            DateTime endingDate = DateTime.Today.AddDays(+30);

            for (DateTime date = startingDate; date <= endingDate; date = date.AddDays(1))
            {
                var tmpDate = date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString();
                var available = dayOffList.Where(s => s.Dates.Contains(tmpDate)).Any();
                /*var available = true;
                if ((result == false && dateReschdeule == true) || (result == true && dateReschdeule == false))
                {
                    available = !available;
                }*/
                allDates.Add(
                    new DayOffSDate()
                    {
                        DayOff = date.Date.ToString("yyyy/MM/dd") + " " + date.DayOfWeek.ToString(),
                        Available = !available
                    }
                );
            }
            return allDates;
        }

        public async Task UpdateStatusAbsence(IUpdateStatusAbsence.UpdateStatusRequest request)
        {
            var absence = await Repository.FindByIdAsync(x => x.Id == request.AbsenceId);
            if (absence != null)
            {
                absence.Status = request.Status.ToString();
            }
            await Repository.UpdateAsync(absence);
        }
    }
}
