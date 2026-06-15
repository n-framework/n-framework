using Microsoft.Extensions.DependencyInjection;

namespace TestService.Core.Application;

public static partial class ApplicationServiceRegistration
{
    extension(IServiceCollection services)
    {
        public IServiceCollection AddApplicationLayer()
        {
            return services.AddNfwModules();
        }
    }
}
