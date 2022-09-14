using System.ComponentModel.DataAnnotations;

namespace booking_app_BE.Database.Entity
{
    public class Role
    {
        /// <summary>
        /// Id of role
        /// </summary>
        [Key]
        public int Id { get; set; }

        /// <summary>
        /// Name of role
        /// </summary>
        public string? Name { get; set; }

        /*[DefaultValue("false")]
        public bool IsSystemRole { get; set; }*/

        /// <summary>
        /// Description of role
        /// </summary>
        //public string Description { get; set; }

        /// <summary>
        /// Permissions of the role
        /// </summary>
        //public virtual ICollection<PermissionRole> PermissionRoles { get; set; }
    }
}
