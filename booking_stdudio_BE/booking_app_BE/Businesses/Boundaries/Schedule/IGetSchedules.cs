using booking_app_BE.Apis.Schedule.Dtos;
using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetSchedules
    {
        Task<PaginatedList<dynamic>> ExecuteAsync(GetSchedulesRequest request);
        public class GetSchedulesRequest
        {
            public string Date { get; set; }
            public string Status { get; set; }
            public SortOrderDto.SortHeaderSchedule? SortHeader { get; set; }
            public SortOrderDto.SortOrderSchedule? SortOrder { get; set; }
            public int CurrentPage { get; set; }
            public int RowsPerPage { get; set; }

            public GetSchedulesRequest(string date, string status, SortOrderDto.SortHeaderSchedule? sortHeader, SortOrderDto.SortOrderSchedule? sortOrder, int currentPage, int rowsPerPage)
            {
                Date = date;
                Status = status;
                SortHeader = sortHeader;
                SortOrder = sortOrder;
                CurrentPage = currentPage;
                RowsPerPage = rowsPerPage;
            }
        }
    }
}
