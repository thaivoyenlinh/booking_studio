namespace booking_app_BE.Core.AutoInit
{
    [AttributeUsage(AttributeTargets.Assembly | AttributeTargets.Class, AllowMultiple = false, Inherited = true)]
    public class InteractorAttribute : AutoInitComponentAttribute
    {
    }
}
