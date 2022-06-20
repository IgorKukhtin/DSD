-- Function: gpUpdateMIChild_OrderExternal_Amount()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_Amount (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_Amount(
    IN inMovementId      Integer      , -- ключ Документа
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbToId Integer;
BEGIN
--return;
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());


      -- Проверка - что б не копировали два раза
      /*IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.'; 
      END IF;
      */
      
     -- данные из документа 
      SELECT Movement.OperDate                 AS OperDate
           , MLO_To.ObjectId                   AS ToId
         INTO  vbOperDate, vbToId
      FROM Movement 
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
      WHERE Movement.Id = inMovementId;
               
       -- данные из мастера + остатки и данные из чайлдов др. док.
       CREATE TEMP TABLE tmpMIMaster (Id Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Remains TFloat) ON COMMIT DROP;
       INSERT INTO tmpMIMaster (Id, GoodsId, GoodsKindId, Amount, Remains)                    
  
        WITH
        tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       , MovementItem.Amount
                  FROM MovementItem   
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  ) 
        -- ВСЕ заявки в которых есть zc_MI_Child.Amount за этот день 
      , tmpMIChild_All AS (SELECT MovementItem.ObjectId                         AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                , SUM (COALESCE (MovementItem.Amount,0))        AS Amount
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = Movement.Id
                                                             AND MLO_To.DescId = zc_MovementLinkObject_To()
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Child()
                                                       AND MovementItem.isErased = FALSE
                                                       AND COALESCE (MovementItem.Amount,0) <> 0
                                INNER JOIN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           WHERE Movement.OperDate = vbOperDate
                             AND Movement.DescId = zc_Movement_OrderExternal()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND MLO_To.ObjectId = vbToId
                             AND Movement.Id <> inMovementId
                           GROUP BY MovementItem.ObjectId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                           )                    
        -- Остатки
      , tmpContainer AS (SELECT Container.Id AS ContainerId
                              , Container.ObjectId AS GoodsId
                              , Container.Amount
                         FROM Container
                              INNER JOIN ContainerLinkObject AS CLO_Unit
                                                             ON CLO_Unit.ContainerId = Container.Id
                                                            AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                            AND CLO_Unit.ObjectId = vbToId
                              INNER JOIN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
  
                              LEFT JOIN ContainerLinkObject AS CLO_Account
                                                            ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                           AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                         WHERE Container.DescId = zc_Container_Count()
                           AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                         )
      , tmpCLO_GoodsKind_rem AS (SELECT CLO_GoodsKind.*
                                 FROM ContainerLinkObject AS CLO_GoodsKind
                                 WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                )

      , tmpRemains AS (SELECT tmpContainer.GoodsId
                            , COALESCE (CLO_GoodsKind.ObjectId, 0)   AS GoodsKindId
                            , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount --на начало дня
                       FROM tmpContainer
                            LEFT JOIN tmpCLO_GoodsKind_rem AS CLO_GoodsKind
                                                           ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate >= vbOperDate
                       GROUP BY tmpContainer.GoodsId
                              , COALESCE (CLO_GoodsKind.ObjectId, 0)
                              , tmpContainer.Amount
                       HAVING SUM (COALESCE (tmpContainer.Amount,0)) <> 0
                       )

         SELECT tmpMI.Id 
              , tmpMI.GoodsId
              , tmpMI.GoodsKindId
              , tmpMI.Amount
              --, (COALESCE (tmpRemains.Amount,0) - COALESCE (tmpMIChild_All.Amount,0)) AS Amount_diff 
              , COALESCE (tmpRemains.Amount,0)                                        AS Remains
         FROM tmpMI
              LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId
                                  AND tmpRemains.GoodsKindId = tmpMI.GoodsKindId
              LEFT JOIN tmpMIChild_All ON tmpMIChild_All.GoodsId = tmpMI.GoodsId
                                      AND tmpMIChild_All.GoodsKindId = tmpMI.GoodsKindId

         ;


   -- сохранили
   PERFORM lpInsertUpdate_MI_OrderExternal_Child (ioId                 := COALESCE (MovementItem.Id, 0) :: integer
                                                , inParentId           := tmpMIMaster.Id
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := tmpMIMaster.GoodsId 
                                                                       -- если Остаток > итого в заявке, тогда zc_MI_Child.Amount =  итого в заявке ИНАЧЕ Остаток + в этой проц обнуляем все zc_MI_Child.AmountSecond
                                                , inAmount             := CASE WHEN COALESCE (tmpMIMaster.Remains,0) > COALESCE (tmpMIMaster.Amount,0) THEN COALESCE (tmpMIMaster.Amount,0) ELSE COALESCE (tmpMIMaster.Remains,0) END :: TFloat  
                                                , inAmountSecond       := 0 :: TFloat 
                                                , inGoodsKindId        := tmpMIMaster.GoodsKindId 
                                                , inMovementId_Send    := 0
                                                , inUserId             := vbUserId
                                                )
     FROM tmpMIMaster
          LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId = zc_MI_Child()
                                AND MovementItem.isErased = FALSE
                                AND MovementItem.ParentId = tmpMIMaster.Id     
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И..
 18.06.22         *
*/

-- тест