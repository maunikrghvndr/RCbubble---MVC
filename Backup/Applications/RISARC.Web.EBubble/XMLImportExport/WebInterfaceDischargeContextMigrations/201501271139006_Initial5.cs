namespace XMLSerializer.WebInterfaceDischargeContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial5 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.webinterfacesubmission_Discharge", "BatchId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.webinterfacesubmission_Discharge", "BatchId");
        }
    }
}
