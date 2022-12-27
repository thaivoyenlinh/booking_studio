using booking_app_BE.Apis.Employee;
using booking_app_BE.Apis.Identity.Services.Token;
using booking_app_BE.Businesses.Boundaries.Absence;
using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Boundaries.MapEmployeeToService;
using booking_app_BE.Businesses.Boundaries.Receipt;
using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Interactors.Absence;
using booking_app_BE.Businesses.Interactors.Customer;
using booking_app_BE.Businesses.Interactors.Employee;
using booking_app_BE.Businesses.Interactors.MapEmployeeToService;
using booking_app_BE.Businesses.Interactors.Receipt;
using booking_app_BE.Businesses.Interactors.Schedule;
using booking_app_BE.Businesses.Interactors.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Security.Claims;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors((setup) =>
{
    setup.AddPolicy("EnableCORS", (options) =>
    {
        options.AllowAnyMethod().AllowAnyHeader().AllowAnyOrigin();
    });
});


builder.Services.AddScoped<IJWTTokenGenerator, JWTTokenGenerator>();
builder.Services.AddDbContext<BookingStudioContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DbConnectionString")));

builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
{
   options.User.RequireUniqueEmail = true;
}
).AddEntityFrameworkStores<BookingStudioContext>();

builder.Services.AddAuthentication(opt => {
    opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    opt.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Token:Key"])),
        ValidIssuer = builder.Configuration["Token:Issuer"],
        ValidateIssuer = true,
        ValidateAudience = false,
    };
});

//To use service in controller
////builder.Services.InitializeServices(ServiceLifetime.Scoped);
//Employee Api
builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();

builder.Services.AddScoped<IEmployeeService, EmployeeService>();
builder.Services.AddScoped<IEmployeeRepository, EmployeeRepository>();
    
builder.Services.AddScoped<IAddEmployee, AddEmployee>();
builder.Services.AddScoped<IGetEmployees, GetEmployees>();
builder.Services.AddScoped<IGetEmployeeDetails, GetEmployeeDetails>();
builder.Services.AddScoped<IUpdateEmployee, UpdateEmployee>();
builder.Services.AddScoped<IDeleteEmployee, DeleteEmployee> ();
builder.Services.AddScoped<IUpdateAvatarEmployee, UpdateAvatarEmployee>();

//Service Api
builder.Services.AddScoped<IServiceRepository, ServiceRepository>();
builder.Services.AddScoped<IServiceService, ServiceService>();
builder.Services.AddScoped<IAddService, AddService>();
builder.Services.AddScoped<IGetServices, GetServices>();
builder.Services.AddScoped<IGetServiceDetails, GetServiceDetails>();
builder.Services.AddScoped<IUpdateService, UpdateService>();
builder.Services.AddScoped<IDeleteService, DeleteService>();
builder.Services.AddScoped<IUpdateBanner, UpdateBanner>();
builder.Services.AddScoped<IGetBanners, GetBanners>();

//Customer Api
builder.Services.AddScoped<ICustomerService, CustomerService>();
builder.Services.AddScoped<ICustomerRepository, CustomerRepository>();
builder.Services.AddScoped<IAddCustomer, AddCustomer>();
builder.Services.AddScoped<IGetCustomerDetails, GetCustomerDetails>();
builder.Services.AddScoped<IUpdateCustomer, UpdateCustomer>();
builder.Services.AddScoped<IUpdateAvatarCustomer, UpdateAvatarCustomer>();
builder.Services.AddScoped<IGetAllCustomer, GetAllCustomer>();
builder.Services.AddScoped<IGetCustomers, GetCustomers>();

//MapEmployeeToService Api
builder.Services.AddScoped<IMapEmployeeToServiceService, MapEmployeeToServiceService>();
builder.Services.AddScoped<IMapEmployeeToServiceRepository, MapEmployeeToServiceRepository>();
builder.Services.AddScoped<IGetEmployeesByServiceId, GetEmployeesByServiceId>();
builder.Services.AddScoped<IAddMapEmployeeToService, AddMapEmployeeToService>();

//Schedule Api
builder.Services.AddScoped<IScheduleRepository, ScheduleRepository>();
builder.Services.AddScoped<IScheduleService, ScheduleService>();
builder.Services.AddScoped<IAddSchedule, AddSchedule>();
builder.Services.AddScoped<IGetBookingDaysByEmployee, GetBookingDaysByEmployee>();
builder.Services.AddScoped<IUpdateStatusSchedule, UpdateStatusSchedule>();
builder.Services.AddScoped<IGetSchedulesByCustomer, GetSchedulesByCustomer>();
builder.Services.AddScoped<IUpdateRatingSchedule, UpdateRatingSchedule>();
builder.Services.AddScoped<IGetRatingBySchedule, GetRatingBySchedule>();
builder.Services.AddScoped<IUpdateRescheduleSchedule, UpdateRescheduleSchedule>();
builder.Services.AddScoped<IGetScheduleDetails, GetScheduleDetails>();
builder.Services.AddScoped<IGetSchedulesByEmployee, GetSchedulesByEmployee>();
builder.Services.AddScoped<IGetSchedules, GetSchedules>();

//Receipt Api
builder.Services.AddScoped<IReceiptRepository, ReceiptRepository>();
builder.Services.AddScoped<IReceiptService, ReceiptService>();
builder.Services.AddScoped<IReceiptChart, ReceiptChart>();

//Absence Api
builder.Services.AddScoped<IAbsenceRepository, AbsenceRepository>();
builder.Services.AddScoped<IAbsenceService, AbsenceService>();
builder.Services.AddScoped<IGetDayOffByEmployee, GetDayOffByEmployee>();
builder.Services.AddScoped<IAddAbsence, AddAbsence>();
builder.Services.AddScoped<IGetAbsencesByEmployee, GetAbsencesByEmployee>();
builder.Services.AddScoped<IUpdateStatusAbsence, UpdateStatusAbsence>();
builder.Services.AddScoped<IGetAbsences, GetAbsences>();
builder.Services.AddScoped<IRemoveServiceFromBanner, RemoveServiceFromBanner>();

//builder.Services.AddScoped<>();


builder.Services.AddSwaggerGen(opt =>
{
    opt.SwaggerDoc("v1", new OpenApiInfo { Title = "MyAPI", Version = "v1" });
    opt.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "bearer"
    });
    opt.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
                }
            },
            new string[]{}
        }
    });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors("EnableCORS");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.UseStaticFiles();

app.Run();
