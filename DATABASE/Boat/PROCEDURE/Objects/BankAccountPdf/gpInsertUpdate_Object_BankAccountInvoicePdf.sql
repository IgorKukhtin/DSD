-- Function: gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountInvoicePdf(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , -- Название PDF
    IN inMovmentItemId             Integer   , -- элемент BankAccount
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


   -- Проверка
   IF COALESCE (inMovmentItemId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не установлено значение <элемент BankAccount>.';
   END IF;

   -- Проверка
   IF COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RAISE EXCEPTION 'Ошибка.Не передано имя файла.';
   END IF;


   -- ВСЕГДА попробуем найти
   ioId:= (SELECT OF_Id.ObjectId 
           FROM ObjectFloat AS OF_Id
                INNER JOIN Object AS Object_BankAccountPdf 
                                  ON Object_BankAccountPdf.Id        = OF_Id.ObjectId 
                                 AND Object_BankAccountPdf.DescId    = zc_Object_BankAccountPdf()
                                 --  с таким названием PDF
                                 AND Object_BankAccountPdf.ValueData = inPhotoName
           -- элемент BankAccount
           WHERE OF_Id.ValueData = inMovmentItemId :: TFloat
             AND OF_Id.DescId    = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
          );

   -- сохранили
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