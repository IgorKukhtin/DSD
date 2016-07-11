-- Function: gpInsertUpdate_MI_PersonalService_Child_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_Auto(
    IN inUnitId              Integer   , -- подразделение
    IN inPersonalServiceListId Integer   , -- ведомость начисления
    IN inMemberId            Integer   , -- физ.лицо
    IN inStartDate           TDateTime , -- дата
    IN inEndDate             TDateTime , -- дата
    IN inPositionId          Integer   , -- должность
    IN inPositionLevelId     Integer   , -- разряд должности
    IN inStaffListId         Integer   , -- штатное расписание
    IN inModelServiceId      Integer   , -- Модели начисления
    IN inStaffListSummKindId Integer   , -- Типы сумм для штатного расписания
    IN inAmount              TFloat    , -- 
    IN inMemberCount         TFloat    , -- 
    IN inDayCount            TFloat    , -- 
    IN inWorkTimeHoursOne    TFloat    , -- 
    IN inWorkTimeHours       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    -- IN inHoursPlan           TFloat    , -- 
    -- IN inHoursDay            TFloat    , -- 
    -- IN inPersonalCount       TFloat    , -- 
    IN inGrossOne            TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbId_Master Integer;
   DECLARE vbId_Child Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsMain Boolean;
   DECLARE vbIsAuto Boolean;
   
   DECLARE vbInfoMoneyId_def Integer;
   DECLARE ioId Integer;
   
   DECLARE vbHoursPlan TFloat;
   DECLARE vbHoursDay TFloat;
   DECLARE vbPersonalCount TFloat;
   DECLARE vbsummservice TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF COALESCE (inStaffListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Штатное расписание>.';
     END IF;
     -- проверка
     IF COALESCE (inModelServiceId, 0) = 0 AND COALESCE (inStaffListSummKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Модель начисления> или <Типы сумм для штатного расписания>.';
     END IF;


     -- поиск
     vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101()); -- 60101 Заработная плата + Заработная плата 


     -- поиск сотрудника (ключ - физ.лицо + сотрудник + подразделение)
     WITH 
         tmp AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                      , Object_Personal.Id AS PersonalId
                      , ObjectLink_Personal_Unit.ChildObjectId  AS UnitId
                      , ObjectLink_Personal_Position.ChildObjectId AS PositionId
                 FROM ObjectLink AS ObjectLink_Personal_Member
                      LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                                          AND Object_Personal.isErased = FALSE
                      LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                     ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                      LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                     ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                  
                 WHERE ObjectLink_Personal_Member.ChildObjectId   = inMemberId
                   AND ObjectLink_Personal_Member.DescId          = zc_ObjectLink_Personal_Member()
                 )

           SELECT COALESCE (tmp.PersonalId, COALESCE (tmp1.PersonalId, tmp2.PersonalId))  
                , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE)
          INTO vbPersonalId, vbIsMain
           FROM Object AS Object_Member 
              LEFT JOIN tmp ON tmp.MemberId = Object_Member.Id
                            AND tmp.UnitId = inUnitId
                            AND tmp.PositionId = inPositionId
              LEFT JOIN tmp AS tmp1 ON tmp1.MemberId = Object_Member.Id
                            AND tmp1.UnitId = inUnitId
              LEFT JOIN tmp AS tmp2 ON tmp2.MemberId = Object_Member.Id
                            AND tmp2.PositionId = inPositionId
              LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                        ON ObjectBoolean_Personal_Main.ObjectId = COALESCE (tmp.PersonalId, COALESCE (tmp1.PersonalId, tmp2.PersonalId))
                                       AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main() 
            WHERE Object_Member.DescId = zc_Object_Member()
              AND Object_Member.Id =  inMemberId
            ORDER BY CASE WHEN ObjectBoolean_Personal_Main.ValueData = TRUE THEN 0 ELSE 1 END, COALESCE (tmp.PersonalId, COALESCE (tmp1.PersonalId, tmp2.PersonalId))
            LIMIT 1
          ;

         
    -- поиск документа (ключ - Месяц начислений + ведомость)
    SELECT MovementDate_ServiceDate.MovementId
         , ObjectLink_PersonalServiceList_Juridical.ChildObjectId AS JuridicalId -- на которое происходит начисление(соц выплаты)
           INTO vbMovementId, vbJuridicalId
    FROM MovementDate AS MovementDate_ServiceDate
        INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                           AND Movement.DescId = zc_Movement_PersonalService()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
        INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                      ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                     AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                     AND MovementLinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId
        LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                             ON ObjectLink_PersonalServiceList_Juridical.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                            AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
   
        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
    WHERE MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate)
      AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
    ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId
    LIMIT 1
   ;
               
    
      IF COALESCE (vbMovementId, 0) = 0
      THEN
          -- сохранили новый <Документ>
          vbMovementId := lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                                 , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) --inInvNumber
                                                                 , inOperDate                := inEndDate
                                                                 , inServiceDate             := DATE_TRUNC ('MONTH', inEndDate) :: TDateTime
                                                                 , inComment                 := '' :: TVarChar
                                                                 , inPersonalServiceListId   := inPersonalServiceListId 
                                                                 , inJuridicalId             := vbJuridicalId
                                                                 , inUserId                  := vbUserId
                                                                  );
          -- сохранили свойство <создан автоматически>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
    
      END IF;
      
      
      -- поиск zc_MI_Master (ключ - документ + сотрудник + подразделение)
      SELECT MovementItem.Id                              AS Id_Master
           , COALESCE (MIBoolean_isAuto.ValueData, FALSE) AS isAuto
             INTO vbId_Master, vbIsAuto
      FROM MovementItem
           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId       = zc_MILinkObject_Unit()
                                            AND MILinkObject_Unit.ObjectId = inUnitId
           INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                            AND MILinkObject_Position.ObjectId = inPositionId
                                                                                 
           LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                         ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                        AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
                                         
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.ObjectId   = vbPersonalId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE;


      IF COALESCE (vbId_Master,0) = 0 THEN 
         -- сохранили zc_MI_Master
         vbId_Master := 
        (SELECT tmp.ioId
         FROM lpInsertUpdate_MovementItem_PersonalService            (ioId                 := vbId_Master
                                                                    , inMovementId         := vbMovementId
                                                                    , inPersonalId         := vbPersonalId
                                                                    , inIsMain             := vbIsMain
                                                                    , inSummService        := 0 -- !!!потом зальем сумму!!!
                                                                    , inSummCardRecalc     := 0
                                                                    , inSummMinus          := 0
                                                                    , inSummAdd            := 0
                                                                    , inSummHoliday        := 0
                                                                    , inSummSocialIn       := 0
                                                                    , inSummSocialAdd      := 0
                                                                    , inSummChild          := 0
                                                                    , inComment            := ''
                                                                    , inInfoMoneyId        := vbInfoMoneyId_def
                                                                    , inUnitId             := inUnitId
                                                                    , inPositionId         := inPositionId
                                                                    , inMemberId           := inMemberId
                                                                    , inPersonalServiceListId := inPersonalServiceListId
                                                                    , inUserId             := vbUserId
                                                                   ) AS tmp);
                                          
         -- сохранили свойство <создан автоматически>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), vbId_Master, TRUE);
         
      END IF;

      -- поиск zc_MI_Child
      vbId_Child:=
     (SELECT MovementItem.Id
      FROM MovementItem
         LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                           ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                           ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                          AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                           ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                          ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                         AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()                                                           
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId     = zc_MI_Child()
        AND MovementItem.ParentId   = vbId_Master
        AND MovementItem.isErased   = FALSE
        AND MovementItem.ObjectId   = inMemberId
        AND (MILinkObject_PositionLevel.ObjectId     = inPositionLevelId     OR inPositionLevelId = 0)
        AND (MILinkObject_StaffList.ObjectId         = inStaffListId         OR inStaffListId = 0)
        AND (MILinkObject_ModelService.ObjectId      = inModelServiceId      OR inModelServiceId = 0)
        AND (MILinkObject_StaffListSummKind.ObjectId = inStaffListSummKindId OR inStaffListSummKindId=0)
     );

     -- получаем данные из спр. Штатное расписание
     SELECT ObjectFloat_HoursPlan.ValueData     AS HoursPlan  
          , ObjectFloat_HoursDay.ValueData      AS HoursDay
          , ObjectFloat_PersonalCount.ValueData AS PersonalCount
            INTO vbHoursPlan, vbHoursDay, vbPersonalCount
     FROM Object AS Object_StaffList
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
          LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                                ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
     WHERE Object_StaffList.Id     = inStaffListId;

      
      -- сохранили zc_MI_Child
      PERFORM lpInsertUpdate_MI_PersonalService_Child( ioId                   := vbId_Child
                                                     , inMovementId           := vbMovementId ::Integer
                                                     , inParentId             := vbId_Master ::Integer
                                                     , inMemberId             := inMemberId ::Integer
                                                     , inPositionLevelId      := inPositionLevelId 
                                                     , inStaffListId          := inStaffListId
                                                     , inModelServiceId       := inModelServiceId
                                                     , inStaffListSummKindId  := inStaffListSummKindId

                                                     , inAmount               := COALESCE(inAmount, 0) ::TFloat
                                                     , inMemberCount          := COALESCE(inMemberCount, 0) ::TFloat
                                                     , inDayCount             := COALESCE(inDayCount, 0) ::TFloat
                                                     , inWorkTimeHoursOne     := COALESCE(inWorkTimeHoursOne, 0) ::TFloat
                                                     , inWorkTimeHours        := COALESCE(inWorkTimeHours, 0) ::TFloat
                                                     , inPrice                := COALESCE(inPrice, 0) ::TFloat
                                                     , inHoursPlan            := COALESCE(vbHoursPlan, 0) ::TFloat
                                                     , inHoursDay             := COALESCE(vbHoursDay, 0) ::TFloat
                                                     , inPersonalCount        := COALESCE(vbPersonalCount, 0) ::TFloat
                                                     , inGrossOne             := COALESCE(inGrossOne, 0) ::TFloat
                                                     , inUserId               := vbUserId
                                                     );

    IF COALESCE (vbIsAuto, TRUE) = TRUE
    THEN 
       vbSummService := (SELECT SUM (MovementItem.Amount) AS Amount
                         FROM MovementItem
                         WHERE MovementItem.ParentId = vbId_Master
                           AND MovementItem.DescId   = zc_MI_Child()
                           AND MovementItem.isErased = FALSE
                         );

       -- обновляем сумму мастера = итого по чайлд
       PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := COALESCE(vbId_Master,0) ::Integer
                                                          , inMovementId         := vbMovementId
                                                          , inPersonalId         := vbPersonalId
                                                          , inIsMain             := COALESCE(MIBoolean_Main.ValueData,FALSE) ::Boolean
                                                          , inSummService        := vbSummService ::TFloat
                                                          , inSummCardRecalc     := COALESCE(MIFloat_SummCard.ValueData,0) ::TFloat--inSummCardRecalc
                                                          , inSummMinus          := COALESCE(MIFloat_SummMinus.ValueData,0) ::TFloat
                                                          , inSummAdd            := COALESCE(MIFloat_SummAdd.ValueData,0) ::TFloat
                                                          , inSummHoliday        := COALESCE(MIFloat_SummHoliday.ValueData,0) ::TFloat
                                                          , inSummSocialIn       := COALESCE(MIFloat_SummSocialIn.ValueData,0) ::TFloat
                                                          , inSummSocialAdd      := COALESCE(MIFloat_SummSocialAdd.ValueData,0) ::TFloat
                                                          , inSummChild          := COALESCE(MIFloat_SummChild.ValueData,0) ::TFloat
                                                          , inComment            := ''
                                                          , inInfoMoneyId        := MILinkObject_InfoMoney.ObjectId
                                                          , inUnitId             := inUnitId
                                                          , inPositionId         := inPositionId
                                                          , inMemberId           := inMemberId
                                                          , inPersonalServiceListId  := inPersonalServiceListId
                                                          , inUserId             := vbUserId
                                                          ) 
       FROM MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                        ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                        ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                        ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                        ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
            LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                        ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
            LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()                                         
       WHERE MovementItem.Id       = vbId_Master
         AND MovementItem.DescId   = zc_MI_Master()
         AND MovementItem.isErased = FALSE;
         
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.06.16         *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_Child_Auto(inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
