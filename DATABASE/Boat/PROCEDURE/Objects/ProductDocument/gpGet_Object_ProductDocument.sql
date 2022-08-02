-- Function: gpGet_Object_ProductDocument()

DROP FUNCTION IF EXISTS gpGet_Object_ProductDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProductDocument(
    IN inProductDocumentId         Integer,    -- Форма
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
   DECLARE vbData TBlob;
BEGIN
     vbData:= (SELECT ObjectBlob_ProductDocument_Data.ValueData
               FROM ObjectBLOB AS ObjectBlob_ProductDocument_Data
               WHERE ObjectBlob_ProductDocument_Data.DescId   = zc_ObjectBlob_ProductDocument_Data()
                 AND ObjectBlob_ProductDocument_Data.ObjectId = inProductDocumentId
              );

     RETURN vbData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.21         *
*/

-- тест
-- SELECT length(gpGet_Object_ProductDocument) FROM gpGet_Object_ProductDocument (1, '2')
