namespace XMLSerializer.WebInterfacePatientContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.webinterfacesubmission_Patient",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BatchId = c.Int(nullable: false),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.patient_Patient", "BatchId", c => c.Int(nullable: false));
            DropTable("dbo.webinterfacesubmission_Patient");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.webinterfacesubmission_Patient",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            DropColumn("dbo.patient_Patient", "BatchId");
            DropTable("dbo.webinterfacesubmission_Patient");
        }
    }
}
