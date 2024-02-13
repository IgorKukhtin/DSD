-- Function: gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountInvoicePdf(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inMovmentItemId             Integer   , --  
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
                    INNER JOIN Object AS Object_BankAccountPdf 
                                      ON Object_BankAccountPdf.Id        = OF_Id.ObjectId 
                                     AND Object_BankAccountPdf.DescId    = zc_Object_BankAccountPdf()
                                     AND Object_BankAccountPdf.ValueData = inPhotoName
               WHERE OF_Id.ValueData ::Integer = inMovmentItemId 
                 AND OF_Id.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId());
   END IF;

   ioId :=  gpInsertUpdate_Object_BankAccountPdf (ioId                 := ioId
                                                , inPhotoName          := inPhotoName
                                                , inMovmentItemId      := inMovmentItemId
                                                , inBankAccountPdfData := inBankAccountPdfData
                                                , inSession            := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.               
 12.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BankAccountInvoicePdf (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')