namespace XMLSerializer.WebInterfaceRankingContextMigrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.webinterfaceexport_Ranking",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        grouptin = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.patient_Ranking",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        medicareid = c.String(),
                        patientfirstname = c.String(),
                        patientlastname = c.String(),
                        gender = c.String(),
                        birthdate = c.String(),
                        providernpi = c.String(),
                        providerfirstname = c.String(),
                        providerlastname = c.String(),
                        providernpitwo = c.String(),
                        providertwofirstname = c.String(),
                        providertwolastname = c.String(),
                        providernpithree = c.String(),
                        providerthreefirstname = c.String(),
                        providerthreelastname = c.String(),
                        clinicidentifier = c.String(),
                        caremedconrank = c.String(),
                        carefallsrank = c.String(),
                        cadrank = c.String(),
                        dmrank = c.String(),
                        hfrank = c.String(),
                        htnrank = c.String(),
                        ivdrank = c.String(),
                        pcmammogramrank = c.String(),
                        pccolorectalrank = c.String(),
                        pcflushotrank = c.String(),
                        pcpneumoshotrank = c.String(),
                        pcbmiscreenrank = c.String(),
                        pctobaccouserank = c.String(),
                        pcbloodpressurerank = c.String(),
                        pcdepressionrank = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.patient_Ranking");
            DropTable("dbo.webinterfaceexport_Ranking");
        }
    }
}
