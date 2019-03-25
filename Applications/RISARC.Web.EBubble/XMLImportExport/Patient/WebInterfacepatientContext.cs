using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace XMLSerializer.Patient
{
    partial class WebInterfacepatientContext : DbContext
    {
        public WebInterfacepatientContext()
            : base("ConnectionString")
        {
            //Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            // Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
            //Database.SetInitializer(new MigrateDatabaseToLatestVersion<WebInterfaceContext, XMLSerializer.Migrations.Configuration>("ConnectionString"));

        }

        public DbSet<webinterfacesubmission> webinterfacesubmission_Patient { get; set; }
        public DbSet<patient> patient_Patient { get; set; }
        //public DbSet<XMLSerializer.Patient.webinterfacesubmission> webinterfacesubmission_Patient { get; set; }
    }
}
