namespace XMLSerializer.WebInterfaceClinicContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial1 : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.export_Clinic", "fileauditdata_Id", "dbo.fileauditdata_Clinic");
            DropForeignKey("dbo.export_Clinic", "webinterface_Id", "dbo.webinterface_clinic");
            DropIndex("dbo.export_Clinic", new[] { "fileauditdata_Id" });
            DropIndex("dbo.export_Clinic", new[] { "webinterface_Id" });
            DropTable("dbo.export_Clinic");
            DropTable("dbo.fileauditdata_Clinic");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.fileauditdata_Clinic",
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
                "dbo.export_Clinic",
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
                .PrimaryKey(t => t.Id);
            
            CreateIndex("dbo.export_Clinic", "webinterface_Id");
            CreateIndex("dbo.export_Clinic", "fileauditdata_Id");
            AddForeignKey("dbo.export_Clinic", "webinterface_Id", "dbo.webinterface_clinic", "Id");
            AddForeignKey("dbo.export_Clinic", "fileauditdata_Id", "dbo.fileauditdata_Clinic", "Id");
        }
    }
}
