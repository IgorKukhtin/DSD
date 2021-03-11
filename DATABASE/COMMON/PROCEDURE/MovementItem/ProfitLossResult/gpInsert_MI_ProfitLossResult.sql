-- Function: gpInsertUpdate_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpInsert_MI_ProfitLossResult (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_ProfitLossResult(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inAccountId             Integer   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProfitLossResult());

     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_ProfitLossResult (ioId          := tmp.Id          ::Integer
                                                         , inMovementId  := inMovementId    ::Integer
                                                         , inAccountId   := tmp.AccountId   ::Integer
                                                         , inAmount      := tmp.Amount      ::TFloat
                                                         , inContainerId := tmp.ContainerId ::TFloat
                                                         , inUserId      := vbUserId        ::Integer
                                                          ) 
     FROM (WITH
           tmpContainer AS (SELECT tmp.ContainerId
                                 , tmp.AccountId
                                 , SUM (tmp.Amount) AS Amount
                            FROM (SELECT Container.Id       AS ContainerId
                                       , Container.ObjectId AS AccountId
                                       , COALESCE (Container.Amount,0) - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                                  FROM Container 
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container.Id
                                                                      -- !!!на конец дня!!!
                                                                      AND MIContainer.OperDate > vbOperDate
                                  WHERE Container.DescId = zc_Container_Summ()
                                    AND Container.ObjectId = zc_Enum_Account_100301()
                                    --AND COALESCE (Container.Amount,0) <> 0
                                  GROUP BY Container.ObjectId
                                         , Container.Id
                                         , Container.Amount
                                  HAVING (COALESCE (Container.Amount,0) - SUM (COALESCE (MIContainer.Amount,0))) <> 0
                                  ) AS tmp
                            GROUP BY tmp.ContainerId
                                   , tmp.AccountId
                            )
         , tmpMI AS (SELECT MovementItem.Id
                          , MovementItem.ObjectId AS AccountId
                          , MovementItem.Amount
                          , CAST (MIFloat_ContainerId.ValueData AS NUMERIC (16,0)) AS ContainerId
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                      ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                     )
           SELECT COALESCE (tmpMI.Id,0) AS Id
                , COALESCE (tmpMI.AccountId, tmpContainer.AccountId)     AS AccountId
                , COALESCE (tmpMI.ContainerId, tmpContainer.ContainerId) AS ContainerId
                , COALESCE (tmpContainer.Amount, tmpMI.Amount)           AS Amount
           FROM tmpContainer
                FULL JOIN tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId             
           ) AS tmp
     ;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
--