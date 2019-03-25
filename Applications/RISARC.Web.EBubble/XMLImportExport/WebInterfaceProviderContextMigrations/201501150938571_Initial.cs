namespace XMLSerializer.WebInterfaceProviderContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.provider_Provider",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        providernpi = c.String(),
                        providerfirstname = c.String(),
                        providerlastname = c.String(),
                        providerein = c.String(),
                        providercredentials = c.String(),
                        providerisoriginal = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.export_provider",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        exportperiodfromdate = c.String(),
                        exportperiodtodate = c.String(),
                        type = c.String(),
                        version = c.Decimal(nullable: false, precision: 18, scale: 2),
                        fileauditdata_Id = c.Int(),
                        webinterface_Id = c.Int(),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.fileauditdata_Provider", t => t.fileauditdata_Id)
                .ForeignKey("dbo.webinterface_Provider", t => t.webinterface_Id)
                .Index(t => t.fileauditdata_Id)
                .Index(t => t.webinterface_Id);
            
            CreateTable(
                "dbo.fileauditdata_Provider",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        filenumber = c.String(),
                        createdate = c.String(),
                        createtime = c.String(),
                        createby = c.String(),
                        version = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.webinterface_Provider",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.export_provider", "webinterface_Id", "dbo.webinterface_Provider");
            DropForeignKey("dbo.export_provider", "fileauditdata_Id", "dbo.fileauditdata_Provider");
            DropIndex("dbo.export_provider", new[] { "webinterface_Id" });
            DropIndex("dbo.export_provider", new[] { "fileauditdata_Id" });
            DropTable("dbo.webinterface_Provider");
            DropTable("dbo.fileauditdata_Provider");
            DropTable("dbo.export_provider");
            DropTable("dbo.provider_Provider");
        }
    }
}
