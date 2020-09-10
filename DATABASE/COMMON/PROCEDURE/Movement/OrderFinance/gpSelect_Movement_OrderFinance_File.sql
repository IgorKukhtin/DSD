-- Function: gpSelect_Movement_OrderFinance_File(Integer, tvarchar)

-- DROP FUNCTION gpSelect_Movement_OrderFinance_File (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderFinance_File(
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


     -- параметры из документа
    SELECT Movement.InvNumber
         , Movement.OperDate
         , Object_BankAccount_View.Name AS BankAccountName
         , Object_BankAccount_View.MFO
   INTO vbInvNumber, vbOperDate, vbBankAccountName, vbMFO
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                      ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                     AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
         LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_OrderFinance();


     -- первые строчки XML
     --INSERT INTO _Result(RowData) VALUES ('<?xml version= «1.0» encoding= «win-1251»?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     ---INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
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
        FROM MovementItem
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                             ON MILinkObject_BankAccount.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
            LEFT JOIN Object_BankAccount_View AS Partner_BankAccount_View ON Partner_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE;
     
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
 06.09.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_File (inMovementId:= 14022564, inSession:= zfCalc_UserAdmin())