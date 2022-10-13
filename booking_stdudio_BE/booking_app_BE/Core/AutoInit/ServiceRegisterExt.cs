using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Microsoft.Extensions.DependencyInjection;

namespace booking_app_BE.Core.AutoInit
{
    public static class ServiceRegisterExt
    {
        public static void InitializeServices(this IServiceCollection services,
            ServiceLifetime serviceLifetime = ServiceLifetime.Singleton,
            params Type[] profileAssemblyMarkerTypes) =>
            ScanAndInitService(services, profileAssemblyMarkerTypes.Select(t => t.GetTypeInfo().Assembly),
                serviceLifetime);

        private static IServiceCollection ScanAndInitService(
            IServiceCollection services,
            IEnumerable<Assembly> assembliesToScan,
            ServiceLifetime serviceLifetime = ServiceLifetime.Singleton
        )
        {
            var assembliesToScanArray = assembliesToScan as Assembly[] ?? assembliesToScan?.ToArray();

            if (assembliesToScanArray == null || assembliesToScanArray.Length <= 0)
            {
                return services;
            }

            var allTypes = assembliesToScanArray
                .Where(a => !a.IsDynamic).Distinct()
                .SelectMany(a => a.DefinedTypes)
                .Where(type => type.IsDefined(typeof(AutoInitComponentAttribute), false))
                .ToArray();

            foreach (var type in allTypes)
            {
                var implType = type.AsType();
                // Add reference service
                AddService(services, serviceLifetime, implType, null);

                // Add reference interface
                foreach (var inter in type.ImplementedInterfaces)
                {
                    AddService(services, serviceLifetime, inter, implType);
                }
            }

            return services;
        }

        private static void AddService(IServiceCollection services,
            ServiceLifetime serviceLifetime, Type serviceType, Type implType
        )
        {
            switch (serviceLifetime)
            {
                case ServiceLifetime.Singleton:
                    if (implType == null)
                    {
                        services.AddSingleton(serviceType);
                    }
                    else
                    {
                        services.AddSingleton(serviceType, implType);
                    }

                    break;
                case ServiceLifetime.Scoped:
                    if (implType == null)
                    {
                        services.AddScoped(serviceType);
                    }
                    else
                    {
                        services.AddScoped(serviceType, implType);
                    }

                    break;
                case ServiceLifetime.Transient:
                    if (implType == null)
                    {
                        services.AddTransient(serviceType);
                    }
                    else
                    {
                        services.AddTransient(serviceType, implType);
                    }

                    break;
                default:
                    if (implType == null)
                    {
                        services.AddSingleton(serviceType);
                    }
                    else
                    {
                        services.AddSingleton(serviceType, implType);
                    }

                    break;
            }
        }
    }
}