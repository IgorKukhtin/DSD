-- View: Object_Bank_View

--DROP VIEW IF EXISTS Object_Bank_View CASCADE;

CREATE OR REPLACE VIEW Object_Bank_View AS
     SELECT
             Object_Bank.Id                     AS Id
           , Object_Bank.ObjectCode             AS Code
           , Object_Bank.ValueData              AS BankName
           , ObjectString_MFO.ValueData         AS MFO
           , Object_Bank.isErased               AS isErased
           , ObjectString_SWIFT.ValueData       AS SWIFT
           , ObjectString_IBAN.ValueData        AS IBAN
           , Object_Juridical.Id                AS JuridicalId
           , Object_Juridical.ValueData         AS JuridicalName

     FROM Object AS Object_Bank
        LEFT JOIN ObjectLink AS ObjectLink_Bank_Juridical
                 ON ObjectLink_Bank_Juridical.ObjectId = Object_Bank.Id
                AND ObjectLink_Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
        LEFT JOIN ObjectString AS ObjectString_SWIFT
                 ON ObjectString_SWIFT.ObjectId = Object_Bank.Id
                AND ObjectString_SWIFT.DescId = zc_ObjectString_Bank_SWIFT()
        LEFT JOIN ObjectString AS ObjectString_IBAN
                 ON ObjectString_IBAN.ObjectId = Object_Bank.Id
                AND ObjectString_IBAN.DescId = zc_ObjectString_Bank_IBAN()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Bank_Juridical.ChildObjectId


     WHERE Object_Bank.DescId = zc_Object_Bank();


ALTER TABLE Object_Bank_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.15                         *
 16.10.14                                                       *
 17.06.14                         *
*/

-- тест
-- SELECT * FROM Object_BankAccount_View
