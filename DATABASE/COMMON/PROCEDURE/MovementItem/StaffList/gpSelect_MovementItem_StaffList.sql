 -- Function: gpSelect_MovementItem_StaffList (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_StaffList (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_StaffList (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_StaffList(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , PositionId           Integer
             , PositionCode         Integer
             , PositionName         TVarChar
             , PositionLevelId      Integer
             , PositionLevelName    TVarChar
             , StaffPaidKindId      Integer
             , StaffPaidKindName    TVarChar
             , StaffHoursDayId      Integer
             , StaffHoursDayName    TVarChar
             , StaffHoursId         Integer
             , StaffHoursName       TVarChar
             , StaffHoursLengthId   Integer
             , StaffHoursLengthName Integer
             , PersonalId           Integer
             , PersonalName         TVarChar
             , Amount               TFloat
             , AmountReport         TFloat
             , StaffCount_1         TFloat
             , StaffCount_2         TFloat
             , StaffCount_3         TFloat
             , StaffCount_4         TFloat
             , StaffCount_5         TFloat
             , StaffCount_6         TFloat
             , StaffCount_7         TFloat
             , StaffCount_Invent    TFloat
             , Staff_Price          TFloat
             , Staff_Summ_MK        TFloat
             , Staff_Summ_MK3       TFloat
             , Staff_Summ_MK6       TFloat
             , Staff_Summ_real      TFloat
             , Staff_Summ_add       TFloat
             , Staff_Summ_total_real TFloat
             , Staff_Summ_total_add  TFloat
             , Comment              TVarChar
             , isErased             Boolean
             --
             , TotalStaffCount  TFloat          --Всього змін за місяць для посади (кол.понед * StaffCount_1 + кол вт * StaffCount_2 и т.д.)
             , TotalStaffHoursLength  TFloat    --ФРЧ (фонд робочого часу) для посади   TotalStaffCount * StaffHoursLength
             , NormCount        TFloat          --Норма змін для 1-єї шт.од   TotalStaffCount / StaffHoursLength
             , NormHours        TFloat          --Норма часу для 1-єї шт.од   TotalStaffHoursLength / StaffHoursLength
             , WageFund         TFloat          --ФОП за місяць (формула)    Staff_Price *  TotalStaffCount +Staff_Summ_MK +(Staff_Summ_MK3 /3)  +(Staff_Summ_MK6 /6)+ Staff_Summ_real	+ Staff_Summ_add
             , WageFund_byOne   TFloat          --ЗП для 1-єї шт.од до оподаткуання   WageFund / AmountReport

            /*
             --расчет ЗП для 1-єї шт.од (формули різні)
            , Summ_1  TFloat
            , Summ_2  TFloat
            , Summ_3  TFloat
            , Summ_4  TFloat
            , Summ_5  TFloat
            , Summ_6  TFloat
            , Summ_7  TFloat
            , Summ_8  TFloat
            , Summ_9  TFloat
            , SummZP_byOne    TFloat
            , SummControl_1   TFloat
            , SummControl_2   TFloat
            -- ФОП (формули різні)
            , Summ_10 TFloat
            , Summ_11 TFloat
            , Summ_12 TFloat
            , Summ_13 TFloat
            , Summ_14 TFloat
            , Summ_15 TFloat
            , Summ_16 TFloat
            , Summ_17 TFloat
            , Summ_18 TFloat
            , SummZP  TFloat
            , SummControl_3   TFloat
            , SummControl_4   TFloat 
            */
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate  TDateTime;
           vbStartDate TDateTime;
           vbEndDate   TDateTime;
           vbUnitId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_StaffList());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT DATE_TRUNC ('MONTH', Movement.OperDate)
          , DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
          , MovementLinkObject_Unit.ObjectId AS UnitId
    INTO vbStartDate, vbEndDate, vbUnitId
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
       WITH
            --кол. дней по дням недели
            tmpDay AS (WITH
                       tmpDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)

                       SELECT SUM (CASE WHEN tmpWeekDay.Number = 1 THEN 1 ELSE 0 END) AS Count_1
                            , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN 1 ELSE 0 END) AS Count_2
                            , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN 1 ELSE 0 END) AS Count_3
                            , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN 1 ELSE 0 END) AS Count_4
                            , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN 1 ELSE 0 END) AS Count_5
                            , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN 1 ELSE 0 END) AS Count_6
                            , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN 1 ELSE 0 END) AS Count_7
                       FROM tmpDate
                            LEFT JOIN zfCalc_DayOfWeekName (tmpDate.OperDate) AS tmpWeekDay ON 1=1
                       )
          , tmpStaffList_object AS (SELECT tmp.PositionId
                                          , tmp.PositionCode
                                          , tmp.PositionName
                                          , tmp.PositionLevelId
                                          , tmp.PositionLevelName
                                          , tmp.HoursPlan
                                          , tmp.HoursDay
                                          , tmp.PersonalCount
                                    FROM gpSelect_Object_StaffList(inUnitId := vbUnitId , inisShowAll := 'False' ,  inSession := inSession) AS tmp
                                    WHERE inShowAll = TRUE
                                      AND COALESCE (vbUnitId,0) <> 0
                                    )

          , tmpMI AS (SELECT MovementItem.*
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Master()
                        AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                     )

          , tmpMIFloat AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                              --AND MovementItemFloat.DescId IN zc_MIFloat_AmountReport()
                           )

          , tmpMILinkObject AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                               )

          , tmpMIString AS (SELECT MovementItemString.*
                            FROM MovementItemString
                            WHERE MovementItemString.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                              AND MovementItemString.DescId = zc_MIString_Comment()
                           )
          , tmpData AS (SELECT MovementItem.*
                             , MILinkObject_PositionLevel.ObjectId                        AS PositionLevelId
                             , COALESCE (MIFloat_AmountReport.ValueData, 0)      ::TFloat AS AmountReport
                             , COALESCE (MIFloat_StaffCount_1.ValueData, 0)      ::TFloat AS StaffCount_1
                             , COALESCE (MIFloat_StaffCount_2.ValueData, 0)      ::TFloat AS StaffCount_2
                             , COALESCE (MIFloat_StaffCount_3.ValueData, 0)      ::TFloat AS StaffCount_3
                             , COALESCE (MIFloat_StaffCount_4.ValueData, 0)      ::TFloat AS StaffCount_4
                             , COALESCE (MIFloat_StaffCount_5.ValueData, 0)      ::TFloat AS StaffCount_5
                             , COALESCE (MIFloat_StaffCount_6.ValueData, 0)      ::TFloat AS StaffCount_6
                             , COALESCE (MIFloat_StaffCount_7.ValueData, 0)      ::TFloat AS StaffCount_7
                             , COALESCE (MIFloat_StaffCount_Invent.ValueData, 0) ::TFloat AS StaffCount_Invent
                             , COALESCE (MIFloat_Staff_Price.ValueData, 0)       ::TFloat AS Staff_Price
                             , COALESCE (MIFloat_Staff_Summ_MK.ValueData, 0)     ::TFloat AS Staff_Summ_MK
                             , COALESCE (MIFloat_Staff_Summ_MK3.ValueData, 0)    ::TFloat AS Staff_Summ_MK3
                             , COALESCE (MIFloat_Staff_Summ_MK6.ValueData, 0)    ::TFloat AS Staff_Summ_MK6
                             , COALESCE (MIFloat_Staff_Summ_real.ValueData, 0)   ::TFloat AS Staff_Summ_real
                             , COALESCE (MIFloat_Staff_Summ_add.ValueData, 0)    ::TFloat AS Staff_Summ_add
                             , COALESCE (MIFloat_Staff_Summ_total_real.ValueData, 0)   ::TFloat AS Staff_Summ_total_real
                             , COALESCE (MIFloat_Staff_Summ_total_add.ValueData, 0)    ::TFloat AS Staff_Summ_total_add
                             --
                             --Всього змін за місяць для посади (кол.понед * StaffCount_1 + кол вт * StaffCount_2 и т.д.)
                             , (tmpDay.Count_1 * COALESCE (MIFloat_StaffCount_1.ValueData, 0)
                              + tmpDay.Count_2 * COALESCE (MIFloat_StaffCount_2.ValueData, 0)
                              + tmpDay.Count_3 * COALESCE (MIFloat_StaffCount_3.ValueData, 0)
                              + tmpDay.Count_4 * COALESCE (MIFloat_StaffCount_4.ValueData, 0)
                              + tmpDay.Count_5 * COALESCE (MIFloat_StaffCount_5.ValueData, 0)
                              + tmpDay.Count_6 * COALESCE (MIFloat_StaffCount_6.ValueData, 0)
                              + tmpDay.Count_7 * COALESCE (MIFloat_StaffCount_7.ValueData, 0)
                              + COALESCE (MIFloat_StaffCount_Invent.ValueData, 0) )           ::TFloat AS TotalStaffCount
                        FROM tmpMI AS MovementItem
                             LEFT JOIN tmpMIFloat AS MIFloat_AmountReport
                                                  ON MIFloat_AmountReport.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountReport.DescId = zc_MIFloat_AmountReport()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_1
                                                  ON MIFloat_StaffCount_1.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_1.DescId = zc_MIFloat_StaffCount_1()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_2
                                                  ON MIFloat_StaffCount_2.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_2.DescId = zc_MIFloat_StaffCount_2()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_3
                                                  ON MIFloat_StaffCount_3.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_3.DescId = zc_MIFloat_StaffCount_3()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_4
                                                  ON MIFloat_StaffCount_4.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_4.DescId = zc_MIFloat_StaffCount_4()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_5
                                                  ON MIFloat_StaffCount_5.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_5.DescId = zc_MIFloat_StaffCount_5()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_6
                                                  ON MIFloat_StaffCount_6.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_6.DescId = zc_MIFloat_StaffCount_6()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_7
                                                  ON MIFloat_StaffCount_7.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_7.DescId = zc_MIFloat_StaffCount_7()
                             LEFT JOIN tmpMIFloat AS MIFloat_StaffCount_Invent
                                                  ON MIFloat_StaffCount_Invent.MovementItemId = MovementItem.Id
                                                 AND MIFloat_StaffCount_Invent.DescId = zc_MIFloat_StaffCount_Invent()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Price
                                                  ON MIFloat_Staff_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Price.DescId = zc_MIFloat_Staff_Price()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK
                                                  ON MIFloat_Staff_Summ_MK.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_MK.DescId = zc_MIFloat_Staff_Summ_MK()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK3
                                                  ON MIFloat_Staff_Summ_MK3.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_MK3.DescId = zc_MIFloat_Staff_Summ_MK_3()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_MK6
                                                  ON MIFloat_Staff_Summ_MK6.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_MK6.DescId = zc_MIFloat_Staff_Summ_MK_6()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_real
                                                  ON MIFloat_Staff_Summ_real.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_real.DescId = zc_MIFloat_Staff_Summ_real()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_add
                                                  ON MIFloat_Staff_Summ_add.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_add.DescId = zc_MIFloat_Staff_Summ_add()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_total_add
                                                  ON MIFloat_Staff_Summ_total_add.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_total_add.DescId = zc_MIFloat_Staff_Summ_total_add()
                             LEFT JOIN tmpMIFloat AS MIFloat_Staff_Summ_total_real
                                                  ON MIFloat_Staff_Summ_total_real.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Staff_Summ_total_real.DescId = zc_MIFloat_Staff_Summ_total_real()

                             LEFT JOIN tmpMILinkObject AS MILinkObject_PositionLevel
                                                       ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                             LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MILinkObject_PositionLevel.ObjectId
                             LEFT JOIN tmpDay ON 1=1
                        )

       --расчеты
       , tmpDataCalc AS (SELECT MovementItem.Id                               AS Id
                              , MovementItem.ObjectId                         AS PositionId
                              , MovementItem.PositionLevelId                  AS PositionLevelId
                              , Object_StaffPaidKind.Id                       AS StaffPaidKindId
                              , Object_StaffPaidKind.ValueData                AS StaffPaidKindName
                              , Object_StaffHoursDay.Id                       AS StaffHoursDayId
                              , Object_StaffHoursDay.ValueData                AS StaffHoursDayName
                              , Object_StaffHours.Id                          AS StaffHoursId
                              , Object_StaffHours.ValueData                   AS StaffHoursName
                                -- Продолжительность смены, часы
                              , Object_StaffHoursLength.Id                                             AS StaffHoursLengthId
                              , zfConvert_StringToFloat (Object_StaffHoursLength.ValueData) :: Integer AS StaffHoursLengthName
                  
                                -- ШР для справочника
                              , MovementItem.Amount            ::TFloat AS Amount
                                -- ШР для отчета
                              , MovementItem.AmountReport      ::TFloat AS AmountReport
                                -- Кількість штатних одиниць в смену пн.....
                              , MovementItem.StaffCount_1      ::TFloat AS StaffCount_1
                              , MovementItem.StaffCount_2      ::TFloat AS StaffCount_2
                              , MovementItem.StaffCount_3      ::TFloat AS StaffCount_3
                              , MovementItem.StaffCount_4      ::TFloat AS StaffCount_4
                              , MovementItem.StaffCount_5      ::TFloat AS StaffCount_5
                              , MovementItem.StaffCount_6      ::TFloat AS StaffCount_6
                              , MovementItem.StaffCount_7      ::TFloat AS StaffCount_7
                                -- Кількість штатних одиниць в смену Инаентаризация
                              , MovementItem.StaffCount_Invent ::TFloat AS StaffCount_Invent
                  
                                -- Тарифікація
                              , MovementItem.Staff_Price       ::TFloat AS Staff_Price
                                -- МК-місяць
                              , MovementItem.Staff_Summ_MK     ::TFloat AS Staff_Summ_MK
                                -- МК-квартал
                              , MovementItem.Staff_Summ_MK3    ::TFloat AS Staff_Summ_MK3
                                -- МК-піврічча
                              , MovementItem.Staff_Summ_MK6    ::TFloat AS Staff_Summ_MK6
                                -- Відрядна оплата(для 1-єї шт.од)
                              , (COALESCE (MovementItem.Staff_Summ_real, 0) + CASE WHEN MovementItem.Amount > 0 THEN COALESCE (MovementItem.Staff_Summ_total_real, 0) / MovementItem.Amount ELSE 0 END)    ::TFloat AS Staff_Summ_real
                                -- Преміальний фонд(для 1-єї шт.од)
                              , (COALESCE (MovementItem.Staff_Summ_add, 0) + CASE WHEN MovementItem.Amount > 0 THEN COALESCE (MovementItem.Staff_Summ_total_add, 0)/ MovementItem.Amount ELSE 0 END)      ::TFloat AS Staff_Summ_add
                  
                                -- Відрядна оплата(загальна сума)
                              , (COALESCE (MovementItem.Staff_Summ_real, 0) * MovementItem.Amount + COALESCE (MovementItem.Staff_Summ_total_real, 0))   ::TFloat AS Staff_Summ_total_real
                                --Преміальний фонд(загальна сума)
                              , (COALESCE (MovementItem.Staff_Summ_add, 0) * MovementItem.Amount + COALESCE (MovementItem.Staff_Summ_total_add, 0))     ::TFloat AS Staff_Summ_total_add
                  
                              , MovementItem.isErased
                  
                                -- Всього змін за місяць для посади (кол.понед * StaffCount_1 + кол вт * StaffCount_2 и т.д.)
                              , MovementItem.TotalStaffCount ::TFloat AS TotalStaffCount
                  
                                -- ФРЧ (фонд робочого часу) для посади   TotalStaffCount * StaffHoursLength
                              , (MovementItem.TotalStaffCount * zfConvert_StringToNumber (Object_StaffHoursLength.ValueData)) ::TFloat AS TotalStaffHoursLength
                  
                                -- Норма змін для 1-єї шт.од   TotalStaffCount / Amount
                              , CASE WHEN MovementItem.Amount > 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END ::TFloat AS NormCount
                  
                                -- Норма часу для 1-єї шт.од   TotalStaffHoursLength / Amount
                              , CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0
                                          THEN (MovementItem.TotalStaffCount * zfConvert_StringToNumber (Object_StaffHoursLength.ValueData)) / MovementItem.Amount
                                         ELSE 0
                                END ::TFloat AS NormHours
                  
                                -- ФОП за місяць Staff_Price * TotalStaffCount + Staff_Summ_MK + Staff_Summ_real + Staff_Summ_add
                              , CASE
                                     WHEN COALESCE (MovementItem.Amount, 0) < 0.5
                                          -- Преміальний Фонд 
                                          THEN COALESCE (MovementItem.Staff_Summ_add, 0)
                  
                                     WHEN Object_StaffPaidKind.ValueData ILIKE '%Тариф%' AND Object_StaffPaidKind.ValueData ILIKE '%год%'
                                          THEN ( COALESCE  (MovementItem.Staff_Price, 0)
                                               * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0
                                                       -- Норма часу для 1-єї шт.од
                                                       THEN (MovementItem.TotalStaffCount * zfConvert_StringToNumber (Object_StaffHoursLength.ValueData)) / MovementItem.Amount
                                                       ELSE 0
                                                  END
                                                 )
                                               -- ШР для справочника
                                               * COALESCE (MovementItem.Amount, 0)
                                                -- Преміальний Фонд 
                                               + COALESCE (MovementItem.Staff_Summ_add, 0)
                                               )

                                     WHEN Object_StaffPaidKind.ValueData ILIKE '%Зміни%'
                                          THEN COALESCE (MovementItem.TotalStaffCount, 0) * COALESCE (MovementItem.Staff_Price, 0)
                                             + COALESCE (MovementItem.Staff_Summ_MK, 0) * COALESCE (MovementItem.Amount, 0)                       --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) * COALESCE (MovementItem.Amount, 0)                  --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6) * COALESCE (MovementItem.Amount, 0)                  --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                             + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                     WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно'
                                          THEN COALESCE (MovementItem.Staff_Summ_MK, 0) * COALESCE (MovementItem.Amount, 0)                       --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) * COALESCE (MovementItem.Amount, 0)                  --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6) * COALESCE (MovementItem.Amount, 0)                  --MovementItem.AmountReport
                                             + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                             + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                     WHEN Object_StaffPaidKind.ValueData ILIKE '%доплата%'
                                          THEN COALESCE (MovementItem.TotalStaffCount, 0) * COALESCE (MovementItem.Staff_Price, 0)
                                             + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                             + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                             + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                             + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                             + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                     WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно підробіток'
                                          THEN COALESCE (MovementItem.Staff_Summ_real, 0)
                  
                                     WHEN Object_StaffPaidKind.ValueData ILIKE '%Оклад%'
                                       OR Object_StaffPaidKind.ValueData ILIKE '%Фіксована%'
                                          THEN (COALESCE (MovementItem.Staff_Price, 0) + COALESCE (MovementItem.Staff_Summ_MK, 0) + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)) * COALESCE (MovementItem.AmountReport, 0)
                                             + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                             + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                     WHEN 1=1
                                          THEN (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                     ELSE 0
                                END :: TFloat AS WageFund
                  
                  
                                -- ЗП для 1-єї шт.од до оподаткуання   WageFund / AmountReport
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE '%Тариф%' AND Object_StaffPaidKind.ValueData ILIKE '%год%'
                                     THEN CASE WHEN COALESCE (MovementItem.Amount, 0) < 0.5
                                                    -- Преміальний Фонд 
                                                    THEN COALESCE (MovementItem.Staff_Summ_add, 0)
                  
                                               ELSE ( COALESCE  (MovementItem.Staff_Price, 0)
                                                    * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0
                                                            -- Норма часу для 1-єї шт.од
                                                            THEN (MovementItem.TotalStaffCount * zfConvert_StringToNumber (Object_StaffHoursLength.ValueData)) / MovementItem.Amount
                                                            ELSE 0
                                                       END
                                                      )
                                                       -- ШР для справочника
                                                    * COALESCE (MovementItem.Amount, 0)
                                                      -- Преміальний Фонд 
                                                    + COALESCE (MovementItem.Staff_Summ_add, 0)
                                                    )
                                                  / COALESCE (MovementItem.Amount, 0)
                                          END
                                     ELSE
                                          CASE WHEN COALESCE (MovementItem.Amount, 0) < 0.5
                                                    THEN COALESCE (MovementItem.Staff_Summ_add, 0)
                  
                                               WHEN Object_StaffPaidKind.ValueData ILIKE '%Зміни%'
                                                    THEN COALESCE (MovementItem.TotalStaffCount, 0) * COALESCE (MovementItem.Staff_Price, 0)
                                                       + COALESCE (MovementItem.Staff_Summ_MK, 0) * COALESCE (MovementItem.Amount, 0)                     --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) * COALESCE (MovementItem.Amount, 0)                --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6) * COALESCE (MovementItem.Amount, 0)                --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                                       + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                               WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно'
                                                    THEN COALESCE (MovementItem.Staff_Summ_MK, 0) * COALESCE (MovementItem.Amount, 0)                     --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) * COALESCE (MovementItem.Amount, 0)                --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6) * COALESCE (MovementItem.Amount, 0)                --MovementItem.AmountReport
                                                       + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                                       + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                               WHEN Object_StaffPaidKind.ValueData ILIKE '%доплата%'
                                                    THEN COALESCE (MovementItem.TotalStaffCount, 0) * COALESCE (MovementItem.Staff_Price, 0)
                                                       + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                                       + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                                       + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                                       + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                                       + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                               WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно підробіток'
                                                    THEN COALESCE (MovementItem.Staff_Summ_real, 0)
                  
                                               WHEN Object_StaffPaidKind.ValueData ILIKE '%Оклад%'
                                                 OR Object_StaffPaidKind.ValueData ILIKE '%Фіксована%'
                                                    THEN (COALESCE (MovementItem.Staff_Price, 0) + COALESCE (MovementItem.Staff_Summ_MK, 0) + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3) + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)) * COALESCE (MovementItem.AmountReport, 0)
                                                       + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                                       + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                  
                                               WHEN 1=1
                                                    THEN COALESCE (MovementItem.Staff_Summ_add, 0)
                  
                                               ELSE 0
                                           END
                  
                                         / CASE WHEN COALESCE (MovementItem.Amount, 0) < 0.5                                                                --MovementItem.AmountReport
                                                    THEN 1                                                                                                  --MovementItem.AmountReport
                                                ELSE MovementItem.Amount
                                           END
                                END:: TFloat AS WageFund_byOne
                                
                              /*
                               --расчет ЗП для 1-єї шт.од (формули різні)
                               -- Зміни/час
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE '%Зміни%'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_1 
                               -- Відрядно
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_2
                               -- доплата за 1 день
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE '%доплата%'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_3
                               -- відрядно підробіток
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно підробіток'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_4
                               -- Оклад/місяць
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Оклад/місяць'
                                     THEN COALESCE (MovementItem.Staff_Price, 0)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_5
                               -- Фіксована сума
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Фіксована сума'
                                     THEN COALESCE (MovementItem.Staff_Price, 0)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_6
                               -- Преміальний Фонд
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Преміальний Фонд'
                                     THEN COALESCE (MovementItem.Staff_Summ_add, 0) 
                                     
                                     ELSE 0
                                END ::TFloat AS Summ_7
                               -- Тариф/час
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Тариф/час'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_8
                               -- Оклад/місяць + премія % від ТО
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Оклад/місяць + премія % від ТО'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (CASE WHEN COALESCE (MovementItem.Amount, 0) <> 0 THEN MovementItem.TotalStaffCount / MovementItem.Amount ELSE 0 END)
                                        + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                        + (COALESCE (MovementItem.Staff_Summ_MK3, 0)/3)
                                        + (COALESCE (MovementItem.Staff_Summ_MK6, 0)/6)
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_9
                               -- Перевірка 1
                               -- Перевірка 2
                  
                              -- ФОП (формули різні)
                               -- Зміни/час
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE '%Зміни%'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * MovementItem.TotalStaffCount
                                        + (COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_10 
                               -- Відрядно
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно'
                                     THEN (COALESCE (MovementItem.Staff_Price, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_11
                               -- доплата за 1 день
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE '%доплата%'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * MovementItem.TotalStaffCount
                                        + (COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_12
                               -- відрядно підробіток
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'відрядно підробіток'
                                     THEN (COALESCE (MovementItem.Staff_Price, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_13
                               -- Оклад/місяць
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Оклад/місяць'
                                     THEN (COALESCE (MovementItem.Staff_Price, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_14
                               -- Фіксована сума
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Фіксована сума'
                                     THEN (COALESCE (MovementItem.Staff_Price, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_15
                               -- Преміальний Фонд
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Преміальний Фонд'
                                     THEN COALESCE (MovementItem.Staff_Summ_total_add, 0)
                                     ELSE 0
                                END ::TFloat AS Summ_16
                               -- Тариф/час
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Тариф/час'
                                     THEN COALESCE (MovementItem.Staff_Price, 0) * (MovementItem.TotalStaffCount * zfConvert_StringToNumber (Object_StaffHoursLength.ValueData)) 
                                        + (COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_17
                               -- Оклад/місяць + премія % від ТО
                              , CASE WHEN Object_StaffPaidKind.ValueData ILIKE 'Оклад/місяць + премія % від ТО'
                                     THEN (COALESCE (MovementItem.Staff_Price, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK, 0)
                                         + COALESCE (MovementItem.Staff_Summ_MK3, 0)/3 
                                         + COALESCE (MovementItem.Staff_Summ_MK6, 0)/6 ) * MovementItem.Amount  
                                        + (COALESCE (MovementItem.Staff_Summ_real, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                        + (COALESCE (MovementItem.Staff_Summ_add, 0) + COALESCE (MovementItem.Staff_Summ_total_real, 0)/ MovementItem.Amount)
                                     ELSE 0
                                END ::TFloat AS Summ_18
                             */
                         FROM tmpData AS MovementItem
                  
                              LEFT JOIN tmpMILinkObject AS MILinkObject_StaffPaidKind
                                                        ON MILinkObject_StaffPaidKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_StaffPaidKind.DescId = zc_MILinkObject_StaffPaidKind()
                              LEFT JOIN Object AS Object_StaffPaidKind ON Object_StaffPaidKind.Id = MILinkObject_StaffPaidKind.ObjectId
                  
                              LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursDay
                                                        ON MILinkObject_StaffHoursDay.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_StaffHoursDay.DescId = zc_MILinkObject_StaffHoursDay()
                              LEFT JOIN Object AS Object_StaffHoursDay ON Object_StaffHoursDay.Id = MILinkObject_StaffHoursDay.ObjectId
                  
                              LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHours
                                                        ON MILinkObject_StaffHours.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_StaffHours.DescId = zc_MILinkObject_StaffHours()
                              LEFT JOIN Object AS Object_StaffHours ON Object_StaffHours.Id = MILinkObject_StaffHours.ObjectId
                  
                              LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursLength
                                                        ON MILinkObject_StaffHoursLength.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_StaffHoursLength.DescId = zc_MILinkObject_StaffHoursLength()
                              LEFT JOIN Object AS Object_StaffHoursLength ON Object_StaffHoursLength.Id = MILinkObject_StaffHoursLength.ObjectId
                              )


       -- Результат
       SELECT 0                  AS Id
            , tmp.PositionId
            , tmp.PositionCode
            , tmp.PositionName
            , tmp.PositionLevelId
            , tmp.PositionLevelName
            , 0    ::Integer     AS StaffPaidKindId
            , ''   ::TVarChar    AS StaffPaidKindName
            , 0    ::Integer     AS StaffHoursDayId
            , ''   ::TVarChar    AS StaffHoursDayName
            , 0    ::Integer     AS StaffHoursId
            , ''   ::TVarChar    AS StaffHoursName
            , 0    ::Integer     AS StaffHoursLengthId
            , 0    ::Integer     AS StaffHoursLengthName
            , 0    ::Integer     AS PersonalId
            , ''   ::TVarChar    AS PersonalName

            , tmp.PersonalCount ::TFloat AS Amount
            , tmp.PersonalCount ::TFloat AS AmountReport
            , 0    ::TFloat      AS StaffCount_1
            , 0    ::TFloat      AS StaffCount_2
            , 0    ::TFloat      AS StaffCount_3
            , 0    ::TFloat      AS StaffCount_4
            , 0    ::TFloat      AS StaffCount_5
            , 0    ::TFloat      AS StaffCount_6
            , 0    ::TFloat      AS StaffCount_7
            , 0    ::TFloat      AS StaffCount_Invent
            , 0    ::TFloat      AS Staff_Price
            , 0    ::TFloat      AS Staff_Summ_MK
            , 0    ::TFloat      AS Staff_Summ_MK3
            , 0    ::TFloat      AS Staff_Summ_MK6
            , 0    ::TFloat      AS Staff_Summ_real
            , 0    ::TFloat      AS Staff_Summ_add
            , 0    ::TFloat      AS Staff_Summ_total_real
            , 0    ::TFloat      AS Staff_Summ_total_add

            , ''   ::TVarChar    AS Comment
            , FALSE ::Boolean    AS isErased

            , 0    ::TFloat      AS TotalStaffCount
            , 0    ::TFloat      AS TotalStaffHoursLength
            , 0    ::TFloat      AS NormCount
            , 0    ::TFloat      AS NormHours
            , 0    ::TFloat      AS WageFund
            , 0    ::TFloat      AS WageFund_byOne
            /*
             --расчет ЗП для 1-єї шт.од (формули різні)
             -- Зміни/час
            , 0 ::TFloat AS Summ_1
             -- Відрядно
            , 0 ::TFloat AS Summ_2
             -- доплата за 1 день
            , 0 ::TFloat AS Summ_3
             -- відрядно підробіток
            , 0 ::TFloat AS Summ_4
             -- Оклад/місяць
            , 0 ::TFloat AS Summ_5
             -- Фіксована сума
            , 0 ::TFloat AS Summ_6
             -- Преміальний Фонд
            , 0 ::TFloat AS Summ_7
             -- Тариф/час
            , 0 ::TFloat AS Summ_8
             -- Оклад/місяць + премія % від ТО
            , 0 ::TFloat AS Summ_9
            --ЗП
            , 0 ::TFloat AS SummZP_byOne
             -- Перевірка 1
            , 0 ::TFloat AS SummControl_1
             -- Перевірка 2
            , 0 ::TFloat AS SummControl_2
            -- ФОП (формули різні)
             -- Зміни/час
            , 0 ::TFloat AS Summ_10 
             -- Відрядно
            , 0 ::TFloat AS Summ_11
             -- доплата за 1 день
            , 0 ::TFloat AS Summ_12
             -- відрядно підробіток
            , 0 ::TFloat AS Summ_13
             -- Оклад/місяць
            , 0 ::TFloat AS Summ_14
             -- Фіксована сума
            , 0 ::TFloat AS Summ_15
             -- Преміальний Фонд
            , 0 ::TFloat AS Summ_16
             -- Тариф/час
            , 0 ::TFloat AS Summ_17
             -- Оклад/місяць + премія % від ТО
            , 0 ::TFloat AS Summ_18
             --ЗП
            , 0 ::TFloat AS SummZP
            -- Перевірка 1
            , 0 ::TFloat AS SummControl_3
            -- Перевірка 2 
            , 0 ::TFloat AS SummControl_4 
            */
      FROM tmpStaffList_object AS tmp
            LEFT JOIN tmpData ON tmpData.ObjectId = tmp.PositionId
                             AND COALESCE (tmpData.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
       WHERE tmpData.ObjectId IS NULL

     UNION
       SELECT MovementItem.Id                  AS Id
            , Object_Position.Id               AS PositionId
            , Object_Position.ObjectCode       AS PositionCode
            , Object_Position.ValueData        AS PositionName
            , Object_PositionLevel.Id          AS PositionLevelId
            , Object_PositionLevel.ValueData   AS PositionLevelName
            , MovementItem.StaffPaidKindId
            , MovementItem.StaffPaidKindName
            , MovementItem.StaffHoursDayId
            , MovementItem.StaffHoursDayName
            , MovementItem.StaffHoursId
            , MovementItem.StaffHoursName
              -- Продолжительность смены, часы
            , MovementItem.StaffHoursLengthId
            , MovementItem.StaffHoursLengthName
              --
            , Object_Personal.Id                            AS PersonalId
            , Object_Personal.ValueData                     AS PersonalName

              -- ШР для справочника
            , MovementItem.Amount            ::TFloat AS Amount
              -- ШР для отчета
            , MovementItem.AmountReport      ::TFloat AS AmountReport
              -- Кількість штатних одиниць в смену пн.....
            , MovementItem.StaffCount_1      ::TFloat AS StaffCount_1
            , MovementItem.StaffCount_2      ::TFloat AS StaffCount_2
            , MovementItem.StaffCount_3      ::TFloat AS StaffCount_3
            , MovementItem.StaffCount_4      ::TFloat AS StaffCount_4
            , MovementItem.StaffCount_5      ::TFloat AS StaffCount_5
            , MovementItem.StaffCount_6      ::TFloat AS StaffCount_6
            , MovementItem.StaffCount_7      ::TFloat AS StaffCount_7
              -- Кількість штатних одиниць в смену Инаентаризация
            , MovementItem.StaffCount_Invent ::TFloat AS StaffCount_Invent

              -- Тарифікація
            , MovementItem.Staff_Price       ::TFloat AS Staff_Price
              -- МК-місяць
            , MovementItem.Staff_Summ_MK     ::TFloat AS Staff_Summ_MK
              -- МК-квартал
            , MovementItem.Staff_Summ_MK3    ::TFloat AS Staff_Summ_MK3
              -- МК-піврічча
            , MovementItem.Staff_Summ_MK6    ::TFloat AS Staff_Summ_MK6
              -- Відрядна оплата(для 1-єї шт.од)
            , MovementItem.Staff_Summ_real   ::TFloat AS Staff_Summ_real
              -- Преміальний фонд(для 1-єї шт.од)
            , MovementItem.Staff_Summ_add    ::TFloat AS Staff_Summ_add

              -- Відрядна оплата(загальна сума)
            , MovementItem.Staff_Summ_total_real   ::TFloat AS Staff_Summ_total_real
              --Преміальний фонд(загальна сума)
            , MovementItem.Staff_Summ_total_add    ::TFloat AS Staff_Summ_total_add


            , MIString_Comment.ValueData   ::TVarChar AS Comment
            , MovementItem.isErased

              -- Всього змін за місяць для посади (кол.понед * StaffCount_1 + кол вт * StaffCount_2 и т.д.)
            , MovementItem.TotalStaffCount ::TFloat AS TotalStaffCount

              -- ФРЧ (фонд робочого часу) для посади   TotalStaffCount * StaffHoursLength
            , MovementItem.TotalStaffHoursLength  ::TFloat

              -- Норма змін для 1-єї шт.од   TotalStaffCount / Amount
            , MovementItem.NormCount              ::TFloat

              -- Норма часу для 1-єї шт.од   TotalStaffHoursLength / Amount
            , MovementItem.NormHours              ::TFloat

              -- ФОП за місяць Staff_Price * TotalStaffCount + Staff_Summ_MK + Staff_Summ_real + Staff_Summ_add
            , MovementItem.WageFund ::TFloat

              -- ЗП для 1-єї шт.од до оподаткуання   WageFund / AmountReport
            , MovementItem.WageFund_byOne   ::TFloat

/*
             --расчет ЗП для 1-єї шт.од (формули різні)
             -- Зміни/час
            , MovementItem.Summ_1  ::TFloat
             -- Відрядно
            , MovementItem.Summ_2
             -- доплата за 1 день
            , MovementItem.Summ_3
             -- відрядно підробіток
            , MovementItem.Summ_4
             -- Оклад/місяць
            , MovementItem.Summ_5
             -- Фіксована сума
            , MovementItem.Summ_6
             -- Преміальний Фонд
            , MovementItem.Summ_7
             -- Тариф/час
            , MovementItem.Summ_8
             -- Оклад/місяць + премія % від ТО
            , MovementItem.Summ_9
            --ЗП
            , (COALESCE (MovementItem.Summ_1,0)
             + COALESCE (MovementItem.Summ_2,0)
             + COALESCE (MovementItem.Summ_3,0)
             + COALESCE (MovementItem.Summ_4,0)
             + COALESCE (MovementItem.Summ_5,0)
             + COALESCE (MovementItem.Summ_6,0)
             + COALESCE (MovementItem.Summ_7,0)
             + COALESCE (MovementItem.Summ_8,0)
             + COALESCE (MovementItem.Summ_9,0)) ::TFloat AS SummZP_byOne
             -- Перевірка 1
            , ((COALESCE (MovementItem.Summ_1,0)
              + COALESCE (MovementItem.Summ_2,0)
              + COALESCE (MovementItem.Summ_3,0)
              + COALESCE (MovementItem.Summ_4,0)
              + COALESCE (MovementItem.Summ_5,0)
              + COALESCE (MovementItem.Summ_6,0)
              + COALESCE (MovementItem.Summ_7,0)
              + COALESCE (MovementItem.Summ_8,0)
              + COALESCE (MovementItem.Summ_9,0))
            - COALESCE (MovementItem.WageFund_byOne,0) ) ::TFloat AS SummControl_1
             -- Перевірка 2
            , (((COALESCE (MovementItem.Summ_1,0)
             + COALESCE (MovementItem.Summ_2,0)
             + COALESCE (MovementItem.Summ_3,0)
             + COALESCE (MovementItem.Summ_4,0)
             + COALESCE (MovementItem.Summ_5,0)
             + COALESCE (MovementItem.Summ_6,0)
             + COALESCE (MovementItem.Summ_7,0)
             + COALESCE (MovementItem.Summ_8,0)
             + COALESCE (MovementItem.Summ_9,0)) * MovementItem.Amount)
            - COALESCE (MovementItem.WageFund,0)) ::TFloat AS SummControl_2
            -- ФОП (формули різні)
             -- Зміни/час
            , MovementItem.Summ_10 
             -- Відрядно
            , MovementItem.Summ_11
             -- доплата за 1 день
            , MovementItem.Summ_12
             -- відрядно підробіток
            , MovementItem.Summ_13
             -- Оклад/місяць
            , MovementItem.Summ_14
             -- Фіксована сума
            , MovementItem.Summ_15
             -- Преміальний Фонд
            , MovementItem.Summ_16
             -- Тариф/час
            , MovementItem.Summ_17
             -- Оклад/місяць + премія % від ТО
            , MovementItem.Summ_18
             --ЗП
            , (COALESCE (MovementItem.Summ_10,0)
             + COALESCE (MovementItem.Summ_11,0)
             + COALESCE (MovementItem.Summ_12,0)
             + COALESCE (MovementItem.Summ_13,0)
             + COALESCE (MovementItem.Summ_14,0)
             + COALESCE (MovementItem.Summ_15,0)
             + COALESCE (MovementItem.Summ_16,0)
             + COALESCE (MovementItem.Summ_17,0)
             + COALESCE (MovementItem.Summ_18,0)) ::TFloat AS SummZP
            -- Перевірка 1
            , ((COALESCE (MovementItem.Summ_10,0)
             + COALESCE (MovementItem.Summ_11,0)
             + COALESCE (MovementItem.Summ_12,0)
             + COALESCE (MovementItem.Summ_13,0)
             + COALESCE (MovementItem.Summ_14,0)
             + COALESCE (MovementItem.Summ_15,0)
             + COALESCE (MovementItem.Summ_16,0)
             + COALESCE (MovementItem.Summ_17,0)
             + COALESCE (MovementItem.Summ_18,0)) 
             - COALESCE (MovementItem.WageFund,0)) ::TFloat AS SummControl_3
            -- Перевірка 2 
            , CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                  THEN (COALESCE (MovementItem.Summ_10,0)
                        + COALESCE (MovementItem.Summ_11,0)
                        + COALESCE (MovementItem.Summ_12,0)
                        + COALESCE (MovementItem.Summ_13,0)
                        + COALESCE (MovementItem.Summ_14,0)
                        + COALESCE (MovementItem.Summ_15,0)
                        + COALESCE (MovementItem.Summ_16,0)
                        + COALESCE (MovementItem.Summ_17,0)
                        + COALESCE (MovementItem.Summ_18,0)) / MovementItem.Amount
             - COALESCE (MovementItem.WageFund_byOne,0)
                    ELSE  0
              END ::TFloat AS SummControl_4
         */

       FROM tmpDataCalc AS MovementItem
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementItem.PositionId

            LEFT JOIN tmpMIString AS MIString_Comment
                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                 AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementItem.PositionLevelId

            LEFT JOIN tmpMILinkObject AS MILinkObject_Personal
                                      ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Personal.DescId = zc_MILinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MILinkObject_Personal.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.25         * Staff_Summ_MK3, Staff_Summ_MK6
 20.08.25         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_StaffList (inMovementId:= 14521952, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '9457')