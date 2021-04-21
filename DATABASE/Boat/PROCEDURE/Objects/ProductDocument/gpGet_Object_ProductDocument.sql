-- Function: gpGet_Object_ProductDocument()

DROP FUNCTION IF EXISTS gpGet_Object_ProductDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProductDocument(
IN inProductDocumentId  Integer,       /* Форма */
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
       ObjectBlob_ProductDocument_Data.ValueData INTO Data
   FROM ObjectBLOB AS ObjectBlob_ProductDocument_Data
  WHERE ObjectBlob_ProductDocument_Data.DescId = zc_ObjectBlob_ProductDocument_Data() 
    AND ObjectBlob_ProductDocument_Data.ObjectId = inProductDocumentId;
    
   RETURN DATA; 
  
END;$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.21         *
*/
-- тест
-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')