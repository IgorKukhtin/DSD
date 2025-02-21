-- Function: gpInsertUpdate_MI_PersonalService_Child_byUnit()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit_mes (Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_byUnit_mes(
    --IN inStartDate            TDateTime , -- дата
    --IN inEndDate              TDateTime , -- дата 
    IN inSessionCode          Integer   , -- № Сессии MessagePersonalService
    IN inUnitId               Integer   , -- подразделение
    IN inisPersonalService    Boolean   , --   
   OUT outPersonalServiceDate TDateTime , --                        
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
    DECLARE vbUserId    Integer; 
    DECLARE vbStartDate TDateTime;
    DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF COALESCE (inisPersonalService, FALSE) = FALSE
     THEN
         RETURN;
     END IF;

     -- расчет за прошлый месяц
     vbStartDate := '01.02.2025' ::TDateTime; --DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime);
     vbEndDate   := '19.02.2025' ::TDateTime; --DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 DAY')::TDateTime); 
     
     --
     CREATE TEMP TABLE _tmpMessagePersonalService (MemberId Integer
                                                 , PersonalServiceListId Integer
                                                 , Name TVarChar
                                                 , Comment TVarChar) ON COMMIT DROP;

     CREATE TEMP TABLE _tmpPersonal (PersonalId Integer
                                   , MemberId Integer
                                   , PositionId Integer
                                   , PositionLevelId Integer
                                   , PersonalServiceListId Integer
                                   , isMain Boolean) ON COMMIT DROP;  
                                           
     ---- Создать таблицу, в которую будут залиты все данные для анализа
     CREATE TEMP TABLE _tmpReport (PersonalServiceListId Integer
                                 , MemberId Integer
                                 , PositionId Integer
                                 , PositionLevelId Integer
                                 , StaffListId Integer
                                 , ModelServiceId Integer
                                 , StaffListSummKindId Integer
                                 , AmountOnOneMember TFloat
                                 , Count_Member TFloat
                                 , Count_Day TFloat
                                 , SheetWorkTime_Amount TFloat
                                 , SUM_MemberHours TFloat
                                 , Price TFloat
                                 , GrossOnOneMember TFloat
                                 , KoeffHoursWork_car TFloat) ON COMMIT DROP;
     INSERT INTO _tmpReport (PersonalServiceListId 
                           , MemberId 
                           , PositionId 
                           , PositionLevelId 
                           , StaffListId 
                           , ModelServiceId 
                           , StaffListSummKindId 
                           , AmountOnOneMember 
                           , Count_Member 
                           , Count_Day 
                           , SheetWorkTime_Amount 
                           , SUM_MemberHours 
                           , Price 
                           , GrossOnOneMember 
                           , KoeffHoursWork_car )
     SELECT tmp.PersonalServiceListId
          , tmp.MemberId
          , tmp.PositionId
          , tmp.PositionLevelId
          , tmp.StaffListId
          , tmp.ModelServiceId
          , tmp.StaffListSummKindId
          , tmp.AmountOnOneMember
          , tmp.Count_Member
          , tmp.Count_Day
          , tmp.SheetWorkTime_Amount
          , tmp.SUM_MemberHours
          , tmp.Price
          , tmp.GrossOnOneMember
          , tmp.KoeffHoursWork_car
     FROM gpSelect_Report_Wage_Server(inStartDate      := vbStartDate ::TDateTime --дата начала периода
                                    , inEndDate        := vbEndDate   ::TDateTime --дата окончания периода
                                    , inUnitId         := inUnitId    ::Integer   --подразделение
                                    , inModelServiceId := 0           ::Integer   --модель начисления
                                    , inMemberId       := 0           ::Integer   --сотрудник
                                    , inPositionId     := 0           ::Integer   --должность
                                    , inDetailDay                    := FALSE  ::Boolean   --детализировать по дням
                                    , inDetailMonth                  := FALSE  ::Boolean   --детализировать по месяцам 
                                    , inDetailModelService           := FALSE  ::Boolean   --детализировать по моделям
                                    , inDetailModelServiceItemMaster := FALSE  ::Boolean   --детализировать по типам документов в модели
                                    , inDetailModelServiceItemChild  := FALSE  ::Boolean   --детализировать по товарам в типах документов
                                    , inSession        := inSession   ::TVarChar
                                    ) tmp;


     INSERT INTO _tmpPersonal (PersonalId
                             , MemberId
                             , PositionId
                             , PositionLevelId
                             , PersonalServiceListId
                             , isMain)
     SELECT Object_Personal.Id                                            AS PersonalId
          , ObjectLink_Personal_Member.ChildObjectId                      AS MemberId
          , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0)      AS PositionId
          , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId
          , ObjectLink_Personal_PersonalServiceList.ChildObjectId         AS PersonalServiceListId
          , COALESCE (ObjectBoolean_Main.ValueData, FALSE)                AS isMain
     FROM Object AS Object_Personal
          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                               AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                               ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                               ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
          
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
     WHERE Object_Personal.DescId = zc_Object_Personal()
       AND Object_Personal.isErased = FALSE;


     --проверка  
     --1) ведомость не проведена
     --2) в разрезе фио - заполнена графа "Ведомость начисления главная" 
     --3) соответствие должности в табеле и в "Справочнике Штатное расписание (данные) 
     --4) Часы в табеле, до даты увольнения 
     --5) Часы в табеле, после даты приема 
     --6) есть признак "Основное место работы" , если в разрезе фио проверка прошла
        -- только тогда сохранение и проведение, если не прошла - сохраняется только все сообщения об ошибке + фио + должность + ведомость + № сессии + дата/время - все в zc_Object_MessagePersonalService, если ошибки нет тогда 1 строчка ведомость + № сессии + дата/время 
 
     
     -- 1 ведомость не проведена
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT NULL :: Integer, tmp.PersonalServiceListId, 'Документ проведен' ::TVarChar, 'проверка 1' ::TVarChar
     FROM 
          (WITH
           tmpMovement AS (SELECT tmpPSL.PersonalServiceListId
                                , Movement.StatusId
                                , ROW_NUMBER () OVER (PARTITION BY tmpPSL.PersonalServiceListId ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId) AS Ord
                           FROM (SELECT DISTINCT _tmpReport.PersonalServiceListId FROM _tmpReport) AS tmpPSL
                               INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                             ON MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MLO_PersonalServiceList.ObjectId   = tmpPSL.PersonalServiceListId
                               INNER JOIN Movement ON Movement.Id = MLO_PersonalServiceList.MovementId
                                                  AND Movement.DescId   = zc_Movement_PersonalService()
                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                               INNER JOIN MovementDate AS MovementDate_ServiceDate                 
                                                       ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                      AND MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', vbEndDate)
                                                      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                               LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                         ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                           )
           SELECT tmpMovement.*
           FROM tmpMovement
           WHERE tmpMovement.Ord = 1
           ) AS tmp
     WHERE tmp.StatusId = zc_Enum_Status_Complete();
     
     --RAISE EXCEPTION 'Test1. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);

     -- 2 в разрезе фио - заполнена графа "Ведомость начисления главная" 
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, 'Главная ведомость не установлена' ::TVarChar, 'проверка 2' ::TVarChar
     FROM 
          (SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
                LEFT JOIN _tmpPersonal ON _tmpPersonal.MemberId = spReport.MemberId
                                      AND _tmpPersonal.PositionId = spReport.PositionId
                                      AND _tmpPersonal.PositionLevelId = spReport.PositionLevelId
           WHERE _tmpPersonal.PersonalServiceListId IS NULL
          ) AS tmp;
     ---RAISE EXCEPTION 'Test2. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);  

     -- 3 соответствие должности в табеле и в "Справочнике Штатное расписание (данные)
     -- 4) Часы в табеле, до даты увольнения 
     -- 5) Часы в табеле, после даты приема
     
      
     -- 6) есть признак "Основное место работы" , если в разрезе фио проверка прошла 
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, 'Основное место работы не установлено' ::TVarChar, 'проверка 6' ::TVarChar
     FROM 
          (WITH
           --Определено ли для сотрудника Основное место работы
           tmpMain AS (SELECT DISTINCT _tmpPersonal.MemberId
                       FROM _tmpPersonal
                       WHERE _tmpPersonal.isMain = TRUE 
                      )
           SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
                LEFT JOIN tmpMain ON tmpMain.MemberId = spReport.MemberId
           WHERE tmpMain.MemberId IS NULL
          ) AS tmp;
     
     --RAISE EXCEPTION 'Test6. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);
     
     -- после проверок  
     IF (SELECT COUNT (*) FROM _tmpMessagePersonalService) > 0
     THEN
         -- если есть ошибки то записываем их в MessagePersonalService
         PERFORM gpInsertUpdate_Object_MessagePersonalService(ioId                    := 0                          ::Integer,       --
                                                              inCode                  := inSessionCode              ::Integer,      -- № Сессии           
                                                              inName                  := tmp.Name                   ::TVarChar,     -- Сообщение об ошибке
                                                              inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer,      --                    
                                                              inMemberId              := tmp.MemberId               ::Integer,      --                    
                                                              inComment               := tmp.Comment                ::TVarChar,     -- Примечание         
                                                              inSession               := inSession                  ::TVarChar
                                                              )
         FROM _tmpMessagePersonalService AS tmp;
     
     ELSE    
     /*
       -- сохраняем расчитанные отчетом данные по зп
       PERFORM gpInsertUpdate_MI_PersonalService_Child_Auto (inUnitId                 := inUnitId
                                                           , inPersonalServiceListId  := tmp.PersonalServiceListId
                                                           , inMemberId               := tmp.MemberId
                                                           , inStartDate              := vbStartDate
                                                           , inEndDate                := vbEndDate
                                                           , inPositionId             := tmp.PositionId
                                                           , inPositionLevelId        := tmp.PositionLevelId
                                                           , inStaffListId            := tmp.StaffListId
                                                           , inModelServiceId         := tmp.ModelServiceId
                                                           , inStaffListSummKindId    := tmp.StaffListSummKindId
                                                           , inAmount                 := tmp.AmountOnOneMember
                                                           , inMemberCount            := tmp.Count_Member
                                                           , inDayCount               := tmp.Count_Day
                                                           , inWorkTimeHoursOne       := tmp.SheetWorkTime_Amount
                                                           , inWorkTimeHours          := tmp.SUM_MemberHours
                                                           , inPrice                  := tmp.Price
                                                           , inGrossOne               := tmp.GrossOnOneMember
                                                           , inKoeff                  := tmp.KoeffHoursWork_car
                                                           , inSession                := inSession
                                                            )
       FROM _tmpReport AS tmp; 
       */

       -- если НЕТ ошибок то записываем в MessagePersonalService ведомости по отчету, которые обработаны
       PERFORM gpInsertUpdate_Object_MessagePersonalService(ioId                    := 0                          ::Integer,       -- ключ объекта
                                                            inCode                  := inSessionCode              ::Integer,       -- № Сессии            
                                                            inName                  := 'Без ошибок'               ::TVarChar,      -- Сообщение об ошибке 
                                                            inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer,       --                    
                                                            inMemberId              := NULL                       ::Integer,       --                    
                                                            inComment               := 'Выполнено'                ::TVarChar,      -- Примечание         
                                                            inSession               := inSession                  ::TVarChar
                                                            )
       FROM (SELECT DISTINCT _tmpReport.PersonalServiceListId FROM _tmpReport) AS tmp; 
                    
     END IF;
         
    outPersonalServiceDate := CURRENT_TIMESTAMP;

    --if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService); end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.02.25         *
*/

-- тест
--select * from  gpInsertUpdate_MI_PersonalService_Child_byUnit_mes( inSessionCode := 1 ::Integer, inUnitId := 8449 ::Integer, inisPersonalService:= TRUE ::Boolean, inSession := '6561986' ::TVarChar)