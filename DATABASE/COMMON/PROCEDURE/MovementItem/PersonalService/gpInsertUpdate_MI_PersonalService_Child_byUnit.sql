-- Function: gpInsertUpdate_MI_PersonalService_Child_byUnit()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_byUnit(
    --IN inStartDate            TDateTime , -- дата
    --IN inEndDate              TDateTime , -- дата 
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

     -- тест 3а 11,2022, дата док.01,12,2022
     --vbStartDate := '01.12.2022';
     --vbEndDate   := '30.12.2022';

     
     -- расчет за прошлый месяц
     vbStartDate := DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime);
     vbEndDate   := DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 DAY')::TDateTime); 
     
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
                                    , inDetailModelService           := FALSE  ::Boolean   --детализировать по моделям
                                    , inDetailModelServiceItemMaster := FALSE  ::Boolean   --детализировать по типам документов в модели
                                    , inDetailModelServiceItemChild  := FALSE  ::Boolean   --детализировать по товарам в типах документов
                                    , inSession        := inSession   ::TVarChar
                                    ) tmp;

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
       FROM  _tmpReport AS tmp;  
                                        
    outPersonalServiceDate := CURRENT_TIMESTAMP;

    if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok.'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

*/

-- тест
--