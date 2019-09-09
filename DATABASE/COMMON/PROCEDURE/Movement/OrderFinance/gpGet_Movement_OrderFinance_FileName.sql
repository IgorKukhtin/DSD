-- Function: gpGet_Movement_OrderFinance_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_FileName(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inMovementId           Integer   ,
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     SELECT COALESCE (Object_BankAccount_View.Name, '')
            || '_' || REPLACE (zfConvert_DateShortToString (Movement.OperDate), '.', '')
            || '_' || Movement.InvNumber  AS outFileName
          , 'xml'                         AS outDefaultFileExt
          , TRUE                         AS outEncodingANSI
   INTO outFileName, outDefaultFileExt, outEncodingANSI
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                      ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                     AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
         LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId
     WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.16                                        *
*/


-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance_FileName (inMovementId:= 14022564, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
