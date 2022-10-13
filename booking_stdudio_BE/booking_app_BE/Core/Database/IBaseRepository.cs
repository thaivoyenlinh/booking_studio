using System.Linq.Expressions;

namespace booking_app_BE.Core.Database
{
    public interface IBaseRepository<T>
    {
        public Task<T> CreateAsync(T entity);
        public Task<T> FindByIdAsync(Expression<Func<T, bool>> expression, bool trackChanges = false);
        public Task<T> UpdateAsync(T entity);
        public Task DeleteAsync(T entity);
    }
}
