namespace XMLSerializer.WebInterfaceClinicContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.clinics", newName: "clinic_Clinic");
            RenameTable(name: "dbo.exports", newName: "export_Clinic");
            RenameTable(name: "dbo.fileauditdatas", newName: "fileauditdata_Clinic");
            RenameTable(name: "dbo.webinterfaces", newName: "webinterface_clinic");
        }
        
        public override void Down()
        {
            RenameTable(name: "dbo.webinterface_clinic", newName: "webinterfaces");
            RenameTable(name: "dbo.fileauditdata_Clinic", newName: "fileauditdatas");
            RenameTable(name: "dbo.export_Clinic", newName: "exports");
            RenameTable(name: "dbo.clinic_Clinic", newName: "clinics");
        }
    }
}
