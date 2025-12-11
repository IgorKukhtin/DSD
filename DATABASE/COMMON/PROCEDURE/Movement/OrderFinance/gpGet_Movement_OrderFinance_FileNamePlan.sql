-- Function: gpGet_Movement_OrderFinance_FileName(Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileNamePlan (Integer,TVarChar, TDateTime, Boolean,Boolean,Boolean,Boolean,Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_FileNamePlan (Integer,TVarChar, TDateTime, Boolean,Boolean,Boolean,Boolean,Boolean, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_FileNamePlan(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inMovementId           Integer   ,
    IN inBankName_Main        TVarChar  ,
    IN inOperDate             TDateTime ,
    IN inisDay_1              Boolean    , --
    IN inisDay_2              Boolean    , --
    IN inisDay_3              Boolean    , --
    IN inisDay_4              Boolean    , --
    IN inisDay_5              Boolean    , --
    IN inisNPP                Boolean    , -- для № очереди
    IN inNPP                  TFloat     , -- № очереди
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     --проверка
     IF COALESCE (inBankName_Main,'') = ''
     THEN
          RAISE EXCEPTION 'Ошибка.Банк не выбран.';
     END IF;

     IF COALESCE (inisNPP, FALSE) = TRUE AND COALESCE (inNPP,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.№ очереди не задан.';
     END IF;

    -- Результат
     SELECT REPLACE (inBankName_Main, '"', '')
            || '_' || REPLACE ( zfConvert_DateShortToString (inOperDate 
                                                             + (''|| CASE WHEN COALESCE (inisDay_1,FALSE) = TRUE THEN 0
                                                                          WHEN COALESCE (inisDay_2,FALSE) = TRUE THEN 1
                                                                          WHEN COALESCE (inisDay_3,FALSE) = TRUE THEN 2
                                                                          WHEN COALESCE (inisDay_4,FALSE) = TRUE THEN 3
                                                                          WHEN COALESCE (inisDay_5,FALSE) = TRUE THEN 4
                                                                     END ||' DAY') ::Interval 
                                                               ) , '.', '')
            || CASE WHEN inisNPP = TRUE THEN '_'||zfConvert_IntToString (inNPP::Integer,0) ELSE '' END  --если по № очери то указать после даты
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

SELECT * FROM gpGet_Movement_OrderFinance_FileNamePlan
(inMovementId:= 14022564, inBankName_Main :=  'ПАТ "ОТП БАНК"'  ::TVarChar , inOperDAte := '17.01.2025' ::TDateTime ,
 inisDay_1 :=  FAlse ::Boolean , inisDay_2 := FAlse  ::Boolean, inisDay_3 := FAlse ::Boolean, inisDay_4 := True ::Boolean, inisDay_5 := FAlse ::Boolean,inisNPP := true, inNPP := 2,
 inSession:= zfCalc_UserAdmin()) 
 */
