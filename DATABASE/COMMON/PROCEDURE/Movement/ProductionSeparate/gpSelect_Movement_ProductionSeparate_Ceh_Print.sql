-- Function: gpSelect_Movement_ProductionSeparate_Ceh_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Ceh_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Ceh_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inMovementId_Weighing        Integer  , -- ключ Документа взвешивания
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
       INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );
                         

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



    --
    OPEN Cursor1 FOR

    WITH tmpMIMaster AS (SELECT MAX (MovementItem.ObjectId)                     AS GoodsId
                              , SUM (MovementItem.Amount)                       AS Count
                              , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                              , MAX (COALESCE (MILinkObject_StorageLine.ObjectId, 0)) AS StorageLineId
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                          ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                               ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                        )
       , tmpMIChild AS (SELECT SUM (MovementItem.Amount)  AS Count_Child
                        FROM MovementItem
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Child()
                          AND MovementItem.isErased   = FALSE
                       )
       , tmpMovementWeighing AS (SELECT Movement.Id AS MovementId
                                      , MFloat_WeighingNumber.ValueData AS WeighingNumber
                                 FROM Movement
                                      LEFT JOIN MovementFloat AS MFloat_WeighingNumber
                                                              ON MFloat_WeighingNumber.MovementId = Movement.Id
                                                             AND MFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                 WHERE Movement.ParentId = inMovementId
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                )
       , tmpMIWeighing AS (SELECT CASE WHEN inMovementId_Weighing > 0 THEN tmpMovementWeighing.WeighingNumber ELSE 0 END AS WeighingNumber
                                , SUM (MovementItem.Amount) AS Count
                           FROM tmpMovementWeighing
                               LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                       ON MovementBoolean_isIncome.MovementId = tmpMovementWeighing.MovementId
                                      AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
                                      --AND MovementBoolean_isIncome.ValueData = FALSE
                               LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovementWeighing.MovementId
                                                      AND MovementItem.isErased  = FALSE
                                                      AND MovementBoolean_isIncome.ValueData = FALSE
                           WHERE tmpMovementWeighing.MovementId = inMovementId_Weighing
                              OR COALESCE (inMovementId_Weighing, 0) = 0
                           GROUP BY CASE WHEN inMovementId_Weighing > 0 THEN tmpMovementWeighing.WeighingNumber ELSE 0 END
                          )

        -- Результат - Мастер (1 строка)
        SELECT
           Movement.InvNumber                 AS InvNumber
         , Movement.OperDate                  AS OperDate

         , MovementString_PartionGoods.ValueData AS PartionGoods

         , Object_From.ValueData                AS FromName
         , Object_To.ValueData                  AS ToName

         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , tmpMIMaster.Count
         , tmpMIMaster.HeadCount
         , CASE WHEN tmpMIMaster.Count <> 0 THEN tmpMIChild.Count_Child / tmpMIMaster.Count ELSE 0 END :: TFloat AS PersentVyhod
         , tmpCount.Count :: TFloat       AS TotalNumber
         , tmpMIWeighing.WeighingNumber   AS WeighingNumber
         , tmpMIWeighing.Count ::  TFloat AS CountWeighing

           -- Есть ли в Мастере - Производственные линии
         , (EXISTS (SELECT 1 FROM tmpMIMaster WHERE tmpMIMaster.StorageLineId <> 0 AND tmpMIMaster.Count <> 0)) :: Boolean AS isStorageLine

         , vbStoreKeeperName AS StoreKeeper   -- кладовщик
     FROM Movement
          LEFT JOIN (SELECT COUNT(*) AS Count from tmpMovementWeighing) AS tmpCount ON 1 = 1
          LEFT JOIN  tmpMIWeighing ON 1 = 1

          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN tmpMIMaster ON 1 = 1
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIMaster.GoodsId
          LEFT JOIN tmpMIChild ON 1 = 1

       WHERE Movement.Id = inMovementId
         AND Movement.StatusId <> zc_Enum_Status_Erased()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpWeighing AS (-- Данные по элементам взвешивания
                          SELECT MovementItem.ObjectId             AS GoodsId
                               , COALESCE (MILinkObject_StorageLine.ObjectId, 0) AS StorageLineId
                               , SUM (MovementItem.Amount)         AS Count
                               , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                          FROM (SELECT Movement.Id AS MovementId
                                FROM Movement
                                WHERE Movement.ParentId = inMovementId
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               ) AS tmp
                              INNER JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = tmp.MovementId
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
                                     AND MovementBoolean_isIncome.ValueData = TRUE
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                     AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                          ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                               ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                          WHERE tmp.MovementId = inMovementId_Weighing
                             OR COALESCE (inMovementId_Weighing, 0) = 0
                          GROUP BY MovementItem.ObjectId
                                 , MILinkObject_StorageLine.ObjectId
                         )
       -- Результат - Все элементы
       SELECT Object_Goods.ObjectCode  			  AS GoodsCode
            , Object_Goods.ValueData   			  AS GoodsName    
            , CASE WHEN ObjectLink_GoodsGroup.ChildObjectId = 1918 THEN Object_GoodsGroup.ObjectCode ELSE 0 END ::Integer AS GoodsGroupCode
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_StorageLine.ObjectCode               AS StorageLineCode
            , Object_StorageLine.ValueData                AS StorageLineName
            , Object_Measure.ValueData                    AS MeasureName
            , Object_GoodsKind.ValueData                  AS GoodsKindName
            , tmpMI.Amount                      :: TFloat AS Amount
            , tmpMI.LiveWeight                  :: TFloat AS LiveWeight
            , tmpMI.HeadCount                   :: TFloat AS HeadCount

            , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.Amount ELSE 0 END                                    :: TFloat AS Amount_Sh
            , (tmpMI.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) :: TFloat AS Amount_Weight

            , tmpWeighing.Count                 :: TFloat AS WeighingCount
            , tmpWeighing.HeadCount             :: TFloat AS HeadCount_item

       FROM (SELECT MovementItem.ObjectId                            AS GoodsId
                  , COALESCE (MILinkObject_StorageLine.ObjectId, 0)  AS StorageLineId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId,0)     AS GoodsKindId
                  , SUM (MovementItem.Amount)                        AS Amount
                  , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) AS LiveWeight
                  , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))  AS HeadCount
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                   ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                  LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                              ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE
               AND MovementItem.Amount <> 0
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_StorageLine.ObjectId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
            ) AS tmpMI
            FULL JOIN tmpWeighing ON tmpWeighing.GoodsId       = tmpMI.GoodsId
                                 AND tmpWeighing.StorageLineId = tmpMI.StorageLineId

            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = COALESCE (tmpMI.GoodsId, tmpWeighing.GoodsId)
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = COALESCE (tmpMI.StorageLineId, tmpWeighing.StorageLineId)
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            --сортировка по коду группы
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()

      ;

    RETURN NEXT Cursor2;

    --
    OPEN Cursor3 FOR
       SELECT Object_Goods.Id   			  AS GoodsId
            , Object_Goods.ObjectCode  			  AS GoodsCode
            , Object_Goods.ValueData   			  AS GoodsName
            , Object_StorageLine.ObjectCode               AS StorageLineCode
            , Object_StorageLine.ValueData                AS StorageLineName
            , SUM (MovementItem.Amount)                   AS Amount
       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = MovementItem.ObjectId
            LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = MILinkObject_StorageLine.ObjectId
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND MovementItem.Amount <> 0
       GROUP BY Object_Goods.Id
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
              , Object_StorageLine.ObjectCode
              , Object_StorageLine.ValueData
               ;
    --
    RETURN NEXT Cursor3;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_ProductionSeparate_Ceh_Print'
               -- ProtocolData
             , inMovementId          :: TVarChar
    || ', ' || inMovementId_Weighing :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionSeparate_Ceh_Print (Integer,Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.06.15         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_ProductionSeparate_Ceh_Print (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
