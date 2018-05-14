-- Function: gpReport_OrderExternal_Sale()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Sale_Mobile (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Sale_Mobile(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inFromId             Integer   , -- От кого (в документе)
    IN inToId               Integer   , -- Кому (в документе)
    IN inRouteId            Integer   , -- Маршрут
    IN inRouteSortingId     Integer   , -- Сортировки маршрутов
    IN inGoodsGroupId       Integer   ,
    IN inIsByDoc            Boolean   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, OperDatePartner TDateTime
             , InvNumber TVarChar, InvNumberOrderPartner TVarChar
             , FromDescName TVarChar, FromId Integer, FromCode Integer, FromName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, Article TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , AmountSumm1 TFloat, AmountSumm2 TFloat, AmountSummTotal TFloat, AmountSumm_Dozakaz TFloat
             , Amount_Weight1 TFloat, Amount_Sh1 TFloat
             , Amount_Weight2 TFloat, Amount_Sh2 TFloat
             , Amount_Weight_Itog TFloat, Amount_Sh_Itog TFloat
             , Amount_Weight_Dozakaz TFloat, Amount_Sh_Dozakaz TFloat
             , Amount12 TFloat, Amount_WeightSK TFloat
             , AmountSale_Weight TFloat, AmountSale_Sh TFloat
             , PriceSale TFloat, SumSale TFloat
             , InfoMoneyName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN

     -- Ограничения по товарам
     CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
     IF inGoodsGroupId <> 0
     THEN
         INSERT INTO _tmpGoods (GoodsId)
            SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
     ELSE
         INSERT INTO _tmpGoods (GoodsId)
            SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods();
     END IF;
 
 
     -- определяем Контрагентов, которых может смотреть Агент
     CREATE TEMP TABLE _tmpPartner (Id Integer) ON COMMIT DROP;
     INSERT INTO _tmpPartner (Id)
         SELECT tmp.Id
         FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS tmp
         WHERE (tmp.Id = COALESCE (inFromId, 0)) 
             OR COALESCE (inFromId, 0) = 0 ;
         
     -- Проверка
     IF NOT EXISTS (SELECT _tmpPartner.Id FROM _tmpPartner WHERE _tmpPartner.Id = inFromId) AND COALESCE (inFromId, 0) <> 0
     THEN
          RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.';
     END IF;
    

     RETURN QUERY
     WITH
     tmpPartnerLinkGoodsProperty AS (
                         SELECT ObjectLink_Partner_Juridical.ObjectId AS  PartnerId
                              , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                         FROM ObjectLink AS ObjectLink_Partner_Juridical
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                  ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                                 AND Coalesce (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                         WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           AND (ObjectLink_Partner_Juridical.ObjectId = inFromId OR inFromId = 0)
                                   )

   , tmpGoodsArticle AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  as GoodsPropertyId
                              , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId          as GoodsId
                              , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId      AS GoodsKindId
                              , ObjectString_Article.ValueData                             AS Article
                              , ObjectString_ArticleGLN.ValueData                          AS ArticleGLN

                         FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                 ON ObjectLink_GoodsPropertyValue_Goods.ObjectId =  ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
      
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                   ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
      
                           Inner JOIN ObjectString AS ObjectString_Article
                                     ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                    AND COALESCE (ObjectString_Article.ValueData, '') <> ''
      
                           LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                     ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
      
                         WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                         )

   , tmpMovement2 AS (SELECT Movement.OperDate
                           , MovementDate_OperDatePartner.ValueData                                                                                             AS OperDatePartner
                           , MovementString_InvNumberPartner.ValueData                                                                                          AS invnumberorderpartner
                           , MovementLinkObject_From.ObjectId                                                                                                   AS FromId
                           , MovementLinkObject_Route.ObjectId                                                                                                  AS RouteId
                           , 0                                                                                                                                  AS RouteSortingId
                           , MovementLinkObject_PaidKind.ObjectId                                                                                               AS PaidKindId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())                                                                   AS GoodsKindId
                           , MovementItem.ObjectId                                                                                                              AS GoodsId
                           , CAST (SUM((CASE WHEN Movement.OperDate = MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END)) AS TFloat)   AS Amount1
                           , CAST (SUM((CASE WHEN Movement.OperDate <> MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END)) AS TFloat)  AS Amount2
                           , CAST (SUM((MIFloat_AmountSecond.ValueData )) AS TFloat)                                                                            AS Amount_Dozakaz
   
                           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                           THEN CAST ( ( COALESCE ((CASE WHEN Movement.OperDate = MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData,0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                   END) AS TFloat)                      AS AmountSumm1
                
                           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                           THEN CAST ( ( COALESCE ((CASE WHEN Movement.OperDate <> MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                   END) AS TFloat)                      AS AmountSumm2
                
                
                           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                           THEN CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                           ELSE CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                   END) AS TFloat)                      AS AmountSumm_Dozakaz
                
                
                           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                           THEN CAST (  COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                           ELSE CAST (  COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                   END) AS TFloat)                      AS AmountSummTotal
                
                       FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            -- ограничиваем контрагентов для Агента
                           INNER JOIN _tmpPartner ON _tmpPartner.Id = MovementLinkObject_From.ObjectId
                                                      
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                
                            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                
                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId = zc_Movement_OrderExternal()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                         --AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                
                       GROUP BY
                             MovementLinkObject_From.ObjectId
                           , MovementLinkObject_Route.ObjectId
                           , MovementLinkObject_PaidKind.ObjectId
                           , MILinkObject_GoodsKind.ObjectId
                           , MovementItem.ObjectId
                           , Movement.OperDate
                           , MovementDate_OperDatePartner.ValueData
                           , MovementString_InvNumberPartner.ValueData
                
                         )

   , tmpMovementOrder AS (SELECT
                                 tmpMovement2.OperDate
                               , tmpMovement2.OperDatePartner
                               , tmpMovement2.invnumberorderpartner
                               , tmpMovement2.FromId             AS FromId
                               , tmpMovement2.RouteId            AS RouteId
                               , tmpMovement2.RouteSortingId     AS RouteSortingId
                               , tmpMovement2.PaidKindId         AS PaidKindId
                               , tmpMovement2.GoodsKindId        AS GoodsKindId
                               , tmpMovement2.GoodsId            AS GoodsId
                               , tmpMovement2.AmountSumm1        AS AmountSumm1
                               , tmpMovement2.AmountSumm2        AS AmountSumm2
                               , tmpMovement2.AmountSummTotal    AS AmountSummTotal
                               , tmpMovement2.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
                    
                               , CAST ((Amount1 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight1
                               , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount1 ELSE 0 END) AS TFloat)                                              AS Amount_Sh1
                    
                               , CAST ((Amount2 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight2
                               , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount2 ELSE 0 END) AS TFloat)                                              AS Amount_Sh2
                    
                               , CAST (( (Amount1+Amount2) * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Amount_Weight_Itog
                               , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN (Amount1+Amount2) ELSE 0 END) AS TFloat)                                    AS Amount_Sh_Itog
                    
                               , CAST ((Amount_Dozakaz * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)     AS Amount_Weight_Dozakaz
                               , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount_Dozakaz ELSE 0 END) AS TFloat)                                       AS Amount_Sh_Dozakaz
                    
                               , CAST ((Amount1 + Amount2) AS TFloat)                                                                                                                       AS Amount12
                               , CAST (0 AS TFloat)               AS AmountSale_Weight
                               , CAST (0 AS TFloat)               AS AmountSale_Sh
                    
                    
                          FROM tmpMovement2 AS tmpMovement2
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                         )

   --     ПРОДАЖИ -------------------
   , tmpMovementSaleTop AS (SELECT
                                   Movement.Id                                AS MovementId
                                 , Movement_Order.OperDate                    AS OperDate
                                 , Movement.OperDate                          AS OperDatePartner

                                 , MovementLinkObject_From.ObjectId           AS FromId
                                 , MovementLinkObject_Route.ObjectId          AS RouteId
                                 , 0                                          AS RouteSortingId
                                 , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                                 , CASE WHEN TRIM (COALESCE (MovementString_InvNumberOrder.ValueData, '')) <> ''
                                             THEN MovementString_InvNumberOrder.ValueData
                                        ELSE '***' || Movement_Order.InvNumber
                                   END :: TVarChar AS InvNumberOrderPartner
                                 , Movement.InvNumber
                             FROM Movement

                                 LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                          ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                                         AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                      
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To() --наоборот, что бы было как в заказе

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()

                                 -- ограничиваем контрагентов для Агента
                                 INNER JOIN _tmpPartner ON _tmpPartner.Id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                              ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                             AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                 LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                              ON MovementLinkObject_Route.MovementId = Movement_Order.Id
                                                             AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                             WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice()) ---= zc_Movement_Sale()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                              -- AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                               AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                             GROUP BY Movement.Id
                                 , MovementLinkObject_From.ObjectId
                                 , MovementLinkObject_Route.ObjectId
                                 , MovementLinkObject_PaidKind.ObjectId
                                 , Movement_Order.OperDate
                                 , Movement.OperDate
                                 , MovementString_InvNumberOrder.ValueData,Movement_Order.InvNumber,Movement.InvNumber
                             )

   , tmpMovementSale AS (SELECT
                                tmpMovementSaleTop.OperDate                AS OperDate
                              , tmpMovementSaleTop.OperDatePartner         AS OperDatePartner
                              , tmpMovementSaleTop.InvNumber
                              , tmpMovementSaleTop.InvNumberOrderPartner::TVarChar
                              , tmpMovementSaleTop.FromId
                              , tmpMovementSaleTop.RouteId
                              , tmpMovementSaleTop.RouteSortingId
                              , tmpMovementSaleTop.PaidKindId
                   
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                              , MovementItem.ObjectId                      AS GoodsId
                              , CAST (0 AS TFloat)                         AS Amount1
                              , CAST (0 AS TFloat)                         AS Amount2
                              , CAST (0 AS TFloat)                         AS Amount_Dozakaz
                              , CAST (0 AS TFloat)                         AS AmountSumm1
                              , CAST (0 AS TFloat)                         AS AmountSumm2
                              , CAST (0 AS TFloat)                         AS AmountSumm_Dozakaz
                              , CAST (0 AS TFloat)                         AS AmountSummTotal
                   
                              , CAST (0 AS TFloat)                         AS Amount_Weight1
                              , CAST (0 AS TFloat)                         AS Amount_Sh1
                              , CAST (0 AS TFloat)                         AS Amount_Weight2
                              , CAST (0 AS TFloat)                         AS Amount_Sh2
                              , CAST (0 AS TFloat)                         AS Amount_Weight_Itog
                              , CAST (0 AS TFloat)                         AS Amount_Sh_Itog
                              , CAST (0 AS TFloat)                         AS Amount_Weight_Dozakaz
                              , CAST (0 AS TFloat)                         AS Amount_Sh_Dozakaz
                              , CAST (0 AS TFloat)                         AS Amount12
                   
                              , CAST (SUM((MIFloat_AmountPartner.ValueData * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat) AS AmountSale_Weight
                              , CAST (SUM((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MIFloat_AmountPartner.ValueData ELSE 0 END)) AS TFloat)                                   AS AmountSale_Sh
                              , MIFloat_Price.ValueData                                                              AS PriceSale
                              , CAST (SUM((MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData)) AS TFloat)    AS SumSale
                          FROM tmpMovementSaleTop
                   
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementSaleTop.MovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                   
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                   
                          GROUP BY
                                tmpMovementSaleTop.FromId
                              , tmpMovementSaleTop.RouteId
                              , tmpMovementSaleTop.RouteSortingId
                              , tmpMovementSaleTop.PaidKindId
                              , MILinkObject_GoodsKind.ObjectId
                              , MovementItem.ObjectId
                              , tmpMovementSaleTop.OperDate
                              , tmpMovementSaleTop.OperDatePartner
                              , tmpMovementSaleTop.InvNumber
                              , tmpMovementSaleTop.InvNumberOrderPartner
                              , MIFloat_Price.ValueData
                          )

   , tmpMovementAll AS (SELECT
                               tmpMovementOrder.OperDate
                             , tmpMovementOrder.OperDatePartner
                             , Null AS InvNumber
                             , tmpMovementOrder.InvNumberOrderPartner
                             , tmpMovementOrder.FromId             AS FromId
                             , tmpMovementOrder.RouteId            AS RouteId
                             , tmpMovementOrder.RouteSortingId     AS RouteSortingId
                             , tmpMovementOrder.PaidKindId         AS PaidKindId
                             , tmpMovementOrder.GoodsKindId        AS GoodsKindId
                             , tmpMovementOrder.GoodsId            AS GoodsId
                             , tmpMovementOrder.AmountSumm1        AS AmountSumm1
                             , tmpMovementOrder.AmountSumm2        AS AmountSumm2
                             , tmpMovementOrder.AmountSummTotal    AS AmountSummTotal
                             , tmpMovementOrder.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
                             , tmpMovementOrder.Amount_Weight1     AS Amount_Weight1
                             , tmpMovementOrder.Amount_Sh1         AS Amount_Sh1
                             , tmpMovementOrder.Amount_Weight2     AS Amount_Weight2
                             , tmpMovementOrder.Amount_Sh2         AS Amount_Sh2
                             , tmpMovementOrder.Amount_Weight_Itog AS Amount_Weight_Itog
                             , tmpMovementOrder.Amount_Sh_Itog     AS Amount_Sh_Itog
                             , tmpMovementOrder.Amount_Weight_Dozakaz AS Amount_Weight_Dozakaz
                             , tmpMovementOrder.Amount_Sh_Dozakaz  AS Amount_Sh_Dozakaz
                             , tmpMovementOrder.Amount12           AS Amount12
                             , tmpMovementOrder.AmountSale_Weight  AS AmountSale_Weight
                             , tmpMovementOrder.AmountSale_Sh      AS AmountSale_Sh
                             , CAST (0 AS TFloat)    AS PriceSale
                             , CAST (0 AS TFloat)    AS SumSale
                         FROM tmpMovementOrder
                         UNION ALL
                         SELECT
                               tmpMovementSale.OperDate
                             , tmpMovementSale.OperDatePartner
                             , tmpMovementSale.InvNumber
                             , tmpMovementSale.InvNumberOrderPartner
                             , tmpMovementSale.FromId             AS FromId
                             , tmpMovementSale.RouteId            AS RouteId
                             , tmpMovementSale.RouteSortingId     AS RouteSortingId
                             , tmpMovementSale.PaidKindId         AS PaidKindId
                             , tmpMovementSale.GoodsKindId        AS GoodsKindId
                             , tmpMovementSale.GoodsId            AS GoodsId
                             , tmpMovementSale.AmountSumm1        AS AmountSumm1
                             , tmpMovementSale.AmountSumm2        AS AmountSumm2
                             , tmpMovementSale.AmountSummTotal    AS AmountSummTotal
                             , tmpMovementSale.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
                             , tmpMovementSale.Amount_Weight1     AS Amount_Weight1
                             , tmpMovementSale.Amount_Sh1         AS Amount_Sh1
                             , tmpMovementSale.Amount_Weight2     AS Amount_Weight2
                             , tmpMovementSale.Amount_Sh2         AS Amount_Sh2
                             , tmpMovementSale.Amount_Weight_Itog AS Amount_Weight_Itog
                             , tmpMovementSale.Amount_Sh_Itog     AS Amount_Sh_Itog
                             , tmpMovementSale.Amount_Weight_Dozakaz AS Amount_Weight_Dozakaz
                             , tmpMovementSale.Amount_Sh_Dozakaz  AS Amount_Sh_Dozakaz
                             , tmpMovementSale.Amount12           AS Amount12
                             , tmpMovementSale.AmountSale_Weight  AS AmountSale_Weight
                             , tmpMovementSale.AmountSale_Sh      AS AmountSale_Sh
                             , tmpMovementSale.PriceSale
                             , tmpMovementSale.SumSale
                  
                         FROM tmpMovementSale
                        )

   , tmpMovement AS (SELECT
                            tmpMovementAll.OperDate         AS OperDate
                          , tmpMovementAll.OperDatePartner  AS OperDatePartner
               
                          , Max(tmpMovementAll.InvNumber)   AS InvNumber
                          , Max(tmpMovementAll.InvNumberOrderPartner) AS InvNumberOrderPartner
               
                          , tmpMovementAll.FromId                       AS FromId
                          , COALESCE (tmpMovementAll.RouteId, 0)        AS RouteId
                          , COALESCE (tmpMovementAll.RouteSortingId, 0) AS RouteSortingId
               
                          , tmpMovementAll.PaidKindId         AS PaidKindId
                          , tmpMovementAll.GoodsKindId        AS GoodsKindId
                          , tmpMovementAll.GoodsId            AS GoodsId
               
                          , CAST (SUM((tmpMovementAll.AmountSumm1)) AS TFloat)         AS AmountSumm1
                          , CAST (SUM((tmpMovementAll.AmountSumm2)) AS TFloat)         AS AmountSumm2
                          , CAST (SUM((tmpMovementAll.AmountSummTotal)) AS TFloat)     AS AmountSummTotal
                          , CAST (SUM((tmpMovementAll.AmountSumm_Dozakaz)) AS TFloat)  AS AmountSumm_Dozakaz
                          , CAST (SUM((tmpMovementAll.Amount_Weight1)) AS TFloat)      AS Amount_Weight1
                          , CAST (SUM((tmpMovementAll.Amount_Sh1)) AS TFloat)          AS Amount_Sh1
                          , CAST (SUM((tmpMovementAll.Amount_Weight2)) AS TFloat)      AS Amount_Weight2
                          , CAST (SUM((tmpMovementAll.Amount_Sh2)) AS TFloat)          AS Amount_Sh2
                          , CAST (SUM((tmpMovementAll.Amount_Weight_Itog)) AS TFloat)  AS Amount_Weight_Itog
                          , CAST (SUM((tmpMovementAll.Amount_Sh_Itog)) AS TFloat)      AS Amount_Sh_Itog
                          , CAST (SUM((tmpMovementAll.Amount_Weight_Dozakaz)) AS TFloat)  AS Amount_Weight_Dozakaz
                          , CAST (SUM((tmpMovementAll.Amount_Sh_Dozakaz)) AS TFloat)   AS Amount_Sh_Dozakaz
                          , CAST (SUM((tmpMovementAll.Amount12)) AS TFloat)            AS Amount12
                          , CAST (SUM((tmpMovementAll.AmountSale_Weight)) AS TFloat)   AS AmountSale_Weight
                          , CAST (SUM((tmpMovementAll.AmountSale_Sh)) AS TFloat)       AS AmountSale_Sh
                          , CAST (Max(tmpMovementAll.PriceSale) AS TFloat)        AS  PriceSale
                          , CAST (SUM((tmpMovementAll.SumSale)) AS TFloat)            AS SumSale
                      FROM tmpMovementAll
                      GROUP BY
                            tmpMovementAll.FromId
                          , COALESCE (tmpMovementAll.RouteId, 0)
                          , COALESCE (tmpMovementAll.RouteSortingId, 0)
                          , tmpMovementAll.PaidKindId
                          , tmpMovementAll.GoodsKindId
                          , tmpMovementAll.GoodsId
                          , tmpMovementAll.OperDate
                          , tmpMovementAll.OperDatePartner
                          )

       -- запрос
       SELECT
             tmpMovement.OperDate        ::TDateTime    AS OperDate
           , tmpMovement.OperDatePartner ::TDateTime    AS OperDatePartner
           , tmpMovement.InvNumber        ::TVarChar
           , tmpMovement.InvNumberOrderPartner  ::TVarChar
           , ObjectDesc_From.ItemName                   AS FromDescName
           , Object_From.Id                             AS FromId
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_Route.Id                            AS RouteId
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ObjectCode             AS RouteSortingCode
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , Object_GoodsKind.Id                        AS GoodsKindId
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , tmpGoodsArticle.Article                    AS Article
           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

           , tmpMovement.AmountSumm1                    AS AmountSumm1
           , tmpMovement.AmountSumm2                    AS AmountSumm2
           , tmpMovement.AmountSummTotal                AS AmountSummTotal
           , tmpMovement.AmountSumm_Dozakaz             AS AmountSumm_Dozakaz

           , tmpMovement.Amount_Weight1                 AS Amount_Weight1
           , tmpMovement.Amount_Sh1                     AS Amount_Sh1
           , tmpMovement.Amount_Weight2                 AS Amount_Weight2
           , tmpMovement.Amount_Sh2                     AS Amount_Sh2
           , tmpMovement.Amount_Weight_Itog             AS Amount_Weight_Itog
           , tmpMovement.Amount_Sh_Itog                 AS Amount_Sh_Itog

           , tmpMovement.Amount_Weight_Dozakaz          AS Amount_Weight_Dozakaz
           , tmpMovement.Amount_Sh_Dozakaz              AS Amount_Sh_Dozakaz
           , tmpMovement.Amount12                       AS Amount12
           , CAST (0 AS TFloat)                         AS Amount_WeightSK
           , tmpMovement.AmountSale_Weight              AS AmountSale_Weight
           , tmpMovement.AmountSale_Sh                  AS AmountSale_Sh
           , tmpMovement.PriceSale
           , tmpMovement.SumSale
           , Object_InfoMoney_View.InfoMoneyName        AS InfoMoneyName

       FROM tmpMovement
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId
          
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = tmpMovement.RouteSortingId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMovement.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

          LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View
                                          ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN tmpPartnerLinkGoodsProperty ON tmpPartnerLinkGoodsProperty.PartnerId = tmpMovement.FromId

          LEFT JOIN tmpGoodsArticle ON tmpGoodsArticle.GoodsPropertyId = tmpPartnerLinkGoodsProperty.GoodsPropertyId
                                   AND tmpGoodsArticle.GoodsId = tmpMovement.GoodsId
                                   AND tmpGoodsArticle.GoodsKindId = tmpMovement.GoodsKindId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.05.18         *
*/

-- тест
--select * from gpReport_OrderExternal_Sale_Mobile (inStartDate := ('13.01.2016')::TDateTime , inEndDate := ('13.01.2016')::TDateTime , inFromId := 17744  , inToId := 0 , inRouteId := 0 , inRouteSortingId := 0 , inGoodsGroupId := 0 , inIsByDoc := 'False' ,  inSession := '5');
--select * from gpReport_OrderExternal_Sale_Mobile (inStartDate := ('27.12.2016')::TDateTime , inEndDate := ('29.12.2016')::TDateTime , inFromId := 17732 , inToId := 8459 , inRouteId := 0 , inRouteSortingId := 0 , inGoodsGroupId := 0 , inIsByDoc := 'False' ,  inSession := '5');