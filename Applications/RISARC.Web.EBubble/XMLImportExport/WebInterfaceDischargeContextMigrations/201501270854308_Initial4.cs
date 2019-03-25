namespace XMLSerializer.WebInterfaceDischargeContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial4 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.patient_Discharge", "BatchId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.patient_Discharge", "BatchId");
        }
    }
}
