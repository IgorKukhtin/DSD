-- Function: gpInsertUpdate_MovementItem_LoyaltyChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loyalty_Accrual (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loyalty_Accrual(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbStartPromo TDateTime;
   DECLARE vbEndPromo TDateTime;
   DECLARE vbChangePercent TFloat;
   DECLARE vbServiceDate TDateTime;
   DECLARE vbOperDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbSum TFloat;
   DECLARE vbId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    SELECT Movement.InvNumber::Integer, Movement.StatusId,
           MovementDate_StartPromo.ValueData,
           MovementDate_EndPromo.ValueData,
           COALESCE(MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent,
           MovementDate_ServiceDate.ValueData                 AS ServiceDate
    INTO vbInvNumber, vbStatusId, vbStartPromo, vbEndPromo, vbChangePercent, vbServiceDate
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement.Id
                               AND MovementDate_StartPromo.DescID = zc_MovementDate_StartPromo()
         LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId = Movement.Id
                               AND MovementDate_EndPromo.DescID = zc_MovementDate_EndPromo()
         LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                ON MovementDate_ServiceDate.MovementId = Movement.Id
                               AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    WHERE Movement.ID = inMovementId;

    IF COALESCE(vbChangePercent, 0) = 0
    THEN
      RETURN;
    END IF;

    -- Если документ неподписан или неподходят даты то неформируем
    IF vbStatusId <> zc_Enum_Status_Complete() OR
       vbStartPromo > CURRENT_DATE OR
       vbEndPromo < CURRENT_DATE
    THEN
      RETURN;
    END IF;

    IF date_part('DAY', CURRENT_DATE)::Integer = 1
    THEN
      vbOperDate := DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '2 DAY');
    ELSE
      vbOperDate := DATE_TRUNC ('MONTH', CURRENT_DATE);
    END IF;
    vbDateStart := vbOperDate;

    IF vbDateStart < vbStartPromo
    THEN
      vbDateStart := vbStartPromo - INTERVAL '1 DAY';
    END IF;

    SELECT ROUND(SUM(MovementFloat_TotalSumm.ValueData) * vbChangePercent / 100, 2) AS vbSumm
    INTO vbSum
    FROM Movement

         INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         INNER JOIN MovementItem AS MI_Loyalty
                                 ON MI_Loyalty.MovementId = inMovementId
                                AND MI_Loyalty.DescId = zc_MI_Child()
                                AND MI_Loyalty.isErased = FALSE
                                AND MI_Loyalty.ObjectId = MovementLinkObject_Unit.ObjectId

     WHERE Movement.DescId = zc_Movement_Check()
       AND Movement.OperDate > vbDateStart
       AND Movement.OperDate < CURRENT_DATE;

      -- Сохранили дату пересчета
    IF vbServiceDate IS NULL OR vbServiceDate <> CURRENT_DATE
    THEN
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inMovementId, CURRENT_DATE);
    END IF;

      -- Наличие месячной суммы накопления
    IF EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                            INNER JOIN MovementItemDate AS MIDate_OperDate
                                                        ON MIDate_OperDate.MovementItemId = MI_Loyalty.Id
                                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                                       AND MIDate_OperDate.ValueData = vbOperDate
                       WHERE MI_Loyalty.MovementId = inMovementId
                         AND MI_Loyalty.DescId = zc_MI_Second())
    THEN
      SELECT MI_Loyalty.Id
      INTO vbID
      FROM MovementItem AS MI_Loyalty
           INNER JOIN MovementItemDate AS MIDate_OperDate
                                       ON MIDate_OperDate.MovementItemId = MI_Loyalty.Id
                                      AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                                      AND MIDate_OperDate.ValueData = vbOperDate
      WHERE MI_Loyalty.MovementId = inMovementId
        AND MI_Loyalty.DescId = zc_MI_Second();
    ELSE
      vbID := 0;
    END IF;

      -- сохранили <Элемент документа>
    vbID := lpInsertUpdate_MovementItem (vbID, zc_MI_Second(), Null, inMovementId, COALESCE(vbSum, 0), NULL, zc_Enum_Process_Auto_PartionClose());
      -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), vbID, vbOperDate);

    -- сохранили протокол
--    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.11.19                                                       *
*/

--
SELECT * FROM gpInsertUpdate_MovementItem_Loyalty_Accrual(16406918 , '3')