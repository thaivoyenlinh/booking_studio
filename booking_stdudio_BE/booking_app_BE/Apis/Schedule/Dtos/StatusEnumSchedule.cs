namespace booking_app_BE.Apis.Schedule.Dtos
{
    public enum StatusEnumSchedule
    {
        Pending = 0,
        Confirmed = 1,
        Completed = 2,
        Updated = 3,
        Cancelled = 4,
        WaitingConfirmRescheule = 5
    }

    public enum ReScheduleType
    {
        UpdateTime = 0,
        Cancel = 1,
    }
}
