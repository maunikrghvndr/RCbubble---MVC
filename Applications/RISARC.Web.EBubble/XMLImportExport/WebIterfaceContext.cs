using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XMLSerializer
{
    class WebInterfaceContext : DbContext 
    {
        public WebInterfaceContext():base("ConnectionString")
        {
            //Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
           // Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            //Database.SetInitializer(new MigrateDatabaseToLatestVersion<WebInterfaceContext, XMLSerializer.Migrations.Configuration>("ConnectionString"));
            
        }
        
        public DbSet<webinterfacesubmission> webinterfacesubmissiondata { get; set; }
        public DbSet<patient> patientsdata { get; set; }
    }
  
}
