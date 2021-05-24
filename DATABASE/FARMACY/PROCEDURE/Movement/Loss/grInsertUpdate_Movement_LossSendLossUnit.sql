  -- Function: grInsertUpdate_Movement_LossSendLossUnit()

  DROP FUNCTION IF EXISTS grInsertUpdate_Movement_LossSendLossUnit (Integer, TVarChar);

  CREATE OR REPLACE FUNCTION grInsertUpdate_Movement_LossSendLossUnit(
      IN inUnitID              Integer  , -- Подразделение
      IN inSession             TVarChar   -- пользователь
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbUserId         Integer;
     DECLARE vbMovementLossId Integer;
     DECLARE vbStatusId       Integer;
  BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

      -- Временная таблица для товаров по переводу
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovementSendLoss'))
    THEN
      CREATE TEMP TABLE _tmpMovementSendLoss (
        GoodsId             Integer,
        Amount              TFloat
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM _tmpMovementSendLoss;
    END IF;

      -- Заполняем временную таблицу для товаров по переводу
    WITH
         -- просрочка
         tmpMovementSend AS (SELECT Movement.id
                                  , MovementItem.ObjectId                   AS GoodsId 
                                  , MovementItem.Amount
                             FROM Movement 
                                  INNER JOIN MovementBoolean AS MovementBoolean_SendLoss
                                                             ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                                            AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()
                                                            AND MovementBoolean_SendLoss.ValueData = TRUE
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.Amount > 0
                                                         AND MovementItem.isErased = FALSE 
                              WHERE Movement.OperDate BETWEEN date_trunc('month', CURRENT_DATE) AND date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'  
                                AND Movement.DescId = zc_Movement_Send() 
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (MovementLinkObject_From.ObjectId =  inUnitID
                                  OR MovementLinkObject_To.ObjectId = inUnitID))

    INSERT INTO _tmpMovementSendLoss (GoodsId, Amount)
    SELECT tmpMovementSend.GoodsId
         , Sum(tmpMovementSend.Amount)
    FROM tmpMovementSend
    GROUP BY tmpMovementSend.GoodsId
    HAVING  Sum(tmpMovementSend.Amount) > 0;
    
    IF EXISTS(SELECT Movement.Id
              FROM Movement 

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_UNit.DescId     = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId   = inUnitID

                   INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                 ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                AND MovementLinkObject_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()
                                                AND MovementLinkObject_ArticleLoss.ObjectId   = 13892113

              WHERE Movement.DescId = zc_Movement_Loss()
                AND Movement.StatusId <> zc_Enum_Status_Erased()
                AND Movement.OperDate = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
    THEN
      SELECT Movement.Id, Movement.StatusId
      INTO vbMovementLossId, vbStatusId
      FROM Movement 

           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId     = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId   = inUnitID

           INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()
                                        AND MovementLinkObject_ArticleLoss.ObjectId   = 13892113

      WHERE Movement.DescId = zc_Movement_Loss()
        AND Movement.StatusId <> zc_Enum_Status_Erased()
        AND Movement.OperDate = date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
       
      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
        PERFORM gpUnComplete_Movement_Loss (inMovementId  := vbMovementLossId
                                          , inSession     := inSession);
      END IF;
      
    ELSE 
      vbMovementLossId := 0;
    END IF;
    
    IF EXISTS(SELECT 1 FROM  _tmpMovementSendLoss)
    THEN
      -- сохранили <Документ>
      IF COALESCE (vbMovementLossId, 0) = 0
      THEN
        vbMovementLossId := lpInsertUpdate_Movement_Loss (ioId                 := 0
                                                        , inInvNumber          := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                                        , inOperDate           := date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                        , inUnitId             := inUnitId
                                                        , inArticleLossId      := 13892113
                                                        , inComment            := ''
                                                        , inConfirmedMarketing := ''
                                                        , inUserId             := vbUserId
                                                         );
      END IF;

      PERFORM lpInsertUpdate_MovementItem_Loss (ioId                := COALESCE (MovementItem.MovementId, 0)
                                              , inMovementId        := vbMovementLossId
                                              , inGoodsId           := _tmpMovementSendLoss.GoodsId
                                              , inAmount            := _tmpMovementSendLoss.Amount
                                              , inUserId            := vbUserId)
      FROM _tmpMovementSendLoss
        
           LEFT JOIN MovementItem ON MovementItem.MovementId = vbMovementLossId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.ObjectId   = _tmpMovementSendLoss.GoodsId;

      -- Проводим списание
      PERFORM gpComplete_Movement_Loss (inMovementId:= vbMovementLossId, inIsCurrentData:= False, inSession:= inSession);
    END IF;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.05.21                                                         *
   */

-- тест 
-- SELECT * FROM grInsertUpdate_Movement_LossSendLossUnit (inUnitID := 11152911, inSession:= '3')