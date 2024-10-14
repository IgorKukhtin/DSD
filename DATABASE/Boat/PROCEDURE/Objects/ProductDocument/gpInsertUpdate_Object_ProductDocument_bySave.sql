-- Function: gpInsertUpdate_Object_ProductDocument_bySave(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductDocument_bySave (Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductDocument_bySave(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inDocumentName                  TVarChar  , -- Название PDF
    IN inProductId                 Integer   , -- Документ Счет
    IN inProductDocumentData                   TBlob     , -- Файл
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


   -- Проверка
   IF COALESCE (inProductId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Boat>.';
   END IF;

   -- Проверка
   IF COALESCE (TRIM (inDocumentName), '') = '' 
   THEN 
       RAISE EXCEPTION 'Ошибка.Не передано имя файла.';
   END IF;


   -- ВСЕГДА попробуем найти
   ioId:= (SELECT Object_ProductDocument.Id        AS Id
           FROM Object AS Object_ProductDocument
                JOIN ObjectLink AS ObjectLink_ProductDocument_Product
                                ON ObjectLink_ProductDocument_Product.ObjectId = Object_ProductDocument.Id
                               AND ObjectLink_ProductDocument_Product.DescId = zc_ObjectLink_ProductDocument_Product()
                               AND ObjectLink_ProductDocument_Product.ChildObjectId = inProductId
           WHERE Object_ProductDocument.DescId = zc_Object_ProductDocument()
             AND TRIM (Object_ProductDocument.ValueData) = TRIM (inDocumentName)    --  с таким названием PDF
          );

   -- сохранили
   ioId :=  gpInsertUpdate_Object_ProductDocument (ioId                 := ioId
                                                 , inDocumentName       := inDocumentName
                                                 , inProductId          := inProductId
                                                 , inProductDocumentData:= inProductDocumentData
                                                 , inSession            := inSession
                                                  );  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.               
 14.10.24         *
*/

-- тест
--