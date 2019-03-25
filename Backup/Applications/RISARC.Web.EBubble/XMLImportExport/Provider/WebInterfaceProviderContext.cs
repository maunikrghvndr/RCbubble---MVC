using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace XMLSerializer.Provider
{
    class WebInterfaceProviderContext : DbContext
   //partial class WebInterfacepatientContext : DbContext
    {
        public WebInterfaceProviderContext()
            : base("ConnectionString")
        {
            //Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            // Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            //Database.SetInitializer(new MigrateDatabaseToLatestVersion<WebInterfaceContext, XMLSerializer.Migrations.Configuration>("ConnectionString"));

        }

        public DbSet<export> export_Provider { get; set; }
        public DbSet<fileauditdata> fileauditdata_Provider { get; set; }
        public DbSet<provider> clinic_Provider { get; set; }
        public DbSet<webinterface> webinterface_Provider { get; set; }


        }
    }



