using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Absence
{
    public interface IGetAbsences
    {
        Task<PaginatedList<dynamic>> ExecuteAsync(GetAbsencesRequest request);
        public class GetAbsencesRequest
        {
            public string Name { get; set; }
            /*public SortOrderDto.SortHeader? SortHeader { get; set; }
            public SortOrderDto.SortOrder? SortOrder { get; set; }*/
            public int CurrentPage { get; set; }
            public int RowsPerPage { get; set; }

            public GetAbsencesRequest(string name, int currentPage, int rowsPerPage)
            {
                Name = name;
                /*SortHeader = sortHeader;
                SortOrder = sortOrder;*/
                CurrentPage = currentPage;
                RowsPerPage = rowsPerPage;
                Name = name;
            }
        }
    }
}
