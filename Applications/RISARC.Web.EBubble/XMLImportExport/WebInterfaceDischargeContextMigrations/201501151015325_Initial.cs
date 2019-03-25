namespace XMLSerializer.WebInterfaceDischargeContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.patient_Discharge",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        medicareid = c.String(),
                        patientfirstname = c.String(),
                        patientlastname = c.String(),
                        gender = c.String(),
                        birthdate = c.String(),
                        medicalrecordnumber = c.String(),
                        otherid = c.String(),
                        providernpi = c.String(),
                        providernpitwo = c.String(),
                        providernpithree = c.String(),
                        clinicidentifier = c.String(),
                        generalcomments = c.String(),
                        medicalrecordfound = c.String(),
                        medicalnotqualifiedreason = c.String(),
                        medicalnotqualifieddate = c.String(),
                        caremedconrank = c.String(),
                        caremedconconfirmed = c.String(),
                        dischargedate = c.String(),
                        dischargeconfirmation = c.String(),
                        officevisit = c.String(),
                        medicationreconciliation = c.String(),
                        caremedconcomments = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.webinterfacesubmission_Discharge",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.webinterfacesubmission_Discharge");
            DropTable("dbo.patient_Discharge");
        }
    }
}
