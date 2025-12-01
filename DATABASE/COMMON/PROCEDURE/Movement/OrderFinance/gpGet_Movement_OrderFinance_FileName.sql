-- Function: gpGet_Movement_OrderFinance_FileName(Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileName (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileName (Integer,TVarChar, TDateTime, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_FileName(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inMovementId           Integer   ,
    IN inBankName_Main        TVarChar  ,
    IN inOperDate             TDateTime ,
    IN inisPlan_1             Boolean    , --
    IN inisPlan_2             Boolean    , --
    IN inisPlan_3             Boolean    , --
    IN inisPlan_4             Boolean    , --
    IN inisPlan_5             Boolean    , --
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
     SELECT REPLACE (inBankName_Main, '"', '')
            || '_' || REPLACE ( zfConvert_DateShortToString (inOperDate 
                                                             + (''|| CASE WHEN COALESCE (inisPlan_1,FALSE) = TRUE THEN 0
                                                                          WHEN COALESCE (inisPlan_2,FALSE) = TRUE THEN 1
                                                                          WHEN COALESCE (inisPlan_3,FALSE) = TRUE THEN 2
                                                                          WHEN COALESCE (inisPlan_4,FALSE) = TRUE THEN 3
                                                                          WHEN COALESCE (inisPlan_5,FALSE) = TRUE THEN 4
                                                                     END ||' DAY') ::Interval 
                                                               ) , '.', '')
             AS outFileName
          , 'xml'                         AS outDefaultFileExt
          , FALSE                         AS outEncodingANSI
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
/*

SELECT * FROM gpGet_Movement_OrderFinance_FileName
(inMovementId:= 14022564,inBankName_Main :=  'ПАТ "ОТП БАНК"'  ::TVarChar , inOperDAte := '17.01.2025' ::TDateTime ,
 inisPlan_1 :=  FAlse ::Boolean , inisPlan_2 := FAlse  ::Boolean, inisPlan_3 := FAlse ::Boolean, inisPlan_4 := True ::Boolean, inisPlan_5 := FAlse ::Boolean,
 inSession:= zfCalc_UserAdmin()) 
 
*/