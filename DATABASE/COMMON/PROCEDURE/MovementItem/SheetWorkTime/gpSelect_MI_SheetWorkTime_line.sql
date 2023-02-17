-- Function: gpSelect_MI_SheetWorkTime_line()


DROP FUNCTION IF EXISTS gpSelect_MI_SheetWorkTime_line(TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_SheetWorkTime_line(
    IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inIsErased    Boolean   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (
             MemberId            Integer
           , MemberCode          Integer
           , MemberName          TVarChar
           , PositionId          Integer
           , PositionName        TVarChar
           , PositionLevelId     Integer
           , PositionLevelName   TVarChar
           , PersonalGroupId     Integer
           , PersonalGroupName   TVarChar
           , StorageLineId       Integer
           , StorageLineName     TVarChar
           , WorkTimeKindId_key  Integer
           , WorkTimeKindName_key TVarChar
           , DateOut             TDateTime
 --???      --isErased

           , AmountHours   TFLoat
           , CountDay      TFloat
           , Amount_3      TFloat
           , Amount_4      TFloat
           , Amount_5      TFloat
           , Amount_6      TFloat 
           , PersonalId    Integer
           
           , WorkTimeKindId_1    Integer 
           , WorkTimeKindId_2    Integer 
           , WorkTimeKindId_3    Integer 
           , WorkTimeKindId_4    Integer 
           , WorkTimeKindId_5    Integer 
           , WorkTimeKindId_6    Integer 
           , WorkTimeKindId_7    Integer 
           , WorkTimeKindId_8    Integer 
           , WorkTimeKindId_9    Integer 
           , WorkTimeKindId_10   Integer 
           , WorkTimeKindId_11   Integer 
           , WorkTimeKindId_12   Integer 
           , WorkTimeKindId_13   Integer 
           , WorkTimeKindId_14   Integer 
           , WorkTimeKindId_15   Integer 
           , WorkTimeKindId_16   Integer 
           , WorkTimeKindId_17   Integer 
           , WorkTimeKindId_18   Integer 
           , WorkTimeKindId_19   Integer 
           , WorkTimeKindId_20   Integer 
           , WorkTimeKindId_21   Integer 
           , WorkTimeKindId_22   Integer 
           , WorkTimeKindId_23   Integer 
           , WorkTimeKindId_24   Integer 
           , WorkTimeKindId_25   Integer 
           , WorkTimeKindId_26   Integer 
           , WorkTimeKindId_27   Integer 
           , WorkTimeKindId_28   Integer 
           , WorkTimeKindId_29   Integer 
           , WorkTimeKindId_30   Integer 
           , WorkTimeKindId_31   Integer    

           , ShortName_1    TVarChar
           , ShortName_2    TVarChar
           , ShortName_3    TVarChar
           , ShortName_4    TVarChar
           , ShortName_5    TVarChar
           , ShortName_6    TVarChar
           , ShortName_7    TVarChar
           , ShortName_8    TVarChar
           , ShortName_9    TVarChar
           , ShortName_10   TVarChar
           , ShortName_11   TVarChar
           , ShortName_12   TVarChar
           , ShortName_13   TVarChar
           , ShortName_14   TVarChar
           , ShortName_15   TVarChar
           , ShortName_16   TVarChar
           , ShortName_17   TVarChar
           , ShortName_18   TVarChar
           , ShortName_19   TVarChar
           , ShortName_20   TVarChar
           , ShortName_21   TVarChar
           , ShortName_22   TVarChar
           , ShortName_23   TVarChar
           , ShortName_24   TVarChar
           , ShortName_25   TVarChar
           , ShortName_26   TVarChar
           , ShortName_27   TVarChar
           , ShortName_28   TVarChar
           , ShortName_29   TVarChar
           , ShortName_30   TVarChar
           , ShortName_31   TVarChar
           
           , Color_Calc_1   Integer
           , Color_Calc_2   Integer
           , Color_Calc_3   Integer
           , Color_Calc_4   Integer
           , Color_Calc_5   Integer
           , Color_Calc_6   Integer
           , Color_Calc_7   Integer
           , Color_Calc_8   Integer
           , Color_Calc_9   Integer
           , Color_Calc_10  Integer
           , Color_Calc_11  Integer
           , Color_Calc_12  Integer
           , Color_Calc_13  Integer
           , Color_Calc_14  Integer
           , Color_Calc_15  Integer
           , Color_Calc_16  Integer
           , Color_Calc_17  Integer
           , Color_Calc_18  Integer
           , Color_Calc_19  Integer
           , Color_Calc_20  Integer
           , Color_Calc_21  Integer
           , Color_Calc_22  Integer
           , Color_Calc_23  Integer
           , Color_Calc_24  Integer
           , Color_Calc_25  Integer
           , Color_Calc_26  Integer
           , Color_Calc_27  Integer
           , Color_Calc_28  Integer
           , Color_Calc_29  Integer
           , Color_Calc_30  Integer
           , Color_Calc_31  Integer
           )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     vbStartDate := DATE_TRUNC ('MONTH', inDate);
     vbEndDate   := DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
     
     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        
        SELECT tt.*
             , CASE WHEN tmpCalendar.isHoliday = TRUE THEN zc_Color_GreenL()
                    WHEN tmpCalendar.Working = FALSE THEN zc_Color_Yelow()
                    ELSE zc_Color_White()
               END AS Color_Calc
        FROM (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate) AS tt
         LEFT JOIN gpSelect_Object_Calendar (vbStartDate, vbEndDate, inSession) AS tmpCalendar ON tmpCalendar.Value = tt.OperDate
        ;

     -- Сотрудники тек.подразделения
     CREATE TEMP TABLE tmpListPersonal ON COMMIT DROP AS 
        SELECT *
        FROM (SELECT Object_Personal_View.*
                   , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.UnitId, Object_Personal_View.MemberId, Object_Personal_View.PositionId, Object_Personal_View.PositionLevelId
                                        ORDER BY CASE WHEN Object_Personal_View.isErased = TRUE THEN 1 ELSE 0 END ASC
                                        ) AS Ord_find
              FROM Object_Personal_View
              WHERE Object_Personal_View.UnitId = inUnitId
             ) AS tmp
        WHERE tmp.Ord_find = 1
        ;


     -- уволенные сотрудники в период табеля
     CREATE TEMP TABLE tmpListOut ON COMMIT DROP AS 
        SELECT Object_Personal_View.MemberId
             , MAX (Object_Personal_View.PersonalId) AS PersonalId
             , Object_Personal_View.PositionId
             , MAX (CASE WHEN Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate 
                              THEN Object_Personal_View.DateIn
                         ELSE zc_DateStart()
                    END)  AS DateIn
             , MAX (Object_Personal_View.DateOut) AS DateOut
        FROM Object_Personal_View
        WHERE ((Object_Personal_View.DateOut >= vbStartDate AND Object_Personal_View.DateOut <= vbEndDate)
            OR (Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate)
            OR 1=1
              )
          AND Object_Personal_View.UnitId = inUnitId
        GROUP BY Object_Personal_View.MemberId
             --, Object_Personal_View.PersonalId
               , Object_Personal_View.PositionId
                ;

     CREATE TEMP TABLE tmpDateOut_All ON COMMIT DROP AS
       /* WITH
        -- сотрудники дата приема , увольнения
        tmpList AS (SELECT Object_Personal_View.MemberId
                         , Object_Personal_View.PersonalId
                         , Object_Personal_View.PositionId
                         , Object_Personal_View.DateIn
                         , Object_Personal_View.DateOut
                    FROM Object_Personal_View
                    WHERE ((Object_Personal_View.DateOut >= vbStartDate AND Object_Personal_View.DateOut <= vbEndDate)
                        OR (Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate))
                      AND Object_Personal_View.UnitId = inUnitId
             -- and MemberId IN (3119489, 4507324)
                   )   */
        --
        SELECT tmpList.MemberId
           --, tmpList.PersonalId
             , tmpList.PositionId
             , tmpOperDate.OperDate
             , 12918                                         AS WorkTimeKindId 
             , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
        FROM tmpOperDate
             LEFT JOIN tmpListOut AS tmpList
                                  ON tmpList.DateOut < tmpOperDate.OperDate
                                  OR tmpList.DateIn  > tmpOperDate.OperDate
             LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                    ON ObjectString_WorkTimeKind_ShortName.ObjectId = 12918 --  уволен  Х
                                   AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
        
        ;

/*

Отпуск	        0	0/O	розовый        -- 16492285  "zc_Enum_WorkTimeKind_Holiday"
Больничный	0	Б	красный            -- 5329407   "zc_Enum_WorkTimeKind_Hospital"
Прогул	        0	П	темно синий    -- 16744448  "zc_Enum_WorkTimeKind_Skip"
Стажер50%	50	0/С5O%	желтый         -- 10223615  "zc_Enum_WorkTimeKind_Trainee50"
пробная смена	0	0/б_о	желтый     -- 8454143   "zc_Enum_WorkTimeKind_Trial"
Отпуск без сохр.ЗП	0	О б/с	зеленый-- 2405712   "zc_Enum_WorkTimeKind_HolidayNoZp"
Больничный с документом	0	Б/Д	красный-- 5329407   "zc_Enum_WorkTimeKind_HospitalDoc"
день 12ч	0	0/Д	голубой            -- 16777128  "zc_Enum_WorkTimeKind_WorkD"
ночь 12ч	0	0/Н	серый              -- 15395562  "zc_Enum_WorkTimeKind_WorkN"
Командировка	0	К	салатовый      -- 4128302   "zc_Enum_WorkTimeKind_Trip"
Удаленый Доступ	0	УД	оранжевый      -- 4760831   "zc_Enum_WorkTimeKind_RemoteAccess"
Ревизия	        0	РЗ	бирюза         -- 14417001  "zc_Enum_WorkTimeKind_Audit"
Санобработка	0	/СД	темный желтый  -- 254953    "zc_Enum_WorkTimeKind_Medicday"
Инвентаризация	0	/ИВ	 бирюза        -- 16776969  "zc_Enum_WorkTimeKind_Medicday"

*/
     -- все данные за месяц
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            WITH
    tmpMovement_all_all AS (SELECT tmpOperDate.OperDate
                               --, CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE MI_SheetWorkTime.Amount END AS Amount
                                 , MI_SheetWorkTime.Amount
                                 , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                 , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                 , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                 , COALESCE (ObjectBoolean_NoSheetCalc.ValueData, FALSE) ::Boolean AS isNoSheetCalc
                                 , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                 , COALESCE(MIObject_StorageLine.ObjectId, 0)    AS StorageLineId
                                 , CASE WHEN inUnitId = 8451
                                             THEN CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE COALESCE (MIObject_WorkTimeKind.ObjectId, 0) END
                                        ELSE 0
                                   END AS WorkTimeKindId_key

                                 , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS ObjectId
                                 , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                                 , CASE WHEN MI_SheetWorkTime.isErased = TRUE THEN 0 ELSE 1 END AS isErased
                                 , CASE 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Holiday()      THEN 16492285
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Hospital()     THEN 5329407
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip()         THEN 16744448
                                        WHEN /*MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Trainee50()*/
                                             ObjectFloat_WorkTimeKind_Tax.ValueData <> 0                          THEN 10223615   -- если стажер тогда у него % не равен нулю
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Trial()        THEN 8454143 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_HolidayNoZp()  THEN 2405712 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_HospitalDoc()  THEN 5329407 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_WorkD()        THEN 16777128
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_WorkN()        THEN 15395562
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Trip()         THEN 4128302 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_RemoteAccess() THEN 4760831 
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Audit()        THEN 14417001
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Medicday()     THEN 254953  
                                        WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Inventory()    THEN 16776969

                                        WHEN tmpCalendar.isHoliday = TRUE THEN zc_Color_GreenL()
                                        WHEN tmpCalendar.Working = FALSE THEN zc_Color_Yelow()
                                        --WHEN ObjectFloat_WorkTimeKind_Tax.ValueData > 0 AND COALESCE (MI_SheetWorkTime.Amount, 0) <> 0 AND MIObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_Quit()
                                        --     THEN zc_Color_GreenL()
                                        --WHEN COALESCE (MI_SheetWorkTime.Amount, 0) <> 0 AND MIObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_Quit()
                                        --     THEN 13816530 -- светло серый  15395562
                                        ELSE tmpOperDate.Color_Calc
                                   END AS Color_Calc
                                   --  выходн дни - желтым фоном + праздничные - зеленым, определяется в zc_Object_Calendar
                            FROM tmpOperDate
                                 JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                              AND Movement.DescId = zc_Movement_SheetWorkTime()
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                      AND (MI_SheetWorkTime.isErased = FALSE OR inIsErased = TRUE)
                                 LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                                  ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                  ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                  ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                  ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_WorkTimeKind_Tax
                                                       ON ObjectFloat_WorkTimeKind_Tax.ObjectId = CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                                      AND ObjectFloat_WorkTimeKind_Tax.DescId = zc_ObjectFloat_WorkTimeKind_Tax()
                                 LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                                                  ON ObjectString_WorkTimeKind_ShortName.ObjectId = CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                                                 AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                  ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetCalc
                                                         ON ObjectBoolean_NoSheetCalc.ObjectId = COALESCE(MIObject_PositionLevel.ObjectId, 0)
                                                        AND ObjectBoolean_NoSheetCalc.DescId = zc_ObjectBoolean_PositionLevel_NoSheetCalc()

                                 LEFT JOIN gpSelect_Object_Calendar (vbStartDate, vbEndDate, inSession) AS tmpCalendar ON tmpCalendar.Value = tmpOperDate.OperDate
                            WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                              AND (MI_SheetWorkTime.Amount <> 0
                                OR inUnitId <> 8451
                                OR MIObject_WorkTimeKind.ObjectId NOT IN (zc_Enum_WorkTimeKind_Work()
                                                                        , zc_Enum_WorkTimeKind_WorkD(), 8302788
                                                                        , zc_Enum_WorkTimeKind_WorkN(), 8302790
                                                                         )
                                  )
                           )

     , tmpMovement_all AS (SELECT tmpMovement_all_all.OperDate
                                 , SUM (tmpMovement_all_all.Amount)              AS Amount
                                 , COUNT(*)                                      AS Count_sm
                               --, 1                                             AS Count_sm
                                 , tmpMovement_all_all.MemberId
                                 , tmpMovement_all_all.PositionId
                                 , tmpMovement_all_all.PositionLevelId
                                 , tmpMovement_all_all.isNoSheetCalc
                                 , tmpMovement_all_all.PersonalGroupId
                                 , tmpMovement_all_all.StorageLineId
                                 , tmpMovement_all_all.WorkTimeKindId_key

                                 , tmpMovement_all_all.ObjectId
                                 , tmpMovement_all_all.ShortName
                                 , tmpMovement_all_all.isErased
                                 , tmpMovement_all_all.Color_Calc
                           FROM tmpMovement_all_all
                           GROUP BY tmpMovement_all_all.OperDate
                                 , tmpMovement_all_all.MemberId
                                 , tmpMovement_all_all.PositionId
                                 , tmpMovement_all_all.PositionLevelId
                                 , tmpMovement_all_all.isNoSheetCalc
                                 , tmpMovement_all_all.PersonalGroupId
                                 , tmpMovement_all_all.StorageLineId
                                 , tmpMovement_all_all.WorkTimeKindId_key

                                 , tmpMovement_all_all.ObjectId
                                 , tmpMovement_all_all.ShortName
                                 , tmpMovement_all_all.isErased
                                 , tmpMovement_all_all.Color_Calc
                          )
          , tmpMovement AS (SELECT tmpMovement_all.OperDate
                               --, CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE MI_SheetWorkTime.Amount END AS Amount
                                 , tmpMovement_all.Amount
                                 , tmpMovement_all.Count_sm
                                 , tmpMovement_all.MemberId
                                 , tmpMovement_all.PositionId
                                 , tmpMovement_all.PositionLevelId
                                 , tmpMovement_all.isNoSheetCalc
                                 , tmpMovement_all.PersonalGroupId
                                 , tmpMovement_all.StorageLineId
                                 , CASE -- если в этом дне есть день и НЕТ ночь
                                        WHEN tmpMovement_all_n.WorkTimeKindId_key IS NULL
                                         AND tmpMovement_all_d.WorkTimeKindId_key IS NOT NULL
                                             THEN 2237043 -- ночь 12ч
                                        -- если в этом дне есть ночь и НЕТ день
                                        WHEN tmpMovement_all_n.WorkTimeKindId_key IS NOT NULL
                                         AND tmpMovement_all_d.WorkTimeKindId_key IS NULL
                                             THEN 2237042 -- день 12ч
                                        ELSE tmpMovement_all.WorkTimeKindId_key
                                   END AS WorkTimeKindId_key

                                 , tmpMovement_all.ObjectId
                                 , tmpMovement_all.ShortName
                                 , tmpMovement_all.isErased
                                 , tmpMovement_all.Color_Calc AS Color_Calc
                                   --  выходн дни - желтым фоном + праздничные - зеленым, определяется в zc_Object_Calendar
                            FROM tmpMovement_all
                                 -- если в этот день заполнены день 12ч
                                 LEFT JOIN tmpMovement_all AS tmpMovement_all_d
                                                           ON inUnitId = 8451
                                                          AND tmpMovement_all_d.WorkTimeKindId_key = 2237042 -- день 12ч
                                                          AND tmpMovement_all_d.OperDate           = tmpMovement_all.OperDate
                                                          AND tmpMovement_all_d.MemberId           = tmpMovement_all.MemberId
                                                          AND tmpMovement_all_d.PositionId         = tmpMovement_all.PositionId
                                                          AND tmpMovement_all_d.PositionLevelId    = tmpMovement_all.PositionLevelId
                                                          AND tmpMovement_all_d.PersonalGroupId    = tmpMovement_all.PersonalGroupId
                                                          AND tmpMovement_all_d.StorageLineId      = tmpMovement_all.StorageLineId
                                                          AND tmpMovement_all_d.Amount             > 0
                                                          AND tmpMovement_all.WorkTimeKindId_key NOT IN (2237042, 2237043)
                                 -- если в этот день заполнены ночь 12ч
                                 LEFT JOIN tmpMovement_all AS tmpMovement_all_n
                                                           ON inUnitId = 8451
                                                          AND tmpMovement_all_n.WorkTimeKindId_key = 2237043 -- ночь 12ч
                                                          AND tmpMovement_all_n.OperDate           = tmpMovement_all.OperDate
                                                          AND tmpMovement_all_n.MemberId           = tmpMovement_all.MemberId
                                                          AND tmpMovement_all_n.PositionId         = tmpMovement_all.PositionId
                                                          AND tmpMovement_all_n.PositionLevelId    = tmpMovement_all.PositionLevelId
                                                          AND tmpMovement_all_n.PersonalGroupId    = tmpMovement_all.PersonalGroupId
                                                          AND tmpMovement_all_n.StorageLineId      = tmpMovement_all.StorageLineId
                                                          AND tmpMovement_all_n.Amount             > 0
                                                          AND tmpMovement_all.WorkTimeKindId_key NOT IN (2237042, 2237043)
                                 -- если за месяц заполнен хоть один день 12ч
                                 LEFT JOIN (SELECT DISTINCT tmpMovement_all.MemberId
                                                          , tmpMovement_all.PositionId
                                                          , tmpMovement_all.PositionLevelId
                                                          , tmpMovement_all.PersonalGroupId
                                                          , tmpMovement_all.StorageLineId
                                                          , tmpMovement_all.WorkTimeKindId_key
                                            FROM tmpMovement_all
                                            WHERE inUnitId = 8451
                                              AND tmpMovement_all.WorkTimeKindId_key = 2237042 -- день 12ч
                                              AND tmpMovement_all.Amount             > 0
                                           ) AS tmpMovement_all_d_all
                                             ON inUnitId = 8451
                                            AND tmpMovement_all_d_all.MemberId           = tmpMovement_all.MemberId
                                            AND tmpMovement_all_d_all.PositionId         = tmpMovement_all.PositionId
                                            AND tmpMovement_all_d_all.PositionLevelId    = tmpMovement_all.PositionLevelId
                                            AND tmpMovement_all_d_all.PersonalGroupId    = tmpMovement_all.PersonalGroupId
                                            AND tmpMovement_all_d_all.StorageLineId      = tmpMovement_all.StorageLineId
                                            AND tmpMovement_all.WorkTimeKindId_key NOT IN (2237042, 2237043)
                                 -- если за месяц заполнен хоть один ночь 12ч
                                 LEFT JOIN (SELECT DISTINCT tmpMovement_all.MemberId
                                                          , tmpMovement_all.PositionId
                                                          , tmpMovement_all.PositionLevelId
                                                          , tmpMovement_all.PersonalGroupId
                                                          , tmpMovement_all.StorageLineId
                                                          , tmpMovement_all.WorkTimeKindId_key
                                            FROM tmpMovement_all
                                            WHERE inUnitId = 8451
                                              AND tmpMovement_all.WorkTimeKindId_key = 2237043 -- ночь 12ч
                                              AND tmpMovement_all.Amount             > 0
                                           ) AS tmpMovement_all_n_all
                                             ON inUnitId = 8451
                                            AND tmpMovement_all_n_all.MemberId           = tmpMovement_all.MemberId
                                            AND tmpMovement_all_n_all.PositionId         = tmpMovement_all.PositionId
                                            AND tmpMovement_all_n_all.PositionLevelId    = tmpMovement_all.PositionLevelId
                                            AND tmpMovement_all_n_all.PersonalGroupId    = tmpMovement_all.PersonalGroupId
                                            AND tmpMovement_all_n_all.StorageLineId      = tmpMovement_all.StorageLineId
                                            AND tmpMovement_all.WorkTimeKindId_key NOT IN (2237042, 2237043)
                            WHERE (tmpMovement_all.WorkTimeKindId_key > 0 OR inUnitId <> 8451 OR tmpMovement_all.Amount > 0)
                           )
            -- связываем даты до приема, после увольнения с текущими
          , tmpDateOut AS (SELECT tmpDateOut_All.OperDate
                                , tmpDateOut_All.MemberId
                                , tmpDateOut_All.PositionId
                                , tmpMI.PositionLevelId
                                , tmpMI.PersonalGroupId
                                , tmpMI.StorageLineId
                                , zc_Color_White() AS Color_Calc
                                , tmpDateOut_All.WorkTimeKindId
                                , tmpDateOut_All.ShortName
                           FROM tmpDateOut_All
                                INNER JOIN (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId , tmpMI.StorageLineId
                                            FROM tmpMovement AS tmpMI
                                           ) AS tmpMI ON tmpMI.MemberId   = tmpDateOut_All.MemberId
                                                     AND tmpMI.PositionId = tmpDateOut_All.PositionId
--                           WHERE 1=0
                           )
            -- объединяем даты увольнения и рабочие
            -- рабочий график
            SELECT tmp.OperDate
                 , tmp.Amount :: TFloat
                 , tmp.Count_sm :: TFloat
               --, CASE WHEN COALESCE (tmpDateOut.WorkTimeKindId, tmp.ObjectId) = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE tmp.Amount END :: TFloat AS Amount
                 , tmp.MemberId
                 , tmp.PositionId
                 , tmp.PositionLevelId
                 , tmp.isNoSheetCalc
                 , tmp.PersonalGroupId
                 , tmp.StorageLineId
                 , tmp.WorkTimeKindId_key
                 , COALESCE (tmpDateOut.WorkTimeKindId, tmp.ObjectId) AS ObjectId
                 , COALESCE (tmpDateOut.ShortName, tmp.ShortName)     AS ShortName
                 , tmp.isErased
                 , tmp.Color_Calc 
 
            FROM tmpMovement AS tmp
                 -- если был принят не сначала месяца или уволен в течении месяца отмечаем Х
                 LEFT JOIN tmpDateOut ON tmpDateOut.OperDate   = tmp.OperDate
                                     AND tmpDateOut.MemberId   = tmp.MemberId
                                     AND tmpDateOut.PositionId = tmp.PositionId
                                     AND tmp.Amount            = 0
          UNION
            -- дни увольнения (не рабочие)
            SELECT tmp.OperDate
                 , 0 :: TFloat AS Amount
                 , 0 :: TFloat AS Count_sm
                 , tmp.MemberId
                 , tmp.PositionId
                 , tmp.PositionLevelId
                 , FALSE AS isNoSheetCalc
                 , tmp.PersonalGroupId
                 , tmp.StorageLineId
                 , 0 :: Integer AS WorkTimeKindId_key
                 , tmp.WorkTimeKindId AS ObjectId
                 , tmp.ShortName
                 , 1 AS isErased
                 , tmp.Color_Calc   
            FROM tmpDateOut AS tmp
                 LEFT JOIN tmpMovement ON tmpMovement.OperDate   = tmp.OperDate
                                      AND tmpMovement.MemberId   = tmp.MemberId
                                      AND tmpMovement.PositionId = tmp.PositionId
                                      AND tmpMovement.Amount     > 0
            WHERE tmpMovement.MemberId IS NULL
           ;

     -- данные из штатного расписания
     CREATE TEMP TABLE tmpStaffList ON COMMIT DROP AS
            SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                 , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                 , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                 , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
            FROM Object AS Object_StaffList
                  INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                        ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                       AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
                  LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                       ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                      AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()

                  LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                       ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                      AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
 
                  LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                        ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                       AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
             WHERE Object_StaffList.DescId = zc_Object_StaffList()
               AND Object_StaffList.isErased = False
             GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                    , ObjectLink_StaffList_Position.ChildObjectId
                    , ObjectLink_StaffList_PositionLevel.ChildObjectId
             HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
             ;


     -- данные для итогов
     CREATE TEMP TABLE tmpTotal ON COMMIT DROP AS
     SELECT tmp.OperDate
           , tmp.MemberId
           , tmp.PositionId
           , tmp.PositionLevelId
           , tmp.PersonalGroupId
           , tmp.StorageLineId
           , tmp.WorkTimeKindId_key
           , SUM (tmp.Amount) ::TFLoat AS Amount
           , tmp.ObjectId
     FROM (--кол-во часов
      SELECT tmpOperDate.OperDate
           , tmpMI.MemberId
           , tmpMI.PositionId
           , tmpMI.PositionLevelId
           , tmpMI.PersonalGroupId
           , tmpMI.StorageLineId
           , tmpMI.WorkTimeKindId_key
           , SUM (tmpMI.Amount) AS Amount
           , 1  AS ObjectId
      FROM tmpOperDate
           JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                     AND COALESCE (tmpMI.Amount,0) <> 0
                     AND tmpMI.isNoSheetCalc = FALSE
                     AND tmpMI.isErased = 1
       Group by tmpOperDate.operdate
              , tmpMI.MemberId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.WorkTimeKindId_key
    UNION
      -- кол-во смен 
      SELECT tmpOperDate.OperDate
           , tmpMI.MemberId
           , tmpMI.PositionId
           , tmpMI.PositionLevelId
           , tmpMI.PersonalGroupId
           , tmpMI.StorageLineId
           , tmpMI.WorkTimeKindId_key
           , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN tmpMI.Count_sm ELSE 0 END) AS Amount
           , 2  AS ObjectId
      FROM tmpOperDate
          JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                    AND tmpMI.ObjectId NOT IN ( zc_Enum_WorkTimeKind_Quit(), zc_Enum_WorkTimeKind_DayOff())
                    AND tmpMI.isErased = 1
       GROUP BY tmpOperDate.OperDate
              , tmpMI.MemberId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.WorkTimeKindId_key
    UNION
      -- Кол-во шт.ед
      SELECT tmp.OperDate
           , tmp.MemberId
           , tmp.PositionId
           , tmp.PositionLevelId
           , tmp.PersonalGroupId
           , tmp.StorageLineId
           , tmp.WorkTimeKindId_key
           , SUM (tmp.Amount) AS Amount
           , 3  AS ObjectId
      FROM (SELECT tmpOperDate.OperDate
                 , tmpMI.MemberId
                 , tmpMI.PositionId
                 , tmpMI.PositionLevelId
                 , tmpMI.PersonalGroupId
                 , tmpMI.StorageLineId
                 , tmpMI.WorkTimeKindId_key
                 , CASE WHEN COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay) <> 0
                            THEN tmpMI.Amount / COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay)
                        ELSE 1
                   END AS Amount
             FROM tmpOperDate
                  JOIN tmpMI ON tmpMI.OperDate = tmpOperDate.OperDate
                            AND tmpMI.ObjectId NOT IN (zc_Enum_WorkTimeKind_Quit()
                                                     , zc_Enum_WorkTimeKind_DayOff()
                                                     , zc_Enum_WorkTimeKind_Holiday()
                                                     , zc_Enum_WorkTimeKind_Hospital()
                                                     , zc_Enum_WorkTimeKind_HolidayNoZp()
                                                     , zc_Enum_WorkTimeKind_HospitalDoc()
                                                    )
                            AND tmpMI.isNoSheetCalc = FALSE
                            AND COALESCE (tmpMI.Amount,0) <> 0
                            AND tmpMI.isErased = 1
                  -- данные из штатного расписания
                  LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpMI.PositionId
                                        AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                        AND tmpStaffList.UnitId     = inUnitId
                  --второй раз без подразделения
                  LEFT JOIN tmpStaffList AS tmpStaffList2
                                         ON tmpStaffList2.PositionId = tmpMI.PositionId
                                        AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpMI.PositionLevelId,0)
                                        AND tmpStaffList.PositionId IS NULL
             ) AS tmp
      GROUP BY tmp.OperDate
             , tmp.MemberId
             , tmp.PositionId
             , tmp.PositionLevelId
             , tmp.PersonalGroupId
             , tmp.StorageLineId
             , tmp.WorkTimeKindId_key
    UNION
      -- Кол-во БЛ
      SELECT tmpOperDate.OperDate
           , tmpMI.MemberId
           , tmpMI.PositionId
           , tmpMI.PositionLevelId
           , tmpMI.PersonalGroupId
           , tmpMI.StorageLineId
           , tmpMI.WorkTimeKindId_key
           , SUM (1) AS Amount
           , 4  AS ObjectId
      FROM tmpOperDate
          JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                    AND tmpMI.ObjectId IN ( zc_Enum_WorkTimeKind_Hospital(), zc_Enum_WorkTimeKind_HospitalDoc())
                    AND tmpMI.isErased = 1
       Group by tmpOperDate.OperDate
              , tmpMI.MemberId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.WorkTimeKindId_key
    UNION
      -- Кол-во отпуска
      SELECT tmpOperDate.OperDate
           , tmpMI.MemberId
           , tmpMI.PositionId
           , tmpMI.PositionLevelId
           , tmpMI.PersonalGroupId
           , tmpMI.StorageLineId
           , tmpMI.WorkTimeKindId_key
           , SUM (1) AS Amount
           , 5  AS ObjectId
      FROM tmpOperDate
          JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                    AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Holiday()
                    -- AND COALESCE (tmpMI.Amount,0) <> 0
                    AND tmpMI.isErased = 1
       Group by tmpOperDate.OperDate
              , tmpMI.MemberId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.WorkTimeKindId_key
    UNION
      -- Кол-во прогулов
      SELECT tmpOperDate.OperDate
           , tmpMI.MemberId
           , tmpMI.PositionId
           , tmpMI.PositionLevelId
           , tmpMI.PersonalGroupId
           , tmpMI.StorageLineId
           , tmpMI.WorkTimeKindId_key
           , SUM (1) AS Amount
           , 6  AS ObjectId
      FROM tmpOperDate
          JOIN tmpMI ON tmpMI.operDate = tmpOperDate.OperDate
                    AND tmpMI.ObjectId = zc_Enum_WorkTimeKind_Skip()
                   -- AND COALESCE (tmpMI.Amount,0) <> 0
                   AND tmpMI.isErased = 1
       Group by tmpOperDate.OperDate
              , tmpMI.MemberId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.WorkTimeKindId_key
)AS tmp
       Group by tmp.OperDate
              , tmp.MemberId
              , tmp.PositionId
              , tmp.PositionLevelId
              , tmp.PersonalGroupId
              , tmp.StorageLineId
              , tmp.WorkTimeKindId_key
              , tmp.ObjectId
      ;
      ----------------------------------------------------------------
     RETURN QUERY

     WITH
     -- добавляем всех сорудников и увольнение
     tmpMIAll AS (
     SELECT COALESCE (Movement_Data.MemberId, Object_Data.MemberId)                AS MemberId
          , COALESCE (Movement_Data.PositionId, Object_Data.PositionId)            AS PositionId
          , COALESCE (Movement_Data.PositionLevelId, Object_Data.PositionLevelId)  AS PositionLevelId
          , COALESCE (Movement_Data.PersonalGroupId, Object_Data.PersonalGroupId)  AS PersonalGroupId
          , COALESCE (Movement_Data.StorageLineId, Object_Data.StorageLineId)      AS StorageLineId
          , COALESCE (Movement_Data.WorkTimeKindId_key, 0)                         AS WorkTimeKindId_key
                                            
          , COALESCE (Movement_Data.OperDate, Object_Data.OperDate)                AS OperDate
          , (zfCalc_ViewWorkHour (COALESCE(Movement_Data.Amount, 0), COALESCE (Movement_Data.ShortName, ObjectString_WorkTimeKind_ShortName.ValueData))) :: VarChar AS ShortName
          , COALESCE (Movement_Data.ObjectId,  COALESCE (tmpDateOut_All.WorkTimeKindId, 0)) AS WorkTimeKindId
          , COALESCE (Movement_Data.Color_Calc, Object_Data.Color_Calc)            AS Color_Calc

     FROM (WITH
           tmpAll AS (SELECT tmp.MemberId, tmp.PositionId, tmp.PositionLevelId, tmp.PersonalGroupId, tmp.StorageLineId, tmp.WorkTimeKindId_key
                           , tmpOperDate.OperDate
                      FROM (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key FROM tmpMI) AS tmp
                           LEFT JOIN tmpOperDate ON 1=1
                     )               
          SELECT tmpAll.MemberId
               , tmpAll.PositionId
               , tmpAll.PositionLevelId
               , tmpAll.PersonalGroupId
               , tmpAll.StorageLineId
               , tmpAll.WorkTimeKindId_key
               , tmpAll.OperDate
               , tmpMI.Amount, tmpMI.ShortName
               , COALESCE (tmpMI.ObjectId, 0) AS ObjectId
               , COALESCE (tmpMI.Color_Calc, zc_Color_White()) AS Color_Calc
          FROM tmpAll
               LEFT JOIN tmpMI ON tmpMI.OperDate           = tmpAll.OperDate
                              AND tmpMI.MemberId           = tmpAll.MemberId
                              AND tmpMI.PositionId         = tmpAll.PositionId
                              AND tmpMI.PositionLevelId    = tmpAll.PositionLevelId
                              AND tmpMI.PersonalGroupId    = tmpAll.PersonalGroupId
                              AND tmpMI.StorageLineId      = tmpAll.StorageLineId
                              AND tmpMI.WorkTimeKindId_key = tmpAll.WorkTimeKindId_key
                              AND (tmpMI.isErased = 1 OR inIsErased = TRUE)
          ) AS Movement_Data
        FULL JOIN
         (SELECT tmpOperDate.OperDate,
                 COALESCE(Object_Personal_View.MemberId, 0)                   AS MemberId,
                 COALESCE(ObjectLink_Personal_Position.ChildObjectId, 0)      AS PositionId,
                 COALESCE(ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId,
                 COALESCE(ObjectLink_Personal_PersonalGroup.ChildObjectId, 0) AS PersonalGroupId,
                 COALESCE(Object_Personal_View.StorageLineId, 0)              AS StorageLineId,
                 tmpOperDate.Color_Calc
            FROM tmpOperDate, Object_Personal_View -- ON 1=1 -- inUnitId <> 8451 -- кроме УПАКОВКИ
                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                      ON ObjectLink_Personal_Position.ObjectId = Object_Personal_View.PersonalId
                                     AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                      ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal_View.PersonalId
                                     AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                      ON ObjectLink_Personal_Unit.ObjectId = Object_Personal_View.PersonalId
                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                      ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal_View.PersonalId
                                     AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
            WHERE Object_Personal_View.isErased = FALSE
              AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId
         ) AS Object_Data
           ON Object_Data.OperDate = Movement_Data.OperDate
          AND Object_Data.MemberId = Movement_Data.MemberId
          AND Object_Data.PositionId = Movement_Data.PositionId
          AND Object_Data.PositionLevelId = Movement_Data.PositionLevelId
          AND Object_Data.PersonalGroupId = Movement_Data.PersonalGroupId
          AND Object_Data.StorageLineId = Movement_Data.StorageLineId

        LEFT JOIN tmpDateOut_All ON tmpDateOut_All.OperDate           = Object_Data.OperDate
                                AND tmpDateOut_All.MemberId           = Object_Data.MemberId
                                AND tmpDateOut_All.PositionId         = Object_Data.PositionId
                                AND COALESCE(Movement_Data.Amount, 0) = 0
        LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                               ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpDateOut_All.WorkTimeKindId
                              AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
     )      
     
     --группируем даты в колонки
   , tmpMI_Group AS (
           SELECT
                 tmp.MemberId
               , tmp.PositionId
               , tmp.PositionLevelId
               , tmp.PersonalGroupId
               , tmp.StorageLineId
               --, tmp.Count_sm
               , tmp.WorkTimeKindId_key --??????

               , MAX (tmp.WorkTimeKindId_1) AS WorkTimeKindId_1
               , MAX (tmp.WorkTimeKindId_2) AS WorkTimeKindId_2
               , MAX (tmp.WorkTimeKindId_3) AS WorkTimeKindId_3
               , MAX (tmp.WorkTimeKindId_4) AS WorkTimeKindId_4
               , MAX (tmp.WorkTimeKindId_5) AS WorkTimeKindId_5
               , MAX (tmp.WorkTimeKindId_6) AS WorkTimeKindId_6
               , MAX (tmp.WorkTimeKindId_7) AS WorkTimeKindId_7
               , MAX (tmp.WorkTimeKindId_8) AS WorkTimeKindId_8
               , MAX (tmp.WorkTimeKindId_9) AS WorkTimeKindId_9
               , MAX (tmp.WorkTimeKindId_10) AS WorkTimeKindId_10
               , MAX (tmp.WorkTimeKindId_11) AS WorkTimeKindId_11
               , MAX (tmp.WorkTimeKindId_12) AS WorkTimeKindId_12
               , MAX (tmp.WorkTimeKindId_13) AS WorkTimeKindId_13
               , MAX (tmp.WorkTimeKindId_14) AS WorkTimeKindId_14
               , MAX (tmp.WorkTimeKindId_15) AS WorkTimeKindId_15
               , MAX (tmp.WorkTimeKindId_16) AS WorkTimeKindId_16
               , MAX (tmp.WorkTimeKindId_17) AS WorkTimeKindId_17
               , MAX (tmp.WorkTimeKindId_18) AS WorkTimeKindId_18
               , MAX (tmp.WorkTimeKindId_19) AS WorkTimeKindId_19
               , MAX (tmp.WorkTimeKindId_20) AS WorkTimeKindId_20
               , MAX (tmp.WorkTimeKindId_21) AS WorkTimeKindId_21
               , MAX (tmp.WorkTimeKindId_22) AS WorkTimeKindId_22
               , MAX (tmp.WorkTimeKindId_23) AS WorkTimeKindId_23
               , MAX (tmp.WorkTimeKindId_24) AS WorkTimeKindId_24
               , MAX (tmp.WorkTimeKindId_25) AS WorkTimeKindId_25
               , MAX (tmp.WorkTimeKindId_26) AS WorkTimeKindId_26
               , MAX (tmp.WorkTimeKindId_27) AS WorkTimeKindId_27
               , MAX (tmp.WorkTimeKindId_28) AS WorkTimeKindId_28
               , MAX (tmp.WorkTimeKindId_29) AS WorkTimeKindId_29
               , MAX (tmp.WorkTimeKindId_30) AS WorkTimeKindId_30
               , MAX (tmp.WorkTimeKindId_31) AS WorkTimeKindId_31   

               , MAX (tmp.ShortName_1 ) AS ShortName_1
               , MAX (tmp.ShortName_2 ) AS ShortName_2
               , MAX (tmp.ShortName_3 ) AS ShortName_3
               , MAX (tmp.ShortName_4 ) AS ShortName_4
               , MAX (tmp.ShortName_5 ) AS ShortName_5
               , MAX (tmp.ShortName_6 ) AS ShortName_6
               , MAX (tmp.ShortName_7 ) AS ShortName_7
               , MAX (tmp.ShortName_8 ) AS ShortName_8
               , MAX (tmp.ShortName_9 ) AS ShortName_9
               , MAX (tmp.ShortName_10) AS ShortName_10
               , MAX (tmp.ShortName_11) AS ShortName_11
               , MAX (tmp.ShortName_12) AS ShortName_12
               , MAX (tmp.ShortName_13) AS ShortName_13
               , MAX (tmp.ShortName_14) AS ShortName_14
               , MAX (tmp.ShortName_15) AS ShortName_15
               , MAX (tmp.ShortName_16) AS ShortName_16
               , MAX (tmp.ShortName_17) AS ShortName_17
               , MAX (tmp.ShortName_18) AS ShortName_18
               , MAX (tmp.ShortName_19) AS ShortName_19
               , MAX (tmp.ShortName_20) AS ShortName_20
               , MAX (tmp.ShortName_21) AS ShortName_21
               , MAX (tmp.ShortName_22) AS ShortName_22
               , MAX (tmp.ShortName_23) AS ShortName_23
               , MAX (tmp.ShortName_24) AS ShortName_24
               , MAX (tmp.ShortName_25) AS ShortName_25
               , MAX (tmp.ShortName_26) AS ShortName_26
               , MAX (tmp.ShortName_27) AS ShortName_27
               , MAX (tmp.ShortName_28) AS ShortName_28
               , MAX (tmp.ShortName_29) AS ShortName_29
               , MAX (tmp.ShortName_30) AS ShortName_30
               , MAX (tmp.ShortName_31) AS ShortName_31
               
               , MAX (tmp.Color_Calc_1 ) AS Color_Calc_1
               , MAX (tmp.Color_Calc_2 ) AS Color_Calc_2
               , MAX (tmp.Color_Calc_3 ) AS Color_Calc_3
               , MAX (tmp.Color_Calc_4 ) AS Color_Calc_4
               , MAX (tmp.Color_Calc_5 ) AS Color_Calc_5
               , MAX (tmp.Color_Calc_6 ) AS Color_Calc_6
               , MAX (tmp.Color_Calc_7 ) AS Color_Calc_7
               , MAX (tmp.Color_Calc_8 ) AS Color_Calc_8
               , MAX (tmp.Color_Calc_9 ) AS Color_Calc_9
               , MAX (tmp.Color_Calc_10) AS Color_Calc_10
               , MAX (tmp.Color_Calc_11) AS Color_Calc_11
               , MAX (tmp.Color_Calc_12) AS Color_Calc_12
               , MAX (tmp.Color_Calc_13) AS Color_Calc_13
               , MAX (tmp.Color_Calc_14) AS Color_Calc_14
               , MAX (tmp.Color_Calc_15) AS Color_Calc_15
               , MAX (tmp.Color_Calc_16) AS Color_Calc_16
               , MAX (tmp.Color_Calc_17) AS Color_Calc_17
               , MAX (tmp.Color_Calc_18) AS Color_Calc_18
               , MAX (tmp.Color_Calc_19) AS Color_Calc_19
               , MAX (tmp.Color_Calc_20) AS Color_Calc_20
               , MAX (tmp.Color_Calc_21) AS Color_Calc_21
               , MAX (tmp.Color_Calc_22) AS Color_Calc_22
               , MAX (tmp.Color_Calc_23) AS Color_Calc_23
               , MAX (tmp.Color_Calc_24) AS Color_Calc_24
               , MAX (tmp.Color_Calc_25) AS Color_Calc_25
               , MAX (tmp.Color_Calc_26) AS Color_Calc_26
               , MAX (tmp.Color_Calc_27) AS Color_Calc_27
               , MAX (tmp.Color_Calc_28) AS Color_Calc_28
               , MAX (tmp.Color_Calc_29) AS Color_Calc_29
               , MAX (tmp.Color_Calc_30) AS Color_Calc_30
               , MAX (tmp.Color_Calc_31) AS Color_Calc_31
           FROM (
             SELECT
                   tmpMI.MemberId
                 , tmpMI.PositionId
                 , tmpMI.PositionLevelId
                 , tmpMI.PersonalGroupId
                 , tmpMI.StorageLineId
                 --, tmpMI.Count_sm
                 , tmpMI.WorkTimeKindId_key

                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 1  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_1
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 2  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_2
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 3  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_3
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 4  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_4
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 5  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_5
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 6  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_6
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 7  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_7
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 8  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_8
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 9  THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_9
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 10 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_10
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 11 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_11
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 12 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_12
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 13 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_13
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 14 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_14
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 15 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_15
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 16 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_16
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 17 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_17
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 18 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_18
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 19 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_19
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 20 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_20
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 21 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_21
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 22 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_22
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 23 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_23
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 24 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_24
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 25 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_25
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 26 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_26
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 27 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_27
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 28 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_28
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 29 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_29
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 30 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_30
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 31 THEN tmpMI.WorkTimeKindId ELSE 0 END  :: Integer AS WorkTimeKindId_31   
              

                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 1  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_1
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 2  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_2
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 3  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_3
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 4  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_4
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 5  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_5
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 6  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_6
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 7  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_7
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 8  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_8
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 9  THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_9
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 10 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_10
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 11 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_11
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 12 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_12
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 13 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_13
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 14 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_14
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 15 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_15
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 16 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_16
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 17 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_17
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 18 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_18
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 19 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_19
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 20 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_20
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 21 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_21
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 22 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_22
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 23 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_23
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 24 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_24
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 25 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_25
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 26 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_26
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 27 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_27
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 28 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_28
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 29 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_29
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 30 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_30
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 31 THEN tmpMI.ShortName ELSE '' END  :: TVarChar AS ShortName_31
                 
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 1  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_1
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 2  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_2
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 3  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_3
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 4  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_4
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 5  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_5
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 6  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_6
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 7  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_7
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 8  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_8
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 9  THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_9
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 10 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_10
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 11 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_11
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 12 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_12
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 13 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_13
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 14 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_14
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 15 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_15
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 16 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_16
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 17 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_17
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 18 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_18
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 19 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_19
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 20 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_20
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 21 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_21
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 22 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_22
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 23 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_23
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 24 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_24
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 25 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_25
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 26 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_26
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 27 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_27
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 28 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_28
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 29 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_29
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 30 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_30
                 , CASE WHEN EXTRACT (Day FROM tmpMI.OperDate)::integer = 31 THEN tmpMI.Color_Calc ELSE 0 END  :: Integer AS Color_Calc_31
  
             FROM tmpMIAll AS tmpMI
             ) AS tmp
             GROUP BY tmp.MemberId
                    , tmp.PositionId
                    , tmp.PositionLevelId
                    , tmp.PersonalGroupId
                    , tmp.StorageLineId
                   -- , tmp.Count_sm
                    , tmp.WorkTimeKindId_key
             )

     
      SELECT Object_Member.Id                    AS MemberId
           , Object_Member.ObjectCode            AS MemberCode
           , Object_Member.ValueData             AS MemberName
           , Object_Position.Id                  AS PositionId
           , Object_Position.ValueData           AS PositionName
           , Object_PositionLevel.Id             AS PositionLevelId
           , Object_PositionLevel.ValueData      AS PositionLevelName
           , Object_PersonalGroup.Id             AS PersonalGroupId
           , Object_PersonalGroup.ValueData      AS PersonalGroupName
           , Object_StorageLine.Id               AS StorageLineId
           , Object_StorageLine.ValueData        AS StorageLineName
           , Object_WorkTimeKind_key.Id          AS WorkTimeKindId_key
           , Object_WorkTimeKind_key.ValueData   AS WorkTimeKindName_key
           , CASE WHEN COALESCE (tmpListOut.DateOut, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE tmpListOut.DateOut END ::TDateTime AS DateOut
 --???      --, CASE WHEN tmp.isErased = 0 THEN TRUE ELSE FALSE END AS isErased

           , tmp.Amount        ::TFLoat AS AmountHours
           , tmp.CountDay      ::TFloat
           , tmpTotal.Amount_3 ::TFloat
           , tmpTotal.Amount_4 ::TFloat
           , tmpTotal.Amount_5 ::TFloat
           , tmpTotal.Amount_6 ::TFloat 
           , tmpListPersonal.PersonalId
           
           , D.WorkTimeKindId_1    :: Integer 
           , D.WorkTimeKindId_2    :: Integer 
           , D.WorkTimeKindId_3    :: Integer 
           , D.WorkTimeKindId_4    :: Integer 
           , D.WorkTimeKindId_5    :: Integer 
           , D.WorkTimeKindId_6    :: Integer 
           , D.WorkTimeKindId_7    :: Integer 
           , D.WorkTimeKindId_8    :: Integer 
           , D.WorkTimeKindId_9    :: Integer 
           , D.WorkTimeKindId_10   :: Integer 
           , D.WorkTimeKindId_11   :: Integer 
           , D.WorkTimeKindId_12   :: Integer 
           , D.WorkTimeKindId_13   :: Integer 
           , D.WorkTimeKindId_14   :: Integer 
           , D.WorkTimeKindId_15   :: Integer 
           , D.WorkTimeKindId_16   :: Integer 
           , D.WorkTimeKindId_17   :: Integer 
           , D.WorkTimeKindId_18   :: Integer 
           , D.WorkTimeKindId_19   :: Integer 
           , D.WorkTimeKindId_20   :: Integer 
           , D.WorkTimeKindId_21   :: Integer 
           , D.WorkTimeKindId_22   :: Integer 
           , D.WorkTimeKindId_23   :: Integer 
           , D.WorkTimeKindId_24   :: Integer 
           , D.WorkTimeKindId_25   :: Integer 
           , D.WorkTimeKindId_26   :: Integer 
           , D.WorkTimeKindId_27   :: Integer 
           , D.WorkTimeKindId_28   :: Integer 
           , D.WorkTimeKindId_29   :: Integer 
           , D.WorkTimeKindId_30   :: Integer 
           , D.WorkTimeKindId_31   :: Integer    

           , D.ShortName_1   :: TVarChar
           , D.ShortName_2   :: TVarChar
           , D.ShortName_3   :: TVarChar
           , D.ShortName_4   :: TVarChar
           , D.ShortName_5   :: TVarChar
           , D.ShortName_6   :: TVarChar
           , D.ShortName_7   :: TVarChar
           , D.ShortName_8   :: TVarChar
           , D.ShortName_9   :: TVarChar
           , D.ShortName_10  :: TVarChar
           , D.ShortName_11  :: TVarChar
           , D.ShortName_12  :: TVarChar
           , D.ShortName_13  :: TVarChar
           , D.ShortName_14  :: TVarChar
           , D.ShortName_15  :: TVarChar
           , D.ShortName_16  :: TVarChar
           , D.ShortName_17  :: TVarChar
           , D.ShortName_18  :: TVarChar
           , D.ShortName_19  :: TVarChar
           , D.ShortName_20  :: TVarChar
           , D.ShortName_21  :: TVarChar
           , D.ShortName_22  :: TVarChar
           , D.ShortName_23  :: TVarChar
           , D.ShortName_24  :: TVarChar
           , D.ShortName_25  :: TVarChar
           , D.ShortName_26  :: TVarChar
           , D.ShortName_27  :: TVarChar
           , D.ShortName_28  :: TVarChar
           , D.ShortName_29  :: TVarChar
           , D.ShortName_30  :: TVarChar
           , D.ShortName_31  :: TVarChar
           
           , D.Color_Calc_1  :: Integer
           , D.Color_Calc_2  :: Integer
           , D.Color_Calc_3  :: Integer
           , D.Color_Calc_4  :: Integer
           , D.Color_Calc_5  :: Integer
           , D.Color_Calc_6  :: Integer
           , D.Color_Calc_7  :: Integer
           , D.Color_Calc_8  :: Integer
           , D.Color_Calc_9  :: Integer
           , D.Color_Calc_10 :: Integer
           , D.Color_Calc_11 :: Integer
           , D.Color_Calc_12 :: Integer
           , D.Color_Calc_13 :: Integer
           , D.Color_Calc_14 :: Integer
           , D.Color_Calc_15 :: Integer
           , D.Color_Calc_16 :: Integer
           , D.Color_Calc_17 :: Integer
           , D.Color_Calc_18 :: Integer
           , D.Color_Calc_19 :: Integer
           , D.Color_Calc_20 :: Integer
           , D.Color_Calc_21 :: Integer
           , D.Color_Calc_22 :: Integer
           , D.Color_Calc_23 :: Integer
           , D.Color_Calc_24 :: Integer
           , D.Color_Calc_25 :: Integer
           , D.Color_Calc_26 :: Integer
           , D.Color_Calc_27 :: Integer
           , D.Color_Calc_28 :: Integer
           , D.Color_Calc_29 :: Integer
           , D.Color_Calc_30 :: Integer
           , D.Color_Calc_31 :: Integer
          

      FROM tmpMI_Group AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.MemberId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.PositionLevelId
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.PersonalGroupId
         LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = D.StorageLineId
         LEFT JOIN Object AS Object_WorkTimeKind_key ON Object_WorkTimeKind_key.Id = D.WorkTimeKindId_key

         LEFT JOIN (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key, tmpMI.isErased
                         , Sum (tmpMI.Amount) AS Amount
                         , Sum (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN tmpMI.Count_sm ELSE 0 END) AS CountDay 
                    FROM tmpMI
                    WHERE tmpMI.isErased = 1 OR inIsErased = TRUE
                    GROUP BY tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.isErased, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key
                   ) AS tmp ON tmp.MemberId                        = D.MemberId
                           AND COALESCE(tmp.PositionId, 0)         = D.PositionId
                           AND COALESCE(tmp.PositionLevelId, 0)    = D.PositionLevelId
                           AND COALESCE(tmp.PersonalGroupId, 0)    = D.PersonalGroupId
                           AND COALESCE(tmp.StorageLineId, 0)      = D.StorageLineId
                           AND COALESCE(tmp.WorkTimeKindId_key, 0) = D.WorkTimeKindId_key
         LEFT JOIN (SELECT tmpTotal.MemberId
                         , tmpTotal.PositionId
                         , tmpTotal.PositionLevelId
                         , tmpTotal.PersonalGroupId
                         , tmpTotal.StorageLineId
                         , tmpTotal.WorkTimeKindId_key
                         , SUM (CASE WHEN tmpTotal.ObjectId = 3 THEN tmpTotal.Amount ELSE 0 END) AS Amount_3
                         , SUM (CASE WHEN tmpTotal.ObjectId = 4 THEN tmpTotal.Amount ELSE 0 END) AS Amount_4
                         , SUM (CASE WHEN tmpTotal.ObjectId = 5 THEN tmpTotal.Amount ELSE 0 END) AS Amount_5
                         , SUM (CASE WHEN tmpTotal.ObjectId = 6 THEN tmpTotal.Amount ELSE 0 END) AS Amount_6
                    FROM tmpTotal
                    GROUP BY tmpTotal.MemberId
                           , tmpTotal.PositionId
                           , tmpTotal.PositionLevelId
                           , tmpTotal.PersonalGroupId
                           , tmpTotal.StorageLineId
                           , tmpTotal.WorkTimeKindId_key
                    ) AS tmpTotal ON tmpTotal.MemberId                        = D.MemberId
                                 AND COALESCE(tmpTotal.PositionId, 0)         = D.PositionId
                                 AND COALESCE(tmpTotal.PositionLevelId, 0)    = D.PositionLevelId
                                 AND COALESCE(tmpTotal.PersonalGroupId, 0)    = D.PersonalGroupId
                                 AND COALESCE(tmpTotal.StorageLineId, 0)      = D.StorageLineId
                                 AND COALESCE(tmpTotal.WorkTimeKindId_key, 0) = D.WorkTimeKindId_key   
         --возьмем отсюда дату увольнения
         LEFT JOIN tmpListOut ON COALESCE(tmpListOut.PositionId, 0) = D.PositionId
                             AND COALESCE(tmpListOut.MemberId, 0)   = D.MemberId
         --получить Id сотрудника
         LEFT JOIN tmpListPersonal ON tmpListPersonal.MemberId                     = D.MemberId
                                  AND COALESCE(tmpListPersonal.PositionId, 0)      = D.PositionId
                                  AND COALESCE(tmpListPersonal.PositionLevelId, 0) = D.PositionLevelId
                                  AND COALESCE(tmpListPersonal.PersonalGroupId, 0) = D.PersonalGroupId
                                  AND COALESCE(tmpListPersonal.StorageLineId, 0)   = D.StorageLineId

      ORDER BY Object_Member.ValueData
               , Object_Position.ValueData
               , Object_PositionLevel.ValueData
               , Object_PersonalGroup.ValueData
               , Object_StorageLine.ValueData
        ;

 
 
 /*
        SELECT tmp.ValueData    AS Name
             , tmp.TotalAmount ::TFloat
        '
               || vbFieldNameText ||
        '
        FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[Movement_Data.ObjectId        -- AS MemberId
                                                ] :: Integer[]
                                         , Movement_Data.OperDate AS OperDate
                                         , ARRAY[ CAST (COALESCE(Movement_Data.Amount, 0)  AS NUMERIC (16,0)) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId, zc_Enum_WorkTimeKind_Work()) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT tmpTotal.operdate
                                               , tmpTotal.ObjectId
                                               , SUM (tmpTotal.Amount) AS Amount
                                          FROM tmpTotal
                                          Group by tmpTotal.operdate, tmpTotal.ObjectId
                                        ) AS Movement_Data
                                  order by 1''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
      FULL JOIN (SELECT 1 AS Id, ''1.кол-во часов''    AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 1) :: TFloat AS TotalAmount
           UNION SELECT 2 AS Id, ''2.кол-во смен''     AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 2) :: TFloat AS TotalAmount
           UNION SELECT 3 AS Id, ''3.Кол-во шт.ед''    AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 3) :: TFloat AS TotalAmount
           UNION SELECT 4 AS Id, ''4.Кол-во БЛ''       AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 4) :: TFloat AS TotalAmount
           UNION SELECT 5 AS Id, ''5.Кол-во отпуска''  AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 5) :: TFloat AS TotalAmount
           UNION SELECT 6 AS Id, ''6.Кол-во прогулов'' AS ValueData, (SELECT SUM (tmpTotal.Amount) FROM tmpTotal WHERE tmpTotal.ObjectId = 6) :: TFloat AS TotalAmount
                 )AS tmp ON tmp.Id = D.MemberId  
     ORDER BY tmp.Id
         ';
     OPEN cur2 FOR EXECUTE vbQueryText;
     RETURN NEXT cur2;

     -- 1)кол-во часов 2)кол-во смен 3)Кол-во шт.ед 4)Кол-во отпуска 5)Кол-во прогулов
     OPEN cur3 FOR EXECUTE vbQueryText2; 
     RETURN NEXT cur3;
     
*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.02.23         *
*/


-- тест
-- select * from gpSelect_MI_SheetWorkTime_line (inDate := ('01.07.2022')::TDateTime , inUnitId := 8425 , inisErased := 'False' ,  inSession := '9457');