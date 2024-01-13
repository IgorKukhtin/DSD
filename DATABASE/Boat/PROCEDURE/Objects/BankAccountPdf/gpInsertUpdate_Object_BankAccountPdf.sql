-- Function: gpInsertUpdate_Object_BankAccountPdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountPdf(Integer, TVarChar, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountPdf(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inMovmentItemId             Integer   , --  
    IN inPhotoTagId                Integer   ,
    IN inBankAccountPdfData        TBlob     , -- Файл
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

    -- проверка
   IF COALESCE (inMovmentItemId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка! Документ не выбран!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ не выбран.'           :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_BankAccountPdf' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- если пусто
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RETURN;
       -- попробуем найти
       --ioId:= (SELECT OL.ObjectId FROM ObjectFloat AS OL WHERE OL.ValueData ::Integer = inMovmentItemId AND OL.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId());
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccountPdf(), 0, inPhotoName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_BankAccountPdf_Data(), ioId, inBankAccountPdfData);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountPdf_PhotoTag(), ioId, inPhotoTagId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BankAccountPdf_MovmentItemId(), ioId, inMovmentItemId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.24         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccountPdf (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')

