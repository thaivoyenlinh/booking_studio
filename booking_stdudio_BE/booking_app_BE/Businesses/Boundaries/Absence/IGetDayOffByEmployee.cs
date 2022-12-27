namespace booking_app_BE.Businesses.Boundaries.Absence
{
    public interface IGetDayOffByEmployee
    {
        Task<List<DayOffSDate>> ExecuteAsync(int employeeId);

        public class DayOffSDate
        {
            public string DayOff { get; set; }
            public bool Available { get; set; }
        }
    }
}
