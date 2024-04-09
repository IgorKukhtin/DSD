-- Function: gpInsertUpdate_Movement_MobileBills_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MobileBills_From_Excel (TDateTime, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MobileBills_From_Excel(
    IN inOperDate            TDateTime  , -- Дата <Документа>
    IN inContractId          Integer   , -- Контракт
    IN inMobileNum           TVarChar  , -- № телефона
    IN inTotalSum            TFloat    , -- Сумма итого
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbmobileid Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_MobileBills());
     vbUserId := lpGetUserBySession (inSession);
     
     
     RAISE EXCEPTION 'Ошибка. % ', inOperDate;
     IF vbUserId = 5 THEN inOperDate:= '01.06.2024'; END IF;

     -- RAISE EXCEPTION 'Ошибка. Документ не сохранен';

     IF COALESCE (inMobileNum,'') = '' THEN
       RETURN;
     END IF; 


     vbMobileId :=(SELECT MAX(Object_MobileEmployee.Id) 
                   FROM Object AS Object_MobileEmployee
                   WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
                     AND RIGHT (Object_MobileEmployee.ValueData, 9) = inMobileNum
                     AND Object_MobileEmployee.isErased = FALSE
                   );


     IF COALESCE (vbMobileId,0) = 0 THEN
        --сохраняем новый телефон
        vbMobileId:= lpInsertUpdate_Object_MobileEmployee2 (ioId             := 0
                                                          , inCode           := 0
                                                          , inName           := inMobileNum
                                                          , inLimit          := 0
                                                          , inDutyLimit      := 0
                                                          , inNavigator      := 0
                                                          , inComment        := ''
                                                          , inPersonalId     := 0
                                                          , inMobileTariffId := 0
                                                          , inRegionId       := 0
                                                          , inUserId         := vbUserId
                                                      );
     END IF;          

     -- даные - моб.номера
     CREATE TEMP TABLE _tmpMobileEmployee (Id Integer, PhoneNum TVarChar, PersonalId Integer, MobileTariffId Integer, MobileLimit TFloat, DutyLimit TFloat, Navigator TFloat, Monthly TFloat, ContractId Integer) ON COMMIT DROP;
     INSERT INTO _tmpMobileEmployee (Id, PhoneNum, PersonalId, MobileTariffId, MobileLimit, DutyLimit, Navigator, Monthly, ContractId)
	    SELECT Object_MobileEmployee.Id          AS Id
                 , COALESCE (Object_MobileEmployee.ValueData, '') ::TVarChar    AS PhoneNum
                 , COALESCE (ObjectLink_MobileEmployee_Personal.ChildObjectId, 0) ::Integer      AS PersonalId
                 , COALESCE (ObjectLink_MobileEmployee_MobileTariff.ChildObjectId, 0) ::Integer  AS MobileTariffId
                 , COALESCE (ObjecTFloat_Limit.ValueData, 0)      ::TFloat      AS MobileLimit
                 , COALESCE (ObjecTFloat_DutyLimit.ValueData, 0)  ::TFloat      AS DutyLimit
                 , COALESCE (ObjecTFloat_Navigator.ValueData, 0)  ::TFloat      AS Navigator
                 , COALESCE (ObjecTFloat_Monthly.ValueData, 0)    ::TFloat      AS Monthly
                 , COALESCE (ObjectLink_MobileTariff_Contract.ChildObjectId, 0) AS ContractId
            FROM Object AS Object_MobileEmployee
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Limit
                                     ON ObjecTFloat_Limit.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_Limit.DescId = zc_ObjecTFloat_MobileEmployee_Limit()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_DutyLimit
                                     ON ObjecTFloat_DutyLimit.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_DutyLimit.DescId = zc_ObjecTFloat_MobileEmployee_DutyLimit()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Navigator
                                     ON ObjecTFloat_Navigator.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjecTFloat_Navigator.DescId = zc_ObjecTFloat_MobileEmployee_Navigator()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                    ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobileTariff
                                    ON ObjectLink_MobileEmployee_MobileTariff.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_MobileTariff.DescId = zc_ObjectLink_MobileEmployee_MobileTariff()
               LEFT JOIN ObjecTFloat AS ObjecTFloat_Monthly
                                     ON ObjecTFloat_Monthly.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                    AND ObjecTFloat_Monthly.DescId = zc_ObjecTFloat_MobileTariff_Monthly()

               LEFT JOIN ObjectLink AS ObjectLink_MobileTariff_Contract
                                    ON ObjectLink_MobileTariff_Contract.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                   AND ObjectLink_MobileTariff_Contract.DescId = zc_ObjectLink_MobileTariff_Contract()
       
            WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
              AND Object_MobileEmployee.Id = vbMobileId;

     -- переопределяем дату на 1 число месяца
     inOperDate := date_trunc('month', inOperDate);

     -- поиск существующего документа
     vbMovementId := (SELECT Movement.Id AS Id 
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                  AND MovementLinkObject_Contract.ObjectId = inContractId
                      WHERE Movement.OperDate = inOperDate
                        AND Movement.DescId = zc_Movement_MobileBills()
                        AND Movement.StatusId <> zc_Enum_Status_Erased());

     IF COALESCE (vbMovementId,0) = 0 THEN
        -- coхраняем новый документ
        vbMovementId := gpInsertUpdate_Movement_MobileBills (0, CAST (NEXTVAL ('Movement_MobileBills_seq') AS TVarChar), inOperDate , inContractId, inSession);
     END IF; 
     
    -- 
    -- сохранили Элементы - !!!всегда!!!
    PERFORM lpInsertUpdate_MovementItem_MobileBills (ioId                 := COALESCE (tmp.Id,0)
                                                   , inMovementId         := vbMovementId
                                                   , inMobileEmployeeId   := tmp.MobileEmployeeId
                                                   , inAmount             := inTotalSum
                                                   , inCurrMonthly        := tmp.Monthly             -- Ежемесячная абонплата
                                                   , inCurrNavigator      := tmp.Navigator           -- Услуга Навигатор
                                                   , inPrevNavigator      := tmp.Navigator_prev      -- ***Предыдущее состояние услуги Навигатор
                                                   , inLimit              := tmp.MobileLimit         -- Текущий лимит
                                                   , inPrevLimit          := tmp.MobileLimit_prev    -- ***Предыдущий лимит
                                                   , inDutyLimit          := tmp.DutyLimit           -- Служебный лимит
                                                   , inOverlimit          := CASE WHEN inTotalSum - (tmp.MobileLimit + tmp.DutyLimit + tmp.Navigator) > 0 THEN inTotalSum - (tmp.MobileLimit + tmp.DutyLimit + tmp.Navigator) ELSE 0 END
                                                   , inPrevMonthly        := tmp.Monthly_prev        -- *** Ежемесячная абонплата за предыдущий период
                                                   , inEmployeeID         := tmp.PersonalId          -- Сотрудник
                                                   , inPrevEmployeeId     := tmp.PersonalId_prev     -- *** Предыдущий сотрудник
                                                   , inMobileTariffId     := tmp.MobileTariffId      -- Текущий тарифный план
                                                   , inPrevMobileTariffId := tmp.MobileTariffId_prev -- *** Предыдущий тарифный план
                                                   , inUserId             := vbUserId
                                                    )
    FROM (WITH tmpMobileBills_prev AS (SELECT MovementItem.ObjectId              AS MobileEmployeeId
                                            , MIFloat_CurrMonthly.ValueData      AS Monthly
                                            , MIFloat_CurrNavigator.ValueData    AS Navigator
                                            , MIFloat_Limit.ValueData            AS MobileLimit
                                            , MILinkObject_Employee.ObjectId     AS PersonalId
                                            , MILinkObject_MobileTariff.ObjectId AS MobileTariffId
                                            , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                         AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                         AND MovementLinkObject_Contract.ObjectId   = inContractId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased   = FALSE
                                                                   AND MovementItem.ObjectId   = vbMobileId
                                            LEFT JOIN MovementItemFloat AS MIFloat_CurrMonthly
                                                                        ON MIFloat_CurrMonthly.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_CurrMonthly.DescId = zc_MIFloat_CurrMonthly()
                                            LEFT JOIN MovementItemFloat AS MIFloat_CurrNavigator
                                                                        ON MIFloat_CurrNavigator.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_CurrNavigator.DescId = zc_MIFloat_CurrNavigator()
                                            LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                                                        ON MIFloat_Limit.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_Limit.DescId = zc_MIFloat_Limit()
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                                                             ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_MobileTariff
                                                                             ON MILinkObject_MobileTariff.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_MobileTariff.DescId = zc_MILinkObject_MobileTariff()
                                       WHERE -- !!!за Предыдущий месяц!!!
                                             Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 MONTH' AND DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY'
                                         AND Movement.DescId   = zc_Movement_MobileBills()
                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                      )
          -- результат
          SELECT MI_Master.Id
               , _tmpMobileEmployee.Id                              AS MobileEmployeeId
               , COALESCE (_tmpMobileEmployee.Monthly, 0)           AS Monthly
               , COALESCE (tmpMobileBills_prev.Monthly, 0)          AS Monthly_prev
               , COALESCE (_tmpMobileEmployee.Navigator, 0)         AS Navigator
               , COALESCE (tmpMobileBills_prev.Navigator, 0)        AS Navigator_prev
               , COALESCE (_tmpMobileEmployee.MobileLimit, 0)       AS MobileLimit
               , COALESCE (tmpMobileBills_prev.MobileLimit, 0)      AS MobileLimit_prev
               , COALESCE (_tmpMobileEmployee.DutyLimit, 0)         AS DutyLimit
               , _tmpMobileEmployee.PersonalId                      AS PersonalId
               , tmpMobileBills_prev.PersonalId                     AS PersonalId_prev
               , _tmpMobileEmployee.MobileTariffId                  AS MobileTariffId
               , tmpMobileBills_prev.MobileTariffId                 AS MobileTariffId_prev
          FROM _tmpMobileEmployee
               LEFT JOIN tmpMobileBills_prev ON tmpMobileBills_prev.MobileEmployeeId = _tmpMobileEmployee.Id 
                                            AND tmpMobileBills_prev.Ord = 1     
               LEFT JOIN MovementItem AS MI_Master
                                      ON MI_Master.MovementId = vbMovementId
                                     AND MI_Master.isErased   = FALSE
                                     AND MI_Master.ObjectId   = _tmpMobileEmployee.Id
         ) AS tmp;     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.02.17         *
*/

-- тест
-- select * from gpInsertUpdate_Movement_MobileBills_From_Excel(inOperDate := ('02.02.2017')::TDateTime , inContractId := 149099 , inMobileNum := '672355797' , inTotalSum := 255.31 ,  inSession := '5');
