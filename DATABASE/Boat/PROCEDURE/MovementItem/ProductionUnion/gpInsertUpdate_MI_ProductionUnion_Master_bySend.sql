-- Function: gpInsertUpdate_MI_ProductionUnion_Master_bySend()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_bySend(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_bySend(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master_bySend(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Send        Integer   , -- 
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);

   --данные из документа перемещения
   CREATE TEMP TABLE _tmpSendMI (Comment TVarChar
                               , MovementId_OrderClient Integer
                               , ObjectId Integer
                               , Amount TFloat
                               ) ON COMMIT DROP;
    INSERT INTO _tmpSendMI (Comment,MovementId_OrderClient, ObjectId, Amount)
          SELECT tmp.Comment
               , tmp.MovementId_OrderClient
               , tmp.GoodsId  AS ObjectId
               , tmp.Amount
          FROM gpSelect_MovementItem_Send (inMovementId := inMovementId_Send :: Integer
                                         , inShowAll    := False             :: Boolean
                                         , inIsErased   := False             :: Boolean
                                         , inSession    := inSession         :: TVarChar) AS tmp;

   --сохраненные записи
   CREATE TEMP TABLE _tmpProductionUnionMI (Id Integer
                                          , MovementId_OrderClient Integer
                                          , ObjectId Integer
                                          , ReceiptProdModelId Integer
                                          , Amount TFloat
                                          , Comment TVarChar
                                           ) ON COMMIT DROP;
    INSERT INTO _tmpProductionUnionMI (Id, MovementId_OrderClient, ObjectId, ReceiptProdModelId, Amount, Comment )
          SELECT tmp.Id
               , tmp.MovementId_OrderClient
               , tmp.ObjectId
               , tmp.ReceiptProdModelId
               , tmp.Amount
               , tmp.Comment
          FROM gpSelect_MI_ProductionUnion_Master (inMovementId := inMovementId :: Integer
                                                 , inIsErased   := False             :: Boolean
                                                 , inSession    := inSession         :: TVarChar) AS tmp;
    
     -- сохраняем / перезаписываем <Элементы документа>
     PERFORM lpInsertUpdate_MovementItem_ProductionUnion (ioId                     := COALESCE (_tmpProductionUnionMI.Id,0)                           ::Integer
                                                        , inMovementId             := inMovementId
                                                        , inMovementId_OrderClient := COALESCE (_tmpSendMI.MovementId_OrderClient, _tmpProductionUnionMI.MovementId_OrderClient, inMovementId_OrderClient)   ::Integer
                                                        , inObjectId               := COALESCE (_tmpSendMI.ObjectId, _tmpProductionUnionMI.ObjectId)  ::Integer
                                                        , inReceiptProdModelId     := COALESCE (_tmpProductionUnionMI.ReceiptProdModelId, Null)       ::Integer
                                                        , inAmount                 := _tmpSendMI.Amount                                               ::TFloat
                                                        , inComment                := COALESCE (_tmpSendMI.Comment, _tmpProductionUnionMI.Comment)    ::TVarChar
                                                        , inUserId                 := vbUserId
                                                        )
      FROM _tmpSendMI
           LEFT JOIN _tmpProductionUnionMI ON _tmpProductionUnionMI.ObjectId = _tmpSendMI.ObjectId
      
     ;
     
     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.23         *
*/

-- тест
--