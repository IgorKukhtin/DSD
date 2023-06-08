-- Function: lpUpdate_MI_PersonalService_SummAuditAdd()

DROP FUNCTION IF EXISTS lpUpdate_MI_PersonalService_SummAuditAdd  (Integer, Integer);
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


   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
   FROM -- сохранили
        (SELECT tmp.MovementItemId
                -- Сумма доплата за ревизию - Ведомость охрана
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.SummAuditAdd <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAuditAdd(), tmp.MovementItemId, CASE WHEN inPersonalServiceListId = 301885 THEN tmp.SummAuditAdd ELSE tmp.SummAuditAdd_mi END)
                END
                -- Дней доплата за ревизию
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.DayAudit <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayAudit(), tmp.MovementItemId, tmp.DayAudit)
                END
                -- Сумма доплата за прогул
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.SummSkip <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSkip(), tmp.MovementItemId, tmp.SummSkip)
                END
                -- Дней доплата за прогул
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.DaySkip <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_DaySkip(), tmp.MovementItemId, tmp.DaySkip)
                END
                -- Сумма доплата за санобработка
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.SummMedicdayAdd <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMedicdayAdd(), tmp.MovementItemId, tmp.SummMedicdayAdd)
                END
                -- Дней доплата за санобработка
              , CASE WHEN tmp.MovementItemId > 0 OR tmp.DayMedicday <> 0
                     THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayMedicday(), tmp.MovementItemId, tmp.DayMedicday)
                END
        FROM (WITH
              --  строки документа
              tmpMI AS (SELECT MovementItem.Id                              AS MovementItemId
                             , MovementItem.ObjectId                        AS PersonalId
                             , MILinkObject_Unit.ObjectId                   AS UnitId
                             , COALESCE (MILinkObject_Position.ObjectId, 0) AS PositionId
                             , ObjectLink_Personal_Member.ChildObjectId     AS MemberId_Personal
     
                             , COALESCE (MIF_SummAuditAdd.ValueData, 0)     AS SummAuditAdd_mi
                             , COALESCE (MIF_DayAudit.ValueData, 0)         AS DayAudit_mi
     
                             , COALESCE (MIF_SummSkip.ValueData, 0)         AS SummSkip_mi
                             , COALESCE (MIF_DaySkip.ValueData, 0)          AS DaySkip_mi
     
                             , COALESCE (MIF_SummMedicdayAdd.ValueData, 0)  AS SummMedicdayAdd_mi
                             , COALESCE (MIF_DayMedicday.ValueData, 0)      AS DayMedicday_mi
     
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
      , tmpMI_SheetWorkTime AS (SELECT MI_SheetWorkTime.ObjectId                AS MemberId
                                     , MovementLinkObject_Unit.ObjectId         AS UnitId
                                     , COALESCE (MIObject_Position.ObjectId, 0) AS PositionId
                                       -- дней ревизии
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Audit() THEN 1 ELSE 0 END)                                               AS DayAudit
                                       -- сумма ревизии
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Audit() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0)    AS SummAuditAdd
     
                                       -- дней прогул
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip() THEN 1 ELSE 0 END)                                                AS DaySkip
                                       -- сумма прогул
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Skip() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0)     AS SummSkip
                                       -- дней санобработка
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Medicday() THEN 1 ELSE 0 END)                                            AS DayMedicday
                                       -- сумма санобработка
                                     , SUM (CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Medicday() THEN 1 ELSE 0 END) * COALESCE (ObjectFloat_Summ.ValueData, 0) AS SummMedicdayAdd
     
                                FROM Movement
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                     INNER JOIN MovementItem AS MI_SheetWorkTime
                                                             ON MI_SheetWorkTime.MovementId = Movement.Id
                                                            AND MI_SheetWorkTime.isErased   = FALSE
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
     
                                     LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                                           ON ObjectFloat_Summ.ObjectId = MIObject_WorkTimeKind.ObjectId
                                                          AND ObjectFloat_Summ.DescId   = zc_ObjectFloat_WorkTimeKind_Summ()
                                WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                                  AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                GROUP BY MI_SheetWorkTime.ObjectId
                                       , MovementLinkObject_Unit.ObjectId
                                       , COALESCE (MIObject_Position.ObjectId, 0)
                                       , COALESCE (ObjectFloat_Summ.ValueData, 0)
                               )
     
              -- данные из табеля раб времени
              SELECT tmpMI.MovementItemId
                   , tmpMI.SummAuditAdd_mi
                   , tmpMI.DayAudit_mi
     
                   , tmpMI.SummSkip_mi
                   , tmpMI.DaySkip_mi
     
                   , tmpMI.SummMedicdayAdd_mi
                   , tmpMI.DayMedicday_mi
     
                   , tmpMI_SheetWorkTime.MemberId
                   , tmpMI_SheetWorkTime.PositionId
     
                     -- дней ревизии
                   , SUM (tmpMI_SheetWorkTime.DayAudit)        AS DayAudit
                     -- сумма ревизии
                   , SUM (tmpMI_SheetWorkTime.SummAuditAdd)    AS SummAuditAdd
     
                     -- дней прогул
                   , SUM (tmpMI_SheetWorkTime.DaySkip)         AS DaySkip
                     -- сумма прогул
                   , SUM (tmpMI_SheetWorkTime.SummSkip)        AS SummSkip
                     -- дней санобработка
                   , SUM (tmpMI_SheetWorkTime.DayMedicday)     AS DayMedicday
                     -- сумма санобработка
                   , SUM (tmpMI_SheetWorkTime.SummMedicdayAdd) AS SummMedicdayAdd
     
              FROM tmpMI_SheetWorkTime
                   INNER JOIN tmpMI ON tmpMI.UnitId            = tmpMI_SheetWorkTime.UnitId
                                   AND tmpMI.MemberId_Personal = tmpMI_SheetWorkTime.MemberId
                                   AND tmpMI.PositionId        = tmpMI_SheetWorkTime.PositionId
     
              GROUP BY tmpMI_SheetWorkTime.MemberId
                     , tmpMI_SheetWorkTime.PositionId
                     , tmpMI.SummAuditAdd_mi
                     , tmpMI.DayAudit_mi
                     , tmpMI.SummSkip_mi
                     , tmpMI.DaySkip_mi
                     , tmpMI.SummMedicdayAdd_mi
                     , tmpMI.DayMedicday_mi
                     , tmpMI.MovementItemId
             UNION
              SELECT tmpMI.MovementItemId
                   , tmpMI.SummAuditAdd_mi
                   , tmpMI.DayAudit_mi
     
                   , tmpMI.SummSkip_mi
                   , tmpMI.DaySkip_mi
     
                   , tmpMI.SummMedicdayAdd_mi
                   , tmpMI.DayMedicday_mi
     
                   , tmpMI_SheetWorkTime.MemberId
                   , tmpMI_SheetWorkTime.PositionId
     
                     -- дней ревизии
                   , 0 AS DayAudit
                     -- сумма ревизии
                   , 0 AS SummAuditAdd
                     -- дней прогул
                   , 0 AS DaySkip
                     -- сумма прогул
                   , 0 AS SummSkip
                     -- дней санобработка
                   , 0 AS DayMedicday
                     -- сумма санобработка
                   , 0 AS SummMedicdayAdd
              FROM tmpMI
                   LEFT JOIN tmpMI_SheetWorkTime ON tmpMI_SheetWorkTime.UnitId     = tmpMI.UnitId
                                                AND tmpMI_SheetWorkTime.MemberId   = tmpMI.MemberId_Personal
                                                AND tmpMI_SheetWorkTime.PositionId = tmpMI.PositionId
              WHERE tmpMI_SheetWorkTime.UnitId IS NULL
               AND  (tmpMI.SummAuditAdd_mi    <> 0
                  OR tmpMI.SummSkip_mi        <> 0
                  OR tmpMI.SummMedicdayAdd_mi <> 0
                    )
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
       ) AS tmp
     ;
     
     -- test
     IF inUserId = 5 AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка. ok - lpUpdate_MI_PersonalService_SummAuditAdd   (%)   (%)'
         , (SELECT ValueData FROM MovementItemFloat where DescId = zc_MIFloat_SummSkip() and MovementItemId = 255446911)
         , (SELECT ValueData FROM MovementItemFloat where DescId = zc_MIFloat_DaySkip() and MovementItemId = 255446911)
;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.20         *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_PersonalService_SummAuditAdd (24770685 , 293425, 5)
