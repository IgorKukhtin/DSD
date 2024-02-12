-- Function: gpGet_Object_InvoicePdf()

DROP FUNCTION IF EXISTS gpGet_Object_InvoicePdf(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InvoicePdf(
    IN inInvoicePdfId  Integer,       /* Форма */
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
DECLARE
   DECLARE vbData TBlob;
BEGIN
     vbData:= (SELECT ObjectBlob_InvoicePdf_Data.ValueData
               FROM ObjectBLOB AS ObjectBlob_InvoicePdf_Data
               WHERE ObjectBlob_InvoicePdf_Data.DescId   = zc_ObjectBlob_InvoicePdf_Data()
                 AND ObjectBlob_InvoicePdf_Data.ObjectId = inInvoicePdfId
              );

     RETURN vbData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.24         *
*/

-- тест
-- SELECT length(gpGet_Object_InvoicePdf) FROM gpGet_Object_InvoicePdf (1, '2')