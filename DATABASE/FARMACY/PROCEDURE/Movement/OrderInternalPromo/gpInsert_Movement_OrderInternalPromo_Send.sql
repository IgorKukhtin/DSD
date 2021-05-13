  -- Function: gpInsert_Movement_OrderInternalPromo_Send()

  DROP FUNCTION IF EXISTS gpInsert_Movement_OrderInternalPromo_Send (Integer, Integer, TVarChar);

  CREATE OR REPLACE FUNCTION gpInsert_Movement_OrderInternalPromo_Send(
      IN inMovementId          Integer  , -- Документ
      IN inUnitId              Integer  , -- Аодразделение
      IN inSession             TVarChar   -- пользователь
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbUserId Integer;
     DECLARE vbMovementID Integer;
     DECLARE vbOperDate TDateTime;
     DECLARE vbInvNumber TVarChar;
  BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    -- данные из шапки документа
    SELECT Movement.Invnumber
    INTO vbInvnumber
    FROM Movement
    WHERE Movement.Id = inMovementId;

      -- Временная таблица для товаров
    CREATE TEMP TABLE tmpMovementItem ON COMMIT DROP AS (
        WITH
        tmpMovementItem AS (SELECT MovementItem.ObjectId            AS UnitID
                                 , MI_Master.ObjectId               AS GoodsId
                                 , MovementItem.Amount              AS Amount
                                 , MI_Master.Amount                 AS Saldo
                                 , SUM (MovementItem.Amount) OVER (PARTITION BY MI_Master.ObjectId  ORDER BY MovementItem.ObjectId) AS AmountSUM
                                 , ROW_NUMBER() OVER (PARTITION BY MI_Master.ObjectId ORDER BY MovementItem.ObjectId) AS Ord
                            FROM MovementItem
                                 LEFT JOIN MovementItem AS MI_Master
                                                        ON MI_Master.Id = MovementItem.ParentId

                            WHERE MovementItem.MovementId = 18897982 -- inMovementId
                              AND MovementItem.DescId = zc_MI_Child()
                              AND MovementItem.isErased = FALSE
                              AND MovementItem.Amount > 0)

        SELECT MovementItem.UnitID
             , MovementItem.GoodsId
             , CASE WHEN MovementItem.AmountSUM < MovementItem.Saldo THEN MovementItem.Amount
                    WHEN (MovementItem.Saldo - COALESCE(MI_Prew.AmountSUM, 0)) > 0 THEN MovementItem.Saldo - COALESCE(MI_Prew.AmountSUM, 0)
                    ELSE 0 END AS Amount
        FROM tmpMovementItem AS MovementItem
             LEFT JOIN tmpMovementItem AS MI_Prew
                                       ON MI_Prew.GoodsId = MovementItem.GoodsId
                                      AND MI_Prew.Ord = (MovementItem.Ord - 1)
        ORDER BY MovementItem.GoodsId, MovementItem.UnitID);


      -- Временная таблица для подразделений
    CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS (
        WITH
        tmpUnit AS (SELECT DISTINCT MovementItem.UnitID
                    FROM tmpMovementItem AS MovementItem)

        SELECT Unit.UnitID
             , gpInsertUpdate_Movement_Send(ioId               := 0,
                                            inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar),
                                            inOperDate         := CURRENT_DATE,
                                            inFromId           := inUnitID,
                                            inToId             := Unit.UnitID,
                                            inComment          := 'Сформировано из Заявки внутренние (маркет-товары) '||vbInvnumber,
                                            inChecked          := FALSE,
                                            inisComplete       := FALSE,
                                            inNumberSeats      := 0,
                                            inDriverSunId      := 0,
                                            inSession          := inSession
                                            ) AS MovementID
        FROM tmpUnit AS Unit
        ORDER BY Unit.UnitID);

    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := 0,
                                              inMovementId           := tmpUnit.MovementID,
                                              inGoodsId              := tmpMovementItem.GoodsId,
                                              inAmount               := tmpMovementItem.Amount,
                                              inAmountManual         := 0,
                                              inAmountStorage        := 0,
                                              inReasonDifferencesId  := 0,
                                              inCommentSendID        := 0,  
                                              inUserId               := vbUserId)
    FROM tmpMovementItem
         INNER JOIN tmpUnit ON tmpUnit.UnitID = tmpMovementItem.UnitID;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.05.20                                                        *
   */

-- тест SELECT * FROM gpInsert_Movement_OrderInternalPromo_Send (18897982, 2886778, '3')