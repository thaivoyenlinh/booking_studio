using booking_app_BE.Core.Database;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace booking_app_BE.Core.Businesses
{
    public class BaseService<T, TRepository> : IBaseService<T> where TRepository : IBaseRepository<T>
    {
        protected readonly TRepository Repository;
        public BaseService(TRepository repository)
        {
            Repository = repository;
        }
        public Task<T> CreateAsync(T entity) => Repository.CreateAsync(entity);
        public async Task<T> FindByIdAsync(Expression<Func<T, bool>> expression, bool trackChanges = false) => await Repository.FindByIdAsync(expression, trackChanges);      
        public async Task DeleteAsync(T entity) => await Repository.DeleteAsync(entity);
    }
}
