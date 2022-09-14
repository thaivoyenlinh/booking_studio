using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace booking_app_BE.Database.Entity
{
    public class User
    {
        /// Id of role
        [Key]
        public int Id { get; set; }

        /// <summary>
        /// External ID of user
        /// </summary>
        //public string LogonName { get; set; }

        /// <summary>
        /// Email of user
        /// </summary>
        //public string Email { get; set; }

        /// <summary>
        /// First name of user
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Last name of user
        /// </summary>
        public string LastName { get; set; }

        //[Column(TypeName = "nvarchar(50)")]
        //public string GuidUserName { get; set; }

        [ForeignKey(nameof(Role))]
        public int RoleId { get; set; }

        public Role? Role { get; set; }

        /// <summary>
        /// Login count
        /// </summary>
        /*public int Logins { get; set; }
        public DateTime LastLogin { get; set; }*/
    }

}