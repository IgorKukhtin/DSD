-- Function: gpInsertUpdate_Object_InvoicePdf_bySave(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InvoicePdf_bySave(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InvoicePdf_bySave(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inMovementId                Integer   , --  
    IN inInvoicePdfData            TBlob     , -- Файл
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- если пусто
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RAISE EXCEPTION 'Ошибка! Не передано имя файла!';
   END IF;

   -- попробуем найти
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') <> '' 
   THEN 
       ioId:= (SELECT OF_Id.ObjectId 
               FROM ObjectFloat AS OF_Id
                    INNER JOIN Object AS Object_InvoicePdf 
                                      ON Object_InvoicePdf.Id        = OF_Id.ObjectId 
                                     AND Object_InvoicePdf.DescId    = zc_Object_InvoicePdf()
                                     AND Object_InvoicePdf.ValueData = inPhotoName
               WHERE OF_Id.ValueData ::Integer = inMovementId 
                 AND OF_Id.DescId = zc_ObjectFloat_InvoicePdf_MovementId());
   END IF;

   ioId :=  gpInsertUpdate_Object_InvoicePdf (ioId                 := ioId
                                            , inPhotoName          := inPhotoName
                                            , inMovementId         := inMovementId
                                            , inInvoicePdfData := inInvoicePdfData
                                            , inSession            := inSession);  
                                            
                                             INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inMovementId                 Integer   , --  
    IN inInvoicePdfData            TBlob     , -- Файл
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.               
 26.02.24         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_InvoicePdf_bySave (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')