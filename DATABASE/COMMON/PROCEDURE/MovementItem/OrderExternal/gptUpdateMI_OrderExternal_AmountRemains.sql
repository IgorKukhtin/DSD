-- Function: gptUpdateMI_OrderExternal_AmountRemains()

--DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountRemains (Integer,TDateTime, Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountRemains (Integer,TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gptUpdateMI_OrderExternal_AmountRemains(
 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
   -- IN inPriceListId         Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS--RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());

    -- таблица -
    CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer_Count (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (GoodsId Integer, GoodsKindId Integer, Amount_Start TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount_Start TFloat, Amount TFloat) ON COMMIT DROP;
    
   INSERT INTO tmpGoods (GoodsId) SELECT Id FROM Object WHERE DescId = zc_Object_Goods();
   INSERT INTO tmpContainer_Count (ContainerId, GoodsId, GoodsKindId, Amount)
                            SELECT Container.Id AS ContainerId 
                                     , Container.ObjectId AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                   AND CLO_Unit.ObjectId = inFromId
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind();

       INSERT INTO tmpContainer ( GoodsId, GoodsKindId, Amount_Start)
                                  SELECT 
                                           tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_Start
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inOperDate
                                  GROUP BY tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  Having  (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0))>0
                                   ;      
          INSERT INTO tmpAll ( MovementItemId, GoodsId, GoodsKindId, Amount_Start, Amount)
                      SELECT tmp.MovementItemId
                                       , COALESCE (tmp.GoodsId,tmpContainer.GoodsId) as GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpContainer.GoodsKindId) GoodsKindId
                                       , tmpContainer.Amount_Start
                                       , tmp.Amount
                                  From tmpContainer
                              Full Join 

                                (SELECT MovementItem.Id                 AS MovementItemId 
                                      , MovementItem.ObjectId           AS GoodsId
                                      , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                                      , MovementItem.Amount
                                 FROM  MovementItem 
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 Where MovementItem.MovementId = InMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = False
                                ) as tmp  ON tmp.GoodsId = tmpContainer.GoodsId
                                         AND tmp.GoodsKindId = tmpContainer.GoodsKindId
                                      ;                                              
                                       
--  RAISE EXCEPTION 'Ошибка.';
     -- сохранили
       PERFORM lpUpdate_MovementItem_OrderExternal ( inId                 := Coalesce(tmpAll.MovementItemId,0)::Integer
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := tmpAll.GoodsId
                                                   , inGoodsKindId        := Coalesce(tmpAll.GoodsKindId,0)::Integer
                                                   , inAmount             := Coalesce(tmpAll.Amount,0)::TFloat
                                                   , inAmountRemains      := Coalesce(tmpAll.Amount_Start,0)::TFloat
                                                   , inUserId             := vbUserId
                                                    ) 
                      FROM tmpAll;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.15         *
*/

-- тест
-- SELECT * FROM gptUpdateMI_OrderExternal_AmountRemains (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
