using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;


namespace XMLSerializer.Clinic
{
    class WebInterfaceClinicContext : DbContext 
    //partial class WebInterfacepatientContext : DbContext
    {
        public WebInterfaceClinicContext()
            : base("ConnectionString")
        {
            //Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            // Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            //Database.SetInitializer(new MigrateDatabaseToLatestVersion<WebInterfaceContext, XMLSerializer.Migrations.Configuration>("ConnectionString"));

        }

        //public DbSet<export> export { get; set; }
        //public DbSet<fileauditdata> fileauditdata { get; set; }
        public DbSet<clinic> clinic { get; set; }
        public DbSet<webinterface> webinterface { get; set; }
    }
  

}
