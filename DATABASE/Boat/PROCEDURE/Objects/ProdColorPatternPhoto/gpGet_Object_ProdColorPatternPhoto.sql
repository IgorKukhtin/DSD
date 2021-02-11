-- Function: gpGet_Object_ProdColorPatternPhoto()

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorPatternPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorPatternPhoto(
   IN inProdColorPatternPhotoId  Integer,       
   IN inSession                  TVarChar
)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
  UserId Integer;
BEGIN

   UserId := to_number(inSession, '00000000000');   

   SELECT ObjectBlob_ProdColorPatternPhoto_Data.ValueData
 INTO Data
   FROM ObjectBLOB AS ObjectBlob_ProdColorPatternPhoto_Data
   WHERE ObjectBlob_ProdColorPatternPhoto_Data.DescId IN (zc_ObjectBlob_ProdColorPatternPhoto_Data(), zc_ObjectBlob_GoodsPhoto_Data())
     AND ObjectBlob_ProdColorPatternPhoto_Data.ObjectId = inProdColorPatternPhotoId;
    
   RETURN DATA; 
  
END;$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.21         *
*/
-- тест
-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')