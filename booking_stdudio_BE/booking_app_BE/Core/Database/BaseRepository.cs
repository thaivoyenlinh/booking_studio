using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace booking_app_BE.Core.Database
{
    public class BaseRepository<T> : IBaseRepository<T> where T : class
    {
        protected readonly DbContext _dbContext;

        public BaseRepository(DbContext dbcontext)
        {
            _dbContext = dbcontext;
        }
        public async Task<T> CreateAsync(T entity)
        {
            await _dbContext.Set<T>().AddAsync(entity);
            await _dbContext.SaveChangesAsync();
            return entity;
        }

        public async Task<T> FindByIdAsync(Expression<Func<T, bool>> expression, bool trackChanges = false) =>
            trackChanges
                ? await _dbContext.Set<T>().Where(expression).FirstOrDefaultAsync()
                : await _dbContext.Set<T>().Where(expression).AsNoTracking().FirstOrDefaultAsync();

        public async Task<T> UpdateAsync(T entity)
        {
            _dbContext.ChangeTracker.Entries<T>()
                .Where(e => GetPropValue(e.Entity, "Id").ToString() == GetPropValue(entity, "Id").ToString())
                .ToList().ForEach(e => e.State = EntityState.Detached);
            _dbContext.Set<T>().Attach(entity);
            _dbContext.Entry(entity).State = EntityState.Modified;
            await _dbContext.SaveChangesAsync();
            return entity;
        }

        public async Task DeleteAsync(T entity)
        {
            if(_dbContext.Entry(entity).State == EntityState.Detached)
            {
                _dbContext.Set<T>().Attach(entity);
            }
            _dbContext.Remove(entity);
            await _dbContext.SaveChangesAsync();
        }

        public static object GetPropValue(object src, string propName)
        {
            return src.GetType().GetProperty(propName)?.GetValue(src, null) ?? null;
        }
    }
}
