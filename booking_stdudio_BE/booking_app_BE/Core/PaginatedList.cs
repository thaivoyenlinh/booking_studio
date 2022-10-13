
using booking_app_BE.Core.Constants;
using EventId = booking_app_BE.Core.Constants.EventId;

namespace booking_app_BE.Core
{
    public class PaginatedList<T>
    {
        public int PageNumber { get; }
        public int CurrentPage { get { return this.PageNumber; } }
        public int TotalPages { get; }
        public int TotalRecords { get; }
        public List<T> Rows { get; }
        public bool HasPreviousPage => this.PageNumber > 1;
        public bool HasNextPage => this.PageNumber < this.TotalPages;

        protected PaginatedList(int totalRecords, List<T> rows, int pageNumber, int pageSize)
        {
            this.Rows = rows ?? throw new ArgumentNullException(nameof(rows));
            this.TotalRecords = totalRecords >= 0 ? totalRecords : throw new ArgumentOutOfRangeException(nameof(totalRecords));
            this.PageNumber = pageNumber;
            this.TotalPages = pageSize;
        }

        public PaginatedList(List<T> items, int count, int pageNumber, int pageSize)
        {
            this.PageNumber = pageNumber;
            this.TotalPages = (int)Math.Ceiling(count / (double)pageSize);
            this.TotalRecords = count;
            this.Rows = items;
        }

        protected static void ValidatePagingParameters(int? pageNumber, int? pageSize)
        {
            if(pageSize < 1)
            {
                throw new PagingOutOfRangeException(EventId.GET, $"Paging out of range: rows per page must be >= 1 but is {pageSize}");
            }
            if(pageNumber < 1)
            {
                throw new PagingOutOfRangeException(EventId.GET, $"Paging out of range: current page must be >= 1 but is {pageNumber}");
            }
        }

        public static async Task<PaginatedList<T>> CreateAsync(IQueryable<T> source, int pageNumber, int pageSize)
        {
            PaginatedList<T>.ValidatePagingParameters(pageNumber, pageSize);
            var count = await Task.FromResult(source.Count());
            var items = pageNumber < 1 || pageSize < 1 ? await Task.FromResult(source.ToList()) : await Task.FromResult(source.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList());
            return new PaginatedList<T>(items, count, pageNumber, pageSize);
        }
    }
}
