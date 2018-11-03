-- Function: gpInsert_LockUnique_byUnion()

DROP FUNCTION IF EXISTS gpInsert_LockUnique_byUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_LockUnique_byUnion(
    IN inMovementId      Integer,    -- Id документа
   OUT outMessageText    Text      ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Text
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);
      
      
      vbMovementId := (SELECT DISTINCT LockUnique.KeyData ::Integer AS Id
                       FROM LockUnique 
                       WHERE LockUnique.UserId = vbUserId
                       LIMIT 1);
        
      IF COALESCE (vbMovementId, 0) <> 0
      THEN
          outMessageText:= (SELECT 'Док № '||tmpNew.InvNumber||' от '||tmpNew.OperDate||' нельзя объединить т.к. партия должна быть = '||tmp.PartionGoods|| ', От кого = '||tmp.FromName|| ', товар должен быть = '||tmp.GoodName
                            FROM (SELECT DISTINCT
                                          MovementLinkObject_From.ObjectId         AS FromId
                                        , Object_From.ValueData                    AS FromName
                                        , MovementString_PartionGoods.ValueData    AS PartionGoods
                                        , MovementItem.ObjectId                    AS GoodsId
                                        , Object_Goods.ValueData                   AS GoodName
                                   FROM Movement
                                      LEFT JOIN MovementString AS MovementString_PartionGoods
                                                               ON MovementString_PartionGoods.MovementId = Movement.Id
                                                              AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
   
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
   
                                      JOIN MovementItem ON MovementItem.MovementId = vbMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE 
                                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
   
                                   WHERE Movement.Id = vbMovementId
                                     AND Movement.DescId = zc_Movement_ProductionSeparate()
                                     -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   ) AS tmp                                                --данные по уже записанному документу
                                    LEFT JOIN (SELECT DISTINCT
                                                      Movement.OperDate
                                                    , Movement.InvNumber
                                                    , MovementLinkObject_From.ObjectId         AS FromId
                                                    , MovementString_PartionGoods.ValueData    AS PartionGoods
                                                    , MovementItem.ObjectId                    AS GoodsId
                                               FROM Movement
                                                  LEFT JOIN MovementString AS MovementString_PartionGoods
                                                                           ON MovementString_PartionGoods.MovementId = Movement.Id
                                                                          AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE 
                                               WHERE Movement.Id = inMovementId
                                                 AND Movement.DescId = zc_Movement_ProductionSeparate()
                                                 -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                 ) AS tmpNew ON 1 = 1                                          --данные по новому документу               
                            WHERE tmp.FromId <> tmpNew.FromId
                               OR tmp.PartionGoods <> tmpNew.PartionGoods
                               OR tmp.GoodsId <> tmpNew.GoodsId);
          --если сообщение не пустое выходим
          IF outMessageText <> '' THEN RETURN; END IF;
      END IF;
                     
      -- сохраняем Ид документов  табл. LockUnique
      INSERT INTO LockUnique (KeyData, UserId, OperDate)
             VALUES (inMovementId :: TVarChar, vbUserId, CURRENT_DATE);   --CURRENT_TIMESTAMP

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.18         *
*/

-- тест
-- SELECT * FROM gpInsert_LockUnique_byUnion (inMovementId:= 56464, inSession:= '2')
