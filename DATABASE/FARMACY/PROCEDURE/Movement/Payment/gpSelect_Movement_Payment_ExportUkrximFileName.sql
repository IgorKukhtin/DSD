-- Function: gpSelect_Movement_Payment_ExportUkrximFileName()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment_ExportUkrximFileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment_ExportUkrximFileName(
    IN inMovementId    Integer   , -- ключ Документа
   OUT outFileName     TVarChar  , -- Имя файла
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbJuridicalName TVarChar;
    DECLARE vbBankName TVarChar;
    DECLARE vbOperDate TDateTime;
    DECLARE vbSummaPay TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Payment());
    vbUserId:= inSession;

    SELECT Movement_Payment.OperDate, Movement_Payment.JuridicalName, Object_Bank.ValueData
      INTO vbOperDate, vbJuridicalName, vbBankName
    FROM Movement_Payment_View AS Movement_Payment
         LEFT JOIN Object AS Object_Bank ON Object_Bank.id = 4813205
    WHERE Movement_Payment.Id = inMovementId;
    
    SELECT Sum(MI_Payment.SummaPay)          AS SummaPay
    INTO vbSummaPay
    FROM MovementItem_Payment_View AS MI_Payment
         LEFT OUTER JOIN MovementitemLinkObject AS MILinkObject_BankAccount
                                                ON MILinkObject_BankAccount.MovementItemId = MI_Payment.ID
                                               AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
         LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = MILinkObject_BankAccount.ObjectId
         LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                              ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                             AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
         LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
    WHERE MI_Payment.MovementId = inMovementId
      AND MI_Payment.isErased = FALSE
      AND MI_Payment.NeedPay = TRUE
      AND COALESCE(Object_Bank.id, 0) = 4813205;

    outFileName := REPLACE(vbJuridicalName||' '||vbBankName||' '||TO_CHAR (vbOperDate, 'dd.mm.yyyy')||
                           '='||TRIM(to_char(COALESCE(vbSummaPay, 0), '999999999999D99'))||'.xls', '"', '');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment_ExportUkrximFileName (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 08.09.19                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Payment_ExportUkrximFileName (inMovementId := 15584404 , inSession:= '5');
