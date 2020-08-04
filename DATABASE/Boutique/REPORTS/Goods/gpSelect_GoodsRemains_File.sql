-- Function: gpSelect_GoodsRemains_File(Integer, tvarchar)

-- DROP FUNCTION gpSelect_GoodsRemains_File (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_File(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbInvNumber Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbBankAccountName TVarChar;
   DECLARE vbMFO TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;

     -- первые строчки XML
     --INSERT INTO _Result(RowData) VALUES ('<?xml version= «1.0» encoding= «win-1251»?>');
     --INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<ROWDATA>');

     -- Строки
     INSERT INTO _Result(RowData)
        SELECT '<ROW AMOUNT ="'      || CAST (MovementItem.Amount * 100 AS NUMERIC (16,0)) ||'"'     --Сумма платежа в копейках
             ||' CORRSNAME ="'       || COALESCE(Object_Juridical.ValueData,'') ||'"'                --Наименование получателя платежа
             ||' DETAILSOFPAYMENT ="'|| COALESCE(Object_InfoMoney.ValueData,'') ||'"'                --Назначение платежа
             ||' CORRACCOUNTNO ="'   || COALESCE(Partner_BankAccount_View.Name,'') ||'"'             --№ счета получателя платежа
             ||' ACCOUNTNO ="'       || COALESCE(vbBankAccountName,'') ||'"'                         --№ счета плательщика
             ||' CORRBANKID ="'      || COALESCE(Partner_BankAccount_View.MFO,'') ||'"'              --Код банка получателя платежа (МФО)
             ||' CORRIDENTIFYCODE ="'|| COALESCE(ObjectHistory_JuridicalDetails_View.OKPO,'') ||'"'  --Идентификационный код получателя платежа(ЕГРПОУ)
             ||' CORRCOUNTRYID ="'   || '804' ||'"'                                                  --Код страны корреспондента (При отсутствии автоматически выбирается Украина (804))
             ||' PRIORITY ="'        || '50' ||'"'                                                   --Приоритет (По умолчанию 50)
             ||' BANKID ="'          || COALESCE(vbMFO,'') ||'"'                                     --Код банка плательщика (МФО)
             --||' DOCUMENTNO       ="' || MovementItem.ObjectId ||'"'     --№ документа (Если номер не указан, будет использоваться автонумерация)
             --||' VALUEDATE        ="' || MovementItem.ObjectId ||'"'     --Дата валютирования
             --||' DOCUMENTDATE     ="' || 'DOCUMENTDATE' ||'"'            --Дата документа (ГГГГММДД)
             --||' ADDENTRIES       ="' || 'ADDENTRIES' ||'"'              --Дополнительные реквизиты платежа
             --||' PURPOSEPAYMENTID ="' || 'PURPOSEPAYMENTID' ||'"'        --Код назначения платежа (Целое 3-значное число)
             ||'/>' 
        FROM .......;
     
     
     -- оставила как пример, нужно сделать выборку и правильную структуру
     
     -- последняя строчки XML
     INSERT INTO _Result(RowData) VALUES ('</ROWDATA>');
     
     -- Результат
     RETURN QUERY
        SELECT _Result.RowData FROM _Result;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.20         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsRemains_File (inMovementId:= 14022564, inSession:= zfCalc_UserAdmin())