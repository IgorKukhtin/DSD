-- Function: gpInsertUpdate_MovementItem_Inventory_Amount (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

         -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId              := COALESCE (tmp.MovementItemId,0)
                                               , inMovementId         := inMovementId
                                               , inGoodsId            := tmp.GoodsId
                                               , inAmount             := COALESCE (tmp.Amount_Start,0)
                                               , inPartionGoodsDate   := NULL
                                               , inPrice              := 0::TFloat
                                               , inSumm               := 0::TFloat
                                               , inHeadCount          := 0::TFloat
                                               , inCount              := 0::TFloat
                                               , inPartionGoods       := NULL
                                               , inGoodsKindId        := COALESCE (tmp.GoodsKindId, NULL)
                                               , inAssetId            := NULL
                                               , inUnitId             := NULL
                                               , inStorageId          := NULL
                                               , inUserId             := vbUserId


                                                       )
     FROM (SELECT COALESCE(tmpContainer.Amount_Start,0)                   AS Amount_Start
                , COALESCE(tmpContainer.GoodsId, tmpMI.GoodsId)           AS GoodsId
                , COALESCE(tmpContainer.GoodsKindId, tmpMI.GoodsKindId)   AS GoodsKindId
                , tmpMI.MovementItemId                                    AS MovementItemId
                
           FROM (SELECT Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_Start
                      , Container.ObjectId                                          AS GoodsId
                      , CLO_GoodsKind.ObjectId                                      AS GoodsKindId
                      --, tmpMI.MovementItemId                                        AS MovementItemId
                FROM Movement
                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 
                    INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                   ON CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                  AND CLO_Unit.ObjectId = MovementLinkObject_From.ObjectId   --From UnitId
        
                    INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                        AND Container.DescId = zc_Container_Count()
                                
                    INNER JOIN MovementItemContainer AS MIContainer
                                                    ON MIContainer.ContainerId = Container.Id
                                                   AND MIContainer.OperDate >= Movement.operdate

                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                  ON CLO_GoodsKind.ContainerId = Container.Id
                                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                    WHERE Movement.Id =  inMovementId
                    GROUP BY Container.ObjectId 
                           , Container.Amount
                           , CLO_GoodsKind.ObjectId 
                    HAVING ( Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0) )<>0
                   ) tmpContainer  
                                             
            FULL JOIN (SELECT MovementItem.ObjectId           AS GoodsId
                            , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                            , MovementItem.Id                 AS MovementItemId
                       FROM  Movement
                             INNER JOIN MovementItem ON Movement.id = MovementItem.MovementId
                                                   AND MovementItem.isErased = False
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                       WHERE Movement.Id =  inMovementId
                       ) as tmpMI ON tmpMI.GoodsId = tmpContainer.GoodsId
                                 AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId 
           
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.04.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Amount


--select * from gpInsertUpdate_MovementItem_Inventory_Amount(inMovementId := 786187 ,  inSession := '5');

              