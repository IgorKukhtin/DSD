-- Function: gpGet_Object_BankAccountPdf()

DROP FUNCTION IF EXISTS gpGet_Object_BankAccountPdf(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccountPdf(
    IN inBankAccountPdfId  Integer,       /* Форма */
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
DECLARE
   DECLARE vbData TBlob;
BEGIN
     vbData:= (SELECT ObjectBlob_BankAccountPdf_Data.ValueData
               FROM ObjectBLOB AS ObjectBlob_BankAccountPdf_Data
               WHERE ObjectBlob_BankAccountPdf_Data.DescId   = zc_ObjectBlob_BankAccountPdf_Data()
                 AND ObjectBlob_BankAccountPdf_Data.ObjectId = inBankAccountPdfId
              );

     RETURN vbData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.24         *
*/

-- тест
-- SELECT length(gpGet_Object_BankAccountPdf) FROM gpGet_Object_BankAccountPdf (1, '2')
