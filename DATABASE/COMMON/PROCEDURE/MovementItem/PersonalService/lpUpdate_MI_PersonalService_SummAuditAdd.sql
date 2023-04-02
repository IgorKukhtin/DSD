-- Function: lpUpdate_MI_PersonalService_SummAuditAdd()

-- DROP FUNCTION IF EXISTS lpUpdate_MI_PersonalService_SummAuditAdd  (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_PersonalService_SummAuditAdd  (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_PersonalService_SummAuditAdd(
    IN inMovementId            Integer   , -- Ключ объекта <документ>
    IN inPersonalServiceListId Integer   , -- Ключ объекта <документ>
    IN inUserId              Integer    -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbServiceDate TDateTime;
   DECLARE vbStartDate   TDateTime;
   DECLARE vbEndDate     TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());

   -- месяц начисления
   vbServiceDate := (SELECT MovementDate_ServiceDate.ValueData
                     FROM MovementDate AS MovementDate_ServiceDate
                     WHERE MovementDate_ServiceDate.MovementId = inMovementId
                       AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate());

   -- даты для выборки данных из табеля
   vbStartDate := (DATE_TRUNC ('MONTH', vbServiceDate));
   vbEndDate := (DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY');


   -- сохранили
   PERFORM -- Сумма доплата за ревизию - Ведомость охрана 
           lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAuditAdd(), tmp.MovementItemId, CASE WHEN inPersonalServiceListId = 301885 THEN tmp.SummAuditAdd ELSE tmp.SummAuditAdd_mi END)
           -- Дней доплата за ревизию
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayAudit(), tmp.MovementItemId, tmp.DayAudit)

           -- Сумма доплата за прогул
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSkip(), tmp.MovementItemId, tmp.SummSkip)
           -- Дней доплата за прогул
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DaySkip(), tmp.MovementItemId, tmp.DaySkip)

           -- Сумма доплата за санобработка
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMedicdayAdd(), tmp.MovementItemId, tmp.SummMedicdayAdd)
           -- Дней доплата за санобработка
         , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayMedicday(), tmp.MovementItemId, tmp.DayMedicday)

         , lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, False)                                       -- сохранили протокол
   FROM (WITH
         --  строки документа
         tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                        , MovementItem.ObjectId                    AS PersonalId
                        , MILinkObject_Unit.ObjectId               AS UnitId
                        , MILinkObject_Position.ObjectId           AS PositionId
                        , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal

                        , COALESCE (MIF_SummAuditAdd.ValueData, 0) AS SummAuditAdd_mi
                        , COALESCE (MIF_DayAudit.ValueData, 0)     AS DayAudit_mi

                        , COALESCE (MIF_SummSkip.ValueData, 0)     AS SummSkip_mi
                        , COALESCE (MIF_DaySkip.ValueData, 0)      AS DaySkip_mi

                        , COALESCE (MIF_SummMedicdayAdd.ValueData, 0) AS SummAuditAdd_mi
                        , COALESCE (MIF_DayMedicday.ValueData, 0)     AS DayAudit_mi

                   FROM  MovementItem
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                         ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()

                        LEFT JOIN MovementItemFloat AS MIF_SummAuditAdd
                                                    ON MIF_SummAuditAdd.MovementItemId = MovementItem.Id
                                                   AND MIF_SummAuditAdd.DescId         = zc_MIFloat_SummAuditAdd()
                        LEFT JOIN MovementItemFloat AS MIF_DayAudit
                                                    ON MIF_DayAudit.MovementItemId = MovementItem.Id
                                                   AND MIF_DayAudit.DescId         = zc_MIFloat_DayAudit()

                        LEFT JOIN MovementItemFloat AS MIF_SummSkip
                                                    ON MIF_SummSkip.MovementItemId = MovementItem.Id
                                                   AND MIF_SummSkip.DescId         = zc_MIFloat_SummSkip()
                        LEFT JOIN MovementItemFloat AS MIF_DaySkip
                                                    ON MIF_DaySkip.MovementItemId = MovementItem.Id
                                                   AND MIF_DaySkip.DescId         = zc_MIFloat_DaySkip()

                        LEFT JOIN MovementItemFloat AS MIF_SummMedicdayAdd
                                                    ON MIF_SummMedicdayAdd.MovementItemId = MovementItem.Id
                                                   AND MIF_SummMedicdayAdd.DescId         = zc_MIFloat_SummMedicdayAdd()
                        LEFT JOIN MovementItemFloat AS MIF_DayMedicday
                                                    ON MIF_DayMedicday.MovementItemId = MovementItem.Id
                                                   AND MIF_DayMedicday.DescId         = zc_MIFloat_DayMedicday()

                        LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                             ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE
                   )

         -- данные из табеля раб времени
         SELECT tmpMI.MovementItemId
              , tmpMI.SummAuditAdd_mi
              , tmpMI.DayAudit_mi

              , tmpMI.SummSkip_mi
              , tmpMI.DaySkip_mi

              , tmpMI.SummAuditAdd_mi
              , tmpMI.DayAudit_mi

              , MI_SheetWorkTime.ObjectId               AS MemberId
              , COALESCE(MIObject_Position.ObjectId, 0) AS PositionId
              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Audit() THEN 1 ELSE 0 END)                                            AS DayAudit             -- дней ревизии
              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Audit() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0) AS SummAuditAdd         -- сумма ревизии

              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip() THEN 1 ELSE 0 END)                                             AS DaySkip              -- дней прогул
              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0)  AS SummSkip             -- сумма прогул

              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Medicday() THEN 1 ELSE 0 END)                                            AS DayMedicday       -- дней санобработка
              , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Medicday() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0) AS SummMedicdayAdd   -- сумма санобработка

         FROM Movement
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
              INNER JOIN MovementItem AS MI_SheetWorkTime
                                      ON MI_SheetWorkTime.MovementId = Movement.Id
                                     AND MI_SheetWorkTime.isErased = FALSE
              INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                               AND MIObject_WorkTimeKind.DescId   = zc_MILinkObject_WorkTimeKind()
                                               AND MIObject_WorkTimeKind.ObjectId IN (zc_Enum_WorkTimeKind_Audit()     -- ревизия
                                                                                    , zc_Enum_WorkTimeKind_Skip()      -- прогул
                                                                                    , zc_Enum_WorkTimeKind_Medicday()  -- санобработка
                                                                                     )
              LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                               ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                              AND MIObject_Position.DescId = zc_MILinkObject_Position()

              INNER JOIN tmpMI ON tmpMI.UnitId = MovementLinkObject_Unit.ObjectId
                              AND tmpMI.MemberId_Personal       = MI_SheetWorkTime.ObjectId
                              AND COALESCE(tmpMI.PositionId, 0) = COALESCE(MIObject_Position.ObjectId, 0)

              LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                    ON ObjectFloat_Summ.ObjectId = MIObject_WorkTimeKind.ObjectId
                                   AND ObjectFloat_Summ.DescId = zc_ObjectFloat_WorkTimeKind_Summ()
         WHERE Movement.DescId = zc_Movement_SheetWorkTime()
           AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         GROUP BY MI_SheetWorkTime.ObjectId
                , tmpMI.SummAuditAdd_mi
                , tmpMI.DayAudit_mi
                , tmpMI.SummSkip_mi
                , tmpMI.DaySkip_mi
                , tmpMI.SummAuditAdd_mi
                , tmpMI.DayAudit_mi
                , COALESCE (MIObject_Position.ObjectId, 0)
                , COALESCE (ObjectFloat_Summ.ValueData, 0)
                , tmpMI.MovementItemId
         ) AS tmp
   WHERE tmp.SummAuditAdd    <> 0
      OR tmp.DayAudit        <> 0
      OR tmp.SummSkip        <> 0
      OR tmp.DaySkip         <> 0
      OR tmp.SummMedicdayAdd <> 0
      OR tmp.DayMedicday     <> 0

      OR tmp.SummAuditAdd_mi    <> 0
      OR tmp.DayAudit_mi        <> 0
      OR tmp.SummSkip_mi        <> 0
      OR tmp.DaySkip_mi         <> 0
      OR tmp.SummMedicdayAdd_mi <> 0
      OR tmp.DayMedicday_mi     <> 0
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.20         *
*/

-- тест
-- select * from lpUpdate_MI_PersonalService_SummAuditAdd(0, 5)