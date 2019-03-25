namespace XMLSerializer.WebInterfaceClinicContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial2 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.clinic_Clinic", "BatchId", c => c.Int(nullable: false));
            AddColumn("dbo.webinterface_clinic", "BatchId", c => c.Int(nullable: false));
            
        }
        
        public override void Down()
        {
           
            DropColumn("dbo.webinterface_clinic", "BatchId");
            DropColumn("dbo.clinic_Clinic", "BatchId");
        }
    }
}
