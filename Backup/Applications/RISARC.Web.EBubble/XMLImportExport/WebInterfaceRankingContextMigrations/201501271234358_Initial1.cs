namespace XMLSerializer.WebInterfaceRankingContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial1 : DbMigration
    {
        public override void Up()
        {
            DropTable("dbo.webinterfaceexport_Ranking");
            CreateTable(
                "dbo.webinterfaceexport_Ranking",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BatchId = c.Int(nullable: false),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.patient_Ranking", "BatchId", c => c.Int(nullable: false));

        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.webinterfaceexport_Ranking",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            DropColumn("dbo.patient_Ranking", "BatchId");
            DropTable("dbo.webinterfaceexport_Ranking");
        }
    }
}
