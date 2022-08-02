-- Function: gpGet_Object_ProductPhoto()

DROP FUNCTION IF EXISTS gpGet_Object_ProductPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProductPhoto(
IN inProductPhotoId  Integer,       /* Форма */
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
DECLARE
   DECLARE vbData TBlob;
BEGIN
     vbData:= (SELECT ObjectBlob_ProductPhoto_Data.ValueData
               FROM ObjectBLOB AS ObjectBlob_ProductPhoto_Data
               WHERE ObjectBlob_ProductPhoto_Data.DescId   = zc_ObjectBlob_ProductPhoto_Data()
                 AND ObjectBlob_ProductPhoto_Data.ObjectId = inProductPhotoId
              );

     RETURN vbData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/

-- тест
-- SELECT length(gpGet_Object_ProductPhoto) FROM gpGet_Object_ProductPhoto (1, '2')
