-- Function: gpSelect_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_SheetWorkTime(TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SheetWorkTime(
    IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inIsErased    Boolean   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor;
          cur2 refcursor;
          cur3 refcursor;
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbQueryText2 Text;
          vbFieldNameText Text;
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
             , COALESCE (Object_Personal_View.PositionLevelId,0) AS PositionLevelId
             , MAX (CASE WHEN Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate
                              THEN Object_Personal_View.DateIn
                         ELSE zc_DateStart()
                    END)  AS DateIn
             , CASE WHEN MAX (COALESCE (Object_Personal_View.DateOut_user, zc_DateStart())) = zc_DateStart()
                         THEN zc_DateEnd()
                    ELSE MAX (COALESCE (Object_Personal_View.DateOut_user, zc_DateStart()))
               END :: TDateTime AS DateOut
        FROM Object_Personal_View
        WHERE ((Object_Personal_View.DateOut >= vbStartDate AND Object_Personal_View.DateOut <= vbEndDate)
            OR (Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate)
            OR 1=1
              )
          AND Object_Personal_View.UnitId = inUnitId
        GROUP BY Object_Personal_View.MemberId
             --, Object_Personal_View.PersonalId
               , Object_Personal_View.PositionId
               , COALESCE (Object_Personal_View.PositionLevelId,0)
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
             , tmpList.PositionLevelId
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
Больничный	0	Б	красный        -- 5329407   "zc_Enum_WorkTimeKind_Hospital"
Прогул	        0	П	темно синий    -- 16744448  "zc_Enum_WorkTimeKind_Skip"
Стажер50%	50	0/С5O%	желтый         -- 10223615  "zc_Enum_WorkTimeKind_Trainee50"
пробная смена	0	0/б_о	желтый         -- 8454143   "zc_Enum_WorkTimeKind_Trial"
Отпуск без сохр.ЗП	0	О б/с	зеленый-- 2405712   "zc_Enum_WorkTimeKind_HolidayNoZp"
Больничный с документом	0	Б/Д	красный-- 5329407   "zc_Enum_WorkTimeKind_HospitalDoc"
день 12ч	0	0/Д	голубой        -- 16777128  "zc_Enum_WorkTimeKind_WorkD"
ночь 12ч	0	0/Н	серый          -- 15395562  "zc_Enum_WorkTimeKind_WorkN"
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
                                 , CASE WHEN inUnitId = 8451 -- ЦЕХ пакування
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
                                OR inUnitId <> 8451 -- ЦЕХ пакування
                                OR MIObject_WorkTimeKind.ObjectId NOT IN (zc_Enum_WorkTimeKind_Work()
                                                                        , zc_Enum_WorkTimeKind_WorkD(), 8302788
                                                                        , zc_Enum_WorkTimeKind_WorkN(), 8302790
                                                                         )
                                  )

-- AND (MI_SheetWorkTime.Id = 242132333 or vbUserId <> 5)
-- limit case when vbUserId = 5 then 1 else 30000 end
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

                                        -- если за месяц есть день + в этом дне НЕТ день
                                      /*WHEN tmpMovement_all_d_all.WorkTimeKindId_key IS NOT NULL
                                         AND tmpMovement_all_d.WorkTimeKindId_key IS NULL
                                             THEN 2237042 -- день 12ч

                                        -- если за месяц есть ночь + в этом дне НЕТ ночь
                                        WHEN tmpMovement_all_n_all.WorkTimeKindId_key IS NOT NULL
                                         AND tmpMovement_all_n.WorkTimeKindId_key IS NULL
                                             THEN 2237043 -- ночь 12ч
*/
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
                                                           ON inUnitId = 8451 -- ЦЕХ пакування
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
                                                           ON inUnitId = 8451 -- ЦЕХ пакування
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
                                            WHERE inUnitId = 8451 -- ЦЕХ пакування
                                              AND tmpMovement_all.WorkTimeKindId_key = 2237042 -- день 12ч
                                              AND tmpMovement_all.Amount             > 0
                                           ) AS tmpMovement_all_d_all
                                             ON inUnitId = 8451 -- ЦЕХ пакування
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
                                            WHERE inUnitId = 8451 -- ЦЕХ пакування
                                              AND tmpMovement_all.WorkTimeKindId_key = 2237043 -- ночь 12ч
                                              AND tmpMovement_all.Amount             > 0
                                           ) AS tmpMovement_all_n_all
                                             ON inUnitId = 8451 -- ЦЕХ пакування
                                            AND tmpMovement_all_n_all.MemberId           = tmpMovement_all.MemberId
                                            AND tmpMovement_all_n_all.PositionId         = tmpMovement_all.PositionId
                                            AND tmpMovement_all_n_all.PositionLevelId    = tmpMovement_all.PositionLevelId
                                            AND tmpMovement_all_n_all.PersonalGroupId    = tmpMovement_all.PersonalGroupId
                                            AND tmpMovement_all_n_all.StorageLineId      = tmpMovement_all.StorageLineId
                                            AND tmpMovement_all.WorkTimeKindId_key NOT IN (2237042, 2237043)
                            -- ЦЕХ пакування
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
                                INNER JOIN (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, PositionLevelId, PersonalGroupId , StorageLineId
                                            FROM tmpMovement AS tmpMI
                                           ) AS tmpMI ON tmpMI.MemberId   = tmpDateOut_All.MemberId
                                                     AND tmpMI.PositionId = tmpDateOut_All.PositionId
                                                     AND tmpMI.PositionLevelId = tmpDateOut_All.PositionLevelId
                                LEFT JOIN (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, tmpMI.OperDate
                                           FROM tmpMovement AS tmpMI
                                           WHERE tmpMI.ObjectId IN (zc_Enum_WorkTimeKind_Holiday())
                                          ) AS tmpMI_check ON tmpMI_check.MemberId   = tmpDateOut_All.MemberId
                                                          AND tmpMI_check.PositionId = tmpDateOut_All.PositionId
                                                          AND tmpMI_check.OperDate   = tmpDateOut_All.OperDate
                           WHERE tmpMI_check.OperDate IS NULL

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
                                     AND tmpDateOut.PositionLevelId = tmp.PositionLevelId
                                     AND tmp.Amount            = 0
                                     AND tmp.ObjectId NOT IN (zc_Enum_WorkTimeKind_Holiday())
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
                                      AND tmpMovement.PositionLevelId = tmp.PositionLevelId
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

     vbIndex := 0;
     -- именно так, из-за перехода времени кол-во дней может быть разное
     vbDayCount := (SELECT COUNT(*) FROM tmpOperDate);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]';
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1]::VarChar AS Value' || vbIndex ||'  '||
                                             ', DAY' || vbIndex || '[2]::Integer AS TypeId' || vbIndex ||' '||
                                             ', DAY' || vbIndex || '[3]::Integer AS Color_Calc' || vbIndex ||' ';
     END LOOP;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;


     vbQueryText := '
        SELECT Object_Member.Id                      AS MemberId
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
               , CASE WHEN COALESCE (tmpListOut.DateOut, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE tmpListOut.DateOut END AS DateOut

               , CASE WHEN tmp.isErased = 0 THEN TRUE ELSE FALSE END AS isErased

              -- , CASE WHEN COALESCE (tmp.Amount, 0) <> 0 THEN zc_Color_Red() ELSE 0 END AS Color_Calc1
               , tmp.Amount                      AS AmountHours
               , tmp.CountDay::TFloat
               , tmpTotal.Amount_3 ::TFloat
               , tmpTotal.Amount_4 ::TFloat
               , tmpTotal.Amount_5 ::TFloat
               , tmpTotal.Amount_6 ::TFloat
               , tmpListPersonal.PersonalId
                 '
               || vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.MemberId, Object_Data.MemberId)                     -- AS MemberId
                                               , COALESCE (Movement_Data.PositionId, Object_Data.PositionId)                 -- AS PositionId
                                               , COALESCE (Movement_Data.PositionLevelId, Object_Data.PositionLevelId)       -- AS PositionLevelId
                                               , COALESCE (Movement_Data.PersonalGroupId, Object_Data.PersonalGroupId)       -- AS PersonalGroupId
                                               , COALESCE (Movement_Data.StorageLineId, Object_Data.StorageLineId)           -- AS PositionLevelId
                                               , COALESCE (Movement_Data.WorkTimeKindId_key, 0)                              -- AS WorkTimeKindId_key
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.OperDate, Object_Data.OperDate) AS OperDate
                                         , ARRAY[(zfCalc_ViewWorkHour (COALESCE(Movement_Data.Amount, 0), COALESCE (Movement_Data.ShortName, ObjectString_WorkTimeKind_ShortName.ValueData))) :: VarChar
                                               , COALESCE (Movement_Data.ObjectId,  COALESCE (tmpDateOut_All.WorkTimeKindId, 0)) :: VarChar
                                               , COALESCE (Movement_Data.Color_Calc, Object_Data.Color_Calc) :: VarChar
                                                ] :: TVarChar
                                    FROM (WITH tmpAll AS (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key
                                                               , tmpOperDate.OperDate
                                                          FROM (SELECT DISTINCT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key FROM tmpMI) AS tmpMI
                                                               CROSS JOIN tmpOperDate
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
                                                              AND (tmpMI.isErased = 1 OR ' || inIsErased :: TVarChar || ' = TRUE)
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
                                              -- кроме УПАКОВКИ
--                                              AND inUnitId <> 8451
                                              --
                                              AND ObjectLink_Personal_Unit.ChildObjectId = ' || inUnitId :: TVarChar ||
                                        ') AS Object_Data
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
                                                                AND COALESCE (Movement_Data.ObjectId, 0) NOT IN (zc_Enum_WorkTimeKind_Holiday())
                                        LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                                               ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpDateOut_All.WorkTimeKindId
                                                              AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                                  ORDER BY 1''
                                , '' SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = D.Key[1]
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = D.Key[2]
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = D.Key[3]
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = D.Key[4]
         LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = D.Key[5]
         LEFT JOIN Object AS Object_WorkTimeKind_key ON Object_WorkTimeKind_key.Id = D.Key[6]
         LEFT JOIN (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key, tmpMI.isErased
                         , Sum (tmpMI.Amount) AS Amount
                         , Sum (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN tmpMI.Count_sm ELSE 0 END) AS CountDay
                    FROM tmpMI
                    WHERE tmpMI.isErased = 1 OR ' || inIsErased :: TVarChar || ' = TRUE
                    GROUP BY tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.isErased, tmpMI.StorageLineId, tmpMI.WorkTimeKindId_key
                   ) AS tmp ON tmp.MemberId                        = D.Key[1]
                           AND COALESCE(tmp.PositionId, 0)         = D.Key[2]
                           AND COALESCE(tmp.PositionLevelId, 0)    = D.Key[3]
                           AND COALESCE(tmp.PersonalGroupId, 0)    = D.Key[4]
                           AND COALESCE(tmp.StorageLineId, 0)      = D.Key[5]
                           AND COALESCE(tmp.WorkTimeKindId_key, 0) = D.Key[6]
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
                    ) AS tmpTotal ON tmpTotal.MemberId                        = D.Key[1]
                                 AND COALESCE(tmpTotal.PositionId, 0)         = D.Key[2]
                                 AND COALESCE(tmpTotal.PositionLevelId, 0)    = D.Key[3]
                                 AND COALESCE(tmpTotal.PersonalGroupId, 0)    = D.Key[4]
                                 AND COALESCE(tmpTotal.StorageLineId, 0)      = D.Key[5]
                                 AND COALESCE(tmpTotal.WorkTimeKindId_key, 0) = D.Key[6]
         --возьмем отсюда дату увольнения
         LEFT JOIN tmpListOut ON COALESCE(tmpListOut.MemberId, 0)           = D.Key[1]
                             AND COALESCE(tmpListOut.PositionId, 0)         = D.Key[2]
                             AND COALESCE(tmpListOut.PositionLevelId, 0)    = D.Key[3]
         --получить Id сотрудника
         LEFT JOIN tmpListPersonal ON tmpListPersonal.MemberId        = D.Key[1]
                                  AND COALESCE(tmpListPersonal.PositionId, 0)      = D.Key[2]
                                  AND COALESCE(tmpListPersonal.PositionLevelId, 0) = D.Key[3]
                                  AND COALESCE(tmpListPersonal.PersonalGroupId, 0) = D.Key[4]
                                  AND COALESCE(tmpListPersonal.StorageLineId, 0)   = D.Key[5]

        '
      /*ORDER BY Object_Member.ValueData
               , Object_Position.ValueData
               , Object_PositionLevel.ValueData
               , Object_PersonalGroup.ValueData
               , Object_StorageLine.ValueData*/
        ;

     vbQueryText2 := '
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
                 )AS tmp ON tmp.Id = D.Key[1]
     ORDER BY tmp.Id
         ';
     OPEN cur2 FOR EXECUTE vbQueryText;
     RETURN NEXT cur2;

     -- 1)кол-во часов 2)кол-во смен 3)Кол-во шт.ед 4)Кол-во отпуска 5)Кол-во прогулов
     OPEN cur3 FOR EXECUTE vbQueryText2;
     RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.21         *
 23.01.20         *
 25.05.17         * StorageLineId
 25.03.16         * AmountHours
 20.01.16         *
 07.01.14                         * Replace inPersonalId <> inMemberId
 30.11.13                                        * add isErased = FALSE
 30.11.13                                        * parse
 25.11.13                         * Add PositionLevelId
 25.10.13                         *
 19.10.13                         *
 05.10.13                         *
*/

/*
update  MovementItem set ObjectId = a.PersonalId
from (
select  MI_SheetWorkTime.Id, Object_Personal_View .PersonalId
from Movement
     JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
     left JOIN Object ON Object.Id = MI_SheetWorkTime.ObjectId
     left JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
     left JOIN Object_Personal_View  on Object_Personal_View .MemberId = MI_SheetWorkTime.ObjectId
where Movement.DescId = zc_Movement_SheetWorkTime()
) as a
where a.Id = MovementItem.Id
*/

-- тест
--  SELECT * FROM Object_Personal_View where Personalid in (5364831 , 7475074)
-- SELECT * FROM gpSelect_MovementItem_SheetWorkTime (inDate := NOW(), inUnitId:= 8465, inIsErased:= FALSE, inSession:= '5'); -- FETCH ALL "<unnamed portal 3>";
