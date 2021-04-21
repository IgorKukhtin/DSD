-- Function: gpGet_Object_ProductPhoto()

DROP FUNCTION IF EXISTS gpGet_Object_ProductPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProductPhoto(
IN inProductPhotoId  Integer,       /* Форма */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   UserId := to_number(inSession, '00000000000');   

   SELECT 
       ObjectBlob_ProductPhoto_Data.ValueData INTO Data
   FROM ObjectBLOB AS ObjectBlob_ProductPhoto_Data
  WHERE ObjectBlob_ProductPhoto_Data.DescId = zc_ObjectBlob_ProductPhoto_Data() 
    AND ObjectBlob_ProductPhoto_Data.ObjectId = inProductPhotoId;
    
   RETURN DATA; 
  
END;$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/
-- тест
-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')