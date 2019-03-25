using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Configuration;
using XMLSerializer.Patient;
using XMLSerializer.Discharge;
using XMLSerializer.Provider;
using XMLSerializer.Clinic;
using XMLSerializer.Ranking;
using RISARC.Common.Enumaration;

namespace XMLSerializer
{
    class XMLImportExport
    {
        //static void Main(string[] args)
        //{
        //    //DeSerializationToDataSet();
        //    string[] argsArray = args[0].Split('$');
        //    //export to xml generic caller:
        //    string folderPath = argsArray[1];
        //    if (argsArray[0] == "EXPORT")
        //    {
        //        ExportXML(folderPath);
        //    }
        //    else if (argsArray[0] == "IMPORT")
        //    {
        //        ImportXML(folderPath);
        //    }
        //}

        public static object ExportXML(string type)
        {
            switch (type)
            {
                case "Provider":
                    return Serialize<XMLSerializer.Provider.webinterface>(GetProviderData());
                    break;
                case "Discharge":
                    return Serialize<XMLSerializer.Discharge.webinterfacesubmission>(GetDischargeData());
                    break;
                case "Ranking":
                    return Serialize<XMLSerializer.Ranking.webinterfaceexport>(GetRankingData());
                    break;
                case "Patient":
                    return Serialize<XMLSerializer.Patient.webinterfacesubmission>(GetPatientData());
                    break;
                case "Clinic":
                    return Serialize<XMLSerializer.Clinic.webinterface>(GetClinicData());
                    break;
                default:
                    return new object();
            }
        }




        public static void ImportXML(string file, int XMLFileType)
        {
            try
            {
                switch (XMLFileType)
                    {
                        case 2:
                            {

                                SaveRankingChanges(DeSerializationwebinterfacesubmissionObjects<XMLSerializer.Ranking.webinterfaceexport>(file));
                                break;
                            }
                        case 3:
                            {

                                SaveDischargeChanges(DeSerializationwebinterfacesubmissionObjects<XMLSerializer.Discharge.webinterfacesubmission>(file));
                                break;
                            }
                        case 1:
                            {

                                SavePatientChanges(DeSerializationwebinterfacesubmissionObjects<XMLSerializer.Patient.webinterfacesubmission>(file));
                                break;
                            }
                        case 4:
                            {

                                SaveProviderChanges(DeSerializationwebinterfacesubmissionObjects<XMLSerializer.Provider.webinterface>(file));
                                break;
                            }
                        case 5:
                            {

                                SaveClinicChanges(DeSerializationwebinterfacesubmissionObjects<XMLSerializer.Clinic.webinterface>(file));
                                break;
                            }
                        default:
                            break;
                            
                    }
            }
            catch (Exception ex)
            {
                throw;
                
            }
        }
        
        
        
        private static T DeSerializationwebinterfacesubmissionObjects<T>(string filePath)
        {
            
             //Create an instance of webinterfacesubmission class.

            Type type = typeof(T);
            object myObject = Activator.CreateInstance(type);
           
            // Create an instance of stream writer.
            using (TextReader txtReader = new StreamReader(filePath))
            {
                // Create and instance of XmlSerializer class.

                XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));
                // DeSerialize from the StreamReader

                myObject = xmlSerializer.Deserialize(txtReader);
                //// Close the stream reader
            }
            //return webinterfacesubmission;
            return (T)myObject;
        }

        public static object Serialize<T>(object obj)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            Type type = typeof(T);
            object myObject = Activator.CreateInstance(type);
            myObject = (T)obj;
            try
            {
                return myObject;
            }
            catch (Exception ex)
            {
                Console.WriteLine("XML export failed");
                return ex;
            }
        }

        private static object GetDischargeData()
        {
            using (var ctx = new WebInterfaceDischargeContext())
            {

                XMLSerializer.Discharge.webinterfacesubmission wis = new Discharge.webinterfacesubmission();
                wis = (Discharge.webinterfacesubmission)ctx.webinterfacesubmissiondata.SingleOrDefault();

                var PatientList = (IList<Discharge.patient>)ctx.patientsdata.ToList();

                wis.patient = PatientList.ToArray();


                return wis;
            }
        }


        private static object GetProviderData()
        {
            using (var ctx = new WebInterfaceProviderContext())
            {

                XMLSerializer.Provider.webinterface wis = new Provider.webinterface();
                wis = (Provider.webinterface)ctx.webinterface_Provider.SingleOrDefault();

                var ProviderList = (IList<Provider.provider>)ctx.clinic_Provider.ToList();

                wis.provider = ProviderList.ToArray();


                return wis;
            }
        }


        private static object GetRankingData()
        {
            using (var ctx = new WebInterfacePatientRankingContext())
            {

                XMLSerializer.Ranking.webinterfaceexport wis = new Ranking.webinterfaceexport();
                wis = (Ranking.webinterfaceexport)ctx.export_Ranking.SingleOrDefault();

                var PatientList = (IList<Ranking.patient>)ctx.patient__Ranking.ToList();

                wis.patient = PatientList.ToArray();


                return wis;
            }
        }

        private static object GetPatientData()
        {
            using (var ctx = new WebInterfacepatientContext())
            {

                XMLSerializer.Patient.webinterfacesubmission wis = new Patient.webinterfacesubmission();
                wis = (Patient.webinterfacesubmission)ctx.webinterfacesubmission_Patient.SingleOrDefault();

                var PatientList = (IList<Patient.patient>)ctx.patient_Patient.ToList();

                wis.patient = PatientList.ToArray();


                return wis;
            }
        }

        private static object GetClinicData()
        {
            using (var ctx = new WebInterfaceClinicContext())
            {

                XMLSerializer.Clinic.webinterface wis = new Clinic.webinterface();
                wis = (Clinic.webinterface)ctx.webinterface.SingleOrDefault();

                var Clinicdata = (IList<Clinic.clinic>)ctx.clinic.ToList();

                wis.clinic = Clinicdata.ToArray();


                return wis;
            }
        }
      



        private static void SaveDischargeChanges(XMLSerializer.Discharge.webinterfacesubmission webinterfacesubmission)
        {
            using (var ctx = new XMLSerializer.Discharge.WebInterfaceDischargeContext())
            {
             
                ctx.webinterfacesubmissiondata.Add(webinterfacesubmission);
                ctx.patientsdata.AddRange(webinterfacesubmission.patient);

                ctx.SaveChanges();
            }
        }



        private static void SaveRankingChanges(webinterfaceexport webinterfaceexport)
        {
           
            using (var ctx = new WebInterfacePatientRankingContext())
            {
                ctx.export_Ranking.Add(webinterfaceexport);
                ctx.patient__Ranking.AddRange(webinterfaceexport.patient);
                ctx.SaveChanges();
            }
        }


        private static void SavePatientChanges(XMLSerializer.Patient.webinterfacesubmission webinterfaceSubmission)
        {
           
            using (var ctx = new WebInterfacepatientContext())
            {
                ctx.webinterfacesubmission_Patient.Add(webinterfaceSubmission);
                ctx.patient_Patient.AddRange(webinterfaceSubmission.patient);

                ctx.SaveChanges();
            }
        }
        private static void SaveProviderChanges(XMLSerializer.Provider.webinterface webInterface)
        { 
            using (var ctx = new WebInterfaceProviderContext())
            {
                ctx.webinterface_Provider.Add(webInterface);
                ctx.clinic_Provider.AddRange(webInterface.provider);
                ctx.SaveChanges();
            }
        }
        private static void SaveClinicChanges(XMLSerializer.Clinic.webinterface webInterface)
        {
            using (var ctx = new WebInterfaceClinicContext())
            {
                ctx.webinterface.Add(webInterface);
                ctx.clinic.AddRange(webInterface.clinic);
                ctx.SaveChanges();
            }
        }
      
/// <summary>
/// main serializer code ends here.
/// </summary>

        private static void DeSerializationToDataSet()
        {
            DataSet deSerializeDS = new DataSet();
            string folderPath = @"C:\Users\abdulkha\Downloads\SamplePrefilledOnlyPatient-Discharge.xml";
            try
            {
                foreach (string file in Directory.EnumerateFiles(folderPath, "*.xml"))
                {
                    string contents = File.ReadAllText(file);
                }
                XmlReader xmlFile;
                TextReader txtReader = new StreamReader(@"C:\Users\abdulkha\Downloads\SamplePrefilledOnlyPatient-Discharge.xml");

                xmlFile = XmlReader.Create(txtReader, new XmlReaderSettings());
                DataSet ds = new DataSet();
                ds.ReadXml(xmlFile);
             
            }
            catch (Exception ex)
            {
                // Handle Exceptions Here…..
            }
        }



       
    }
    public static class ExtensionMethods
    {
        ///////////////////////////////////////////////////////////////////////
        public static string XmlSerializeToString(this object objectInstance)
        {
            var serializer = new XmlSerializer(objectInstance.GetType());
            var sb = new StringBuilder();

            using (TextWriter writer = new StringWriter(sb))
            {
                serializer.Serialize(writer, objectInstance);
            }

            return sb.ToString();
        }

        public static T XmlDeserializeFromString<T>(this string objectData)
        {
            return (T)XmlDeserializeFromString(objectData, typeof(T));
        }

        public static object XmlDeserializeFromString(this string objectData, Type type)
        {
            var serializer = new XmlSerializer(type);
            object result;

            using (TextReader reader = new StringReader(objectData))
            {
                result = serializer.Deserialize(reader);
            }

            return result;
        }
    }
}

                               