using System.Linq.Expressions;

namespace booking_app_BE.Core.Businesses
{
    public interface IBaseService<T>
    {
        public Task<T> CreateAsync(T entity);
        public Task<T> FindByIdAsync(Expression<Func<T, bool>> expression, bool trackChanges = false);
        public Task DeleteAsync(T entity);
    }
}
