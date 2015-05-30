-- View: Object_Currency_View

DROP VIEW IF EXISTS Object_MedocLoadInfo_View;

CREATE OR REPLACE VIEW Object_MedocLoadInfo_View AS
       SELECT 
             Object_MedocLoadInfo.Id          AS Id
           , ObjectDate_MedocLoadInfo_LoadDateTime.ValueData AS LoadDateTime     
           , ObjectDate_MedocLoadInfo_Period.ValueData AS Period     
                                                      
       FROM Object AS Object_MedocLoadInfo

           LEFT JOIN ObjectDate AS ObjectDate_MedocLoadInfo_LoadDateTime
                                 ON ObjectDate_MedocLoadInfo_LoadDateTime.ObjectId = Object_MedocLoadInfo.Id 
                                AND ObjectDate_MedocLoadInfo_LoadDateTime.DescId = zc_ObjectDate_MedocLoadInfo_LoadDateTime() 
                                                                                                 
           LEFT JOIN ObjectDate AS ObjectDate_MedocLoadInfo_Period
                                 ON ObjectDate_MedocLoadInfo_Period.ObjectId = Object_MedocLoadInfo.Id 
                                AND ObjectDate_MedocLoadInfo_Period.DescId = zc_ObjectDate_MedocLoadInfo_Period() 

       WHERE Object_MedocLoadInfo.DescId = zc_Object_MedocLoadInfo();


ALTER TABLE Object_MedocLoadInfo_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.15                         *
*/

-- тест
-- SELECT * FROM Object_Currency_View
