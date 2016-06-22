-- Function: gpInsertUpdate_MI_PersonalService_Child_Auto()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_Auto (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
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
    --IN inHoursPlan           TFloat    , -- 
    --IN inHoursDay            TFloat    , -- 
    --IN inPersonalCount       TFloat    , -- 
    IN inGrossOne            TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbpersonalid Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMIMasterId Integer;
   DECLARE vbMIChildId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInfoMoneyId_def Integer;

   DECLARE ioId Integer;
   
   DECLARE vbHoursPlan TFloat;
   DECLARE vbHoursDay TFloat;
   DECLARE vbPersonalCount TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    -- ищем ИД документа (ключ - дата, подразделение, ведомость)
    SELECT MovementDate_ServiceDate.MovementId  AS Id
         , ObjectLink_PersonalServiceList_Juridical.ChildObjectId AS JuridicalId
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
                             ON ObjectLink_PersonalServiceList_Juridical.ObjectId = inPersonalServiceListId
                            AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
   
    WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
      AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate();
               
    
      IF COALESCE (vbMovementId,0) = 0 THEN
       -- записываем новый <Документ>
       vbMovementId := lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                              , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) --inInvNumber
                                                              , inOperDate                := inEndDate
                                                              , inServiceDate             := DATE_TRUNC ('MONTH', inEndDate) :: TDateTime
                                                              , inComment                 := '' :: TVarChar
                                                              , inPersonalServiceListId   := inPersonalServiceListId 
                                                              , inJuridicalId             := vbJuridicalId
                                                              , inUserId                  := vbUserId
                                                               );
    
      END IF;
      
       -- сохранили свойство <создан автоматически>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
      
      -- Ищеи ИД строки мастера (ключ - ид документа, сотрудник, подразделение)
      SELECT MovementItem.Id AS MovementItemId
           , ObjectLink_Personal_Member.ObjectId AS PersonalId
      INTO vbMIMasterId, vbPersonalId
      FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                           AND MILinkObject_Unit.ObjectId = inUnitId
          INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                           AND MILinkObject_Position.ObjectId = inPositionId
                                                                                 
          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                               AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                                                             
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased = False;

      IF COALESCE (vbMIMasterId,0) = 0 THEN 
       vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101()); -- 60101 Заработная плата + Заработная плата
       vbPersonalId := (SELECT ObjectLink.ObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member() AND ObjectLink.ChildObjectId = inMemberId);
         -- записываем строку документа
         SELECT tmp.ioId
         INTO vbMIMasterId
         FROM lpInsertUpdate_MovementItem_PersonalService            (ioId                 := COALESCE(vbMIMasterId,0) ::Integer
                                                                    , inMovementId         := vbMovementId
                                                                    , inPersonalId         := vbPersonalId
                                                                    , inIsMain             := True
                                                                    , inSummService        := 0 ::TFloat--inSummService
                                                                    , inSummCardRecalc     := 0 ::TFloat--inSummCardRecalc
                                                                    , inSummMinus          := 0 ::TFloat--inSummMinus
                                                                    , inSummAdd            := 0 ::TFloat--inSummAdd
                                                                    , inSummHoliday        := 0 ::TFloat--inSummHoliday
                                                                    , inSummSocialIn       := 0 ::TFloat--inSummSocialIn
                                                                    , inSummSocialAdd      := 0 ::TFloat--inSummSocialAdd
                                                                    , inSummChild          := 0 ::TFloat--inSummChild
                                                                    , inComment            := ''::TVarChar--inComment
                                                                    , inInfoMoneyId        := vbInfoMoneyId_def --inInfoMoneyId
                                                                    , inUnitId             := inUnitId
                                                                    , inPositionId         := inPositionId
                                                                    , inMemberId           := inMemberId
                                                                    , inPersonalServiceListId  := inPersonalServiceListId
                                                                    , inUserId             := vbUserId
                                                                   ) AS tmp;
                                          
         -- сохранили свойство строки <создан автоматически>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), vbMIMasterId, TRUE);
         
      END IF;

      --ищем МИ_чайлд 
      SELECT MovementItem.Id 
      INTO vbMIChildId
      FROM MovementItem
         LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                           ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                          --AND (MILinkObject_PositionLevel.ObjectId = inPositionLevelId OR inPositionLevelId = 0)
         LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                           ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                          AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
                                          --AND (MILinkObject_StaffList.ObjectId = inStaffListId OR inStaffListId = 0)
         LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                           ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
                                          --AND (MILinkObject_ModelService.ObjectId = inModelServiceId OR inModelServiceId = 0)
         LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                          ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                         AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()                                                           
                                         --AND (MILinkObject_StaffListSummKind.ObjectId = inStaffListSummKindId OR inStaffListSummKindId=0)
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.ParentId = vbMIMasterId
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.isErased = False
        AND MovementItem.ObjectId = inMemberId
        AND (MILinkObject_PositionLevel.ObjectId = inPositionLevelId OR inPositionLevelId = 0)
        AND (MILinkObject_StaffList.ObjectId = inStaffListId OR inStaffListId = 0)
        AND (MILinkObject_ModelService.ObjectId = inModelServiceId OR inModelServiceId = 0)
        AND (MILinkObject_StaffListSummKind.ObjectId = inStaffListSummKindId OR inStaffListSummKindId=0)
       ;

     -- получаем данные из спр. Штатное расписание
     SELECT ObjectFloat_HoursPlan.ValueData     AS HoursPlan  
          , ObjectFloat_HoursDay.ValueData      AS HoursDay
          , ObjectFloat_PersonalCount.ValueData AS PersonalCount
     INTO  vbHoursPlan  
         , vbHoursDay
         , vbPersonalCount
     FROM Object AS Object_StaffList --ON Object_StaffList.Id = ObjectLink_StaffList_Unit.ObjectId
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                                ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
     WHERE Object_StaffList.Id = inStaffListId
       AND Object_StaffList.DescId = zc_Object_StaffList();

      
      --сохраняем/ записываем МИ_чайлд 
      PERFORM lpInsertUpdate_MI_PersonalService_Child( ioId                   := COALESCE(vbMIChildId, 0) ::Integer
                                                     , inMovementId           := vbMovementId ::Integer
                                                     , inParentId             := vbMIMasterId ::Integer
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
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.06.16         *
*/

-- тест
--select * from gpInsertUpdate_MI_PersonalService_Child_Auto(inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
