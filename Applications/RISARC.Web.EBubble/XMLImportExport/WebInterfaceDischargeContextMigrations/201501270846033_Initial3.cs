namespace XMLSerializer.WebInterfaceDischargeContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial3 : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.patient_Discharge", "batchId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.patient_Discharge", "batchId", c => c.Int(nullable: false));
        }
    }
}
