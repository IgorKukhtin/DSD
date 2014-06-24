-- View: Object_Bank_View

CREATE OR REPLACE VIEW Object_Bank_View AS
     SELECT 
       Object.Id
     , Object.ObjectCode  AS Code
     , Object.ValueData   AS BankName
     , ObjectString_MFO.ValueData AS MFO
     , Object.isErased
     FROM Object
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
     WHERE Object.DescId = zc_Object_Bank();


ALTER TABLE Object_Bank_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.14                         *
*/

-- тест
-- SELECT * FROM Object_BankAccount_View
