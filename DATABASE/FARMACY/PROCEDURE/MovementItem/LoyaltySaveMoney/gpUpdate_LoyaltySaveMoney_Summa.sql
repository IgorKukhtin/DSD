--- Function: gpUpdate_LoyaltySaveMoney_Summa()


DROP FUNCTION IF EXISTS gpUpdate_LoyaltySaveMoney_Summa (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_LoyaltySaveMoney_Summa(
    IN inMovementId  Integer      , -- ключ Чек
    IN inLoyaltySMID Integer      , -- ключ Соднржимое документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbRetailId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbTotalSumm TFloat;
    DECLARE vbMovementId  Integer;
    DECLARE vbSummaAccumulated TFloat;
    DECLARE vbStartPromo TDateTime;
    DECLARE vbEndPromo TDateTime;
    DECLARE vbChangePercent TFloat;
    DECLARE vbChangeSumma TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    -- Получить данные по чеку
    SELECT
        date_trunc('day', Movement.OperDate),
        Movement_Unit.ObjectId             AS UnitId,
        MovementFloat_TotalSumm.ValueData  AS TotalSumm
    INTO
        vbOperDate,
        vbUnitId,
        vbTotalSumm
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
    WHERE Movement.Id = inMovementId;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    IF EXISTS(SELECT Movement.Id
              FROM MovementItem

                  INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                                     AND Movement.DescId = zc_Movement_LoyaltySaveMoney()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()

                  INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                ON MovementLinkObject_Retail.MovementId = Movement.Id
                                               AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                               AND MovementLinkObject_Retail.ObjectId = vbRetailId

              WHERE MovementItem.Id = inLoyaltySMID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN

      SELECT Movement.Id
          , (MovementItem.Amount -
             COALESCE(MIFloat_Summ.ValueData, 0))::TFloat                  AS SummaAccumulated
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
      INTO vbMovementId, vbSummaAccumulated, vbStartPromo, vbEndPromo
      FROM MovementItem

          INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                             AND Movement.DescId = zc_Movement_LoyaltySaveMoney()

          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

          LEFT JOIN MovementDate AS MovementDate_StartPromo
                                 ON MovementDate_StartPromo.MovementId = Movement.Id
                                AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
          LEFT JOIN MovementDate AS MovementDate_EndPromo
                                 ON MovementDate_EndPromo.MovementId = Movement.Id
                                AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

      WHERE MovementItem.Id = inLoyaltySMID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased = FALSE;

      vbChangeSumma := 0;
      IF vbStartPromo <= vbOperDate AND vbEndPromo >= vbOperDate AND vbTotalSumm > 0
      THEN

        SELECT MIFloat_ChangePercent.ValueData  AS ChangePercent
        INTO vbChangePercent
        FROM MovementItem

             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

        WHERE MovementItem.MovementId = vbMovementId
          AND MovementItem.DescId = zc_MI_Sign()
          AND MovementItem.Amount <= vbTotalSumm
          AND MovementItem.isErased = FALSE
        ORDER BY MovementItem.Amount DESC
        LIMIT 1;

        vbChangeSumma := COALESCE(ROUND(vbTotalSumm * vbChangePercent / 100, 2), 0);
      END IF;
    ELSE
      vbChangeSumma := 0;
    END IF;

    IF vbChangeSumma <> 0
    THEN
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LoyaltySMSumma(), inMovementId, vbChangeSumma);
      UPDATE MovementItem SET Amount = Amount + vbChangeSumma WHERE MovementItem.ID = inLoyaltySMID;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.01.20                                                       *
*/

-- select * from  gpUpdate_LoyaltySaveMoney_Summa (17449617, 310220361, '3')