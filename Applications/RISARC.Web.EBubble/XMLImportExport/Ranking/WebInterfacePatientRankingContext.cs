using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace XMLSerializer.Ranking
{
     class WebInterfacePatientRankingContext : DbContext
    {
         public WebInterfacePatientRankingContext()
             : base("ConnectionString")
         {
             //Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
             // Database.SetInitializer(new DropCreateDatabaseAlways<WebInterfaceContext>());
             //Database.SetInitializer(new MigrateDatabaseToLatestVersion<WebInterfaceContext, XMLSerializer.Migrations.Configuration>("ConnectionString"));

         }

        public DbSet<webinterfaceexport> export_Ranking { get; set; }
        public DbSet<patient> patient__Ranking { get; set; }
        
       
    }


}
