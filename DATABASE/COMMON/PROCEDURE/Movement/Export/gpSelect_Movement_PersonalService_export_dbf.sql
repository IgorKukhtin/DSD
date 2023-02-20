-- Function: gpSelect_Movement_PersonalService_export

-- DROP FUNCTION IF EXISTS gpexport_txtbankvostokpayroll (Integer, TVarChar, TFloat, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_export_dbf (Integer, TVarChar, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_export_dbf (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_export_dbf(
    IN inMovementId           Integer,
    --IN inInvNumber            TVarChar,
    --IN inAmount               TFloat,
    --IN inOperDate             TDateTime,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (ACCT_CARD   VarChar (29)
             , FIO         VarChar (50)
             , ID_CODE     VarChar (10)
             , SUMA        NUMERIC (10,2)                                   
             )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBankId    Integer;
   DECLARE vbTotalSumm TFloat;

   DECLARE r RECORD;
   DECLARE i Integer; -- автонумерация
   DECLARE e Text;
   DECLARE er Text;

   DECLARE vbOperDate TDateTime;

   DECLARE vbPSLExportKindId Integer;
   DECLARE vbBankName TVarChar;
   DECLARE vbMFO TVarChar;
   DECLARE vbBankAccountId Integer;
   DECLARE vbBankAccountName TVarChar;
   DECLARE vbContentType TVarChar;
   DECLARE vbOnFlowType TVarChar; 
   DECLARE vbKoeffSummCardSecond NUMERIC (16,10); 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- *** Временная таблица для сбора результата
     CREATE TEMP TABLE _tmpResult (NPP Integer, CARDIBAN TVarChar, FIO TVarChar, ID_CODE TVarChar, SUMA TFloat) ON COMMIT DROP;

     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Export() AND MB.ValueData = TRUE) AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.<%> № <%> от <%> уже была выгружена.%Для повторной выгрузки необходимо перепровести документ.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                        ;
                         
     END IF;
     
 
     -- определили данные из ведомости начисления
     SELECT Object_Bank.Id                 AS BankId             -- БАНК
          , Object_Bank.ValueData          AS BankName           -- БАНК
          , ObjectString_MFO.ValueData     AS MFO                --
          , Object_BankAccount.Id          AS BankAccountId      -- р/счет
          , Object_BankAccount.ValueData   AS BankAccountName    -- р/счет
          , ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId AS PSLExportKindId    -- Тип выгрузки ведомости в банк
          , ObjectString_ContentType.ValueData ::TVarChar   AS ContentType  -- Content-Type
          , ObjectString_OnFlowType.ValueData  ::TVarChar   AS OnFlowType   -- Вид начисления в банке
          , CAST ((ObjectFloat_KoeffSummCardSecond.ValueData/ 1000) AS NUMERIC (16,10))  AS KoeffSummCardSecond --Коэфф для выгрузки ведомости Банк 2ф.
   INTO vbBankId, vbBankName, vbMFO
      , vbBankAccountId, vbBankAccountName
      , vbPSLExportKindId, vbContentType, vbOnFlowType
      , vbKoeffSummCardSecond
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                ON ObjectLink_PersonalServiceList_Bank.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_PersonalServiceList_Bank.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PSLExportKind
                                ON ObjectLink_PersonalServiceList_PSLExportKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_PSLExportKind.DescId = zc_ObjectLink_PersonalServiceList_PSLExportKind()

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_BankAccount
                                ON ObjectLink_PersonalServiceList_BankAccount.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId 
                               AND ObjectLink_PersonalServiceList_BankAccount.DescId = zc_ObjectLink_PersonalServiceList_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_PersonalServiceList_BankAccount.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_ContentType 
                                  ON ObjectString_ContentType.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectString_ContentType.DescId = zc_ObjectString_PersonalServiceList_ContentType()
           LEFT JOIN ObjectString AS ObjectString_OnFlowType 
                                  ON ObjectString_OnFlowType.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectString_OnFlowType.DescId = zc_ObjectString_PersonalServiceList_OnFlowType()

           LEFT JOIN ObjectString AS ObjectString_MFO
                                  ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                 AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()

           LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                 ON ObjectFloat_KoeffSummCardSecond.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()

     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList();


     --Райфайзен
     IF vbBankId = 81283
     THEN

     INSERT INTO _tmpResult (NPP, CARDIBAN, FIO, ID_CODE, SUMA)

        SELECT ROW_NUMBER() OVER (ORDER BY gpSelect.card) AS NPP 
             , gpSelect.card         ::TVarChar AS CARDIBAN   -- Номер карточного (или другого) счёта
             , gpSelect.PersonalName ::TVarChar AS FIO        -- Фамилия сотрудника - Прізвище співробітника
             , gpSelect.INN          ::TVarChar AS ID_CODE    -- Табельный номер сотрудника
             , CAST (COALESCE (gpSelect.SummCardRecalc, 0) AS NUMERIC (10, 2))   AS SUMA        -- Сумма для зачисления на счёт сотрудника в формате ГРН,КОП
        FROM gpSelect_MovementItem_PersonalService (inMovementId := inMovementId 
                                                  , inShowAll    := FALSE
                                                  , inIsErased   := FALSE
                                                  , inSession    := inSession
                                                   ) AS gpSelect
        WHERE COALESCE (gpSelect.SummCardRecalc, 0) <> 0;  

     END IF;


     -- сохранили свойство <Сформирована Выгрузка (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Export(), inMovementId, TRUE);

     -- Результат
     RETURN QUERY   
     
     SELECT _tmpResult.CARDIBAN ::VarChar (29) AS ACCT_CARD
          , _tmpResult.FIO      ::VarChar (50)
          , _tmpResult.ID_CODE  ::VarChar (10)
          , _tmpResult.SUMA     ::NUMERIC (10,2)
     FROM _tmpResult
     ORDER BY NPP; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_export_dbf (24465293 , '1959', 50000.01, '15.06.2016', zfCalc_UserAdmin());