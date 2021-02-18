-- Function: gpReport_OrderExternal_Sale()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Sale(
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
             , OperDate_Sale TDateTime, OperDatePartner_Sale TDateTime 
             , InvNumber TVarChar, InvNumberOrderPartner TVarChar, InvNumber_Order TVarChar
             , FromDescName TVarChar, FromId Integer, FromCode Integer, FromName TVarChar
             , RouteId Integer, RouteName TVarChar
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
             , Amount_Order TFloat, Amount_Dozakaz TFloat
             , Amount_WeightSK TFloat
             , AmountSalePartner_Weight TFloat, AmountSalePartner_Sh TFloat
             , AmountSale_Weight TFloat, AmountSale_Sh TFloat, AmountSale TFloat
             , PriceSale TFloat, SumSale TFloat
             , InfoMoneyName TVarChar

             , TotalCountDiff_B  TFloat
             , TotalCountDiff_M  TFloat
             , TotalWeightDiff_B TFloat
             , TotalWeightDiff_M TFloat

             , CountDiff_B  TFloat
             , CountDiff_M  TFloat
             , WeightDiff_B TFloat
             , WeightDiff_M TFloat
             , Diff_M       TFloat
            -- , Diff_M1    TFloat
             , AmountTax    TFloat
             , WeightTax    TFloat
             , DiffTax      TFloat
             , isPrint_M    Boolean
             , CountPrint_M TFloat
             
           , AmountSale_Weight_M      TFloat
           , Amount_Weight_M          TFloat
           , Amount_Weight_Dozakaz_M  TFloat
           
, TotalCount_Diff TFloat
, TotalWeight_Diff TFloat
, TotalAmountTax TFloat
, TotalWeightTax TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDiffTax TFloat;
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


    vbDiffTax := (WITH tmpBranch AS (SELECT COALESCE (OL_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
                                     FROM ObjectLink AS OL_Branch
                                     WHERE OL_Branch.ObjectId = inToId
                                       AND OL_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                     )
                     , tmpToolsWeighing_Branch AS (SELECT Object_ToolsWeighing_View.*
                                                   FROM Object_ToolsWeighing_View
                                                   WHERE Object_ToolsWeighing_View.Name = 'BranchId'
                                                   )
                     , tmpToolsWeighing_DiffSaleOrder AS (SELECT Object_ToolsWeighing_View.*
                                                          FROM Object_ToolsWeighing_View
                                                          WHERE Object_ToolsWeighing_View.Name = 'DiffSaleOrder'
                                                          )
                  SELECT COALESCE (zfConvert_StringToFloat(tmpToolsWeighing_DiffSaleOrder.Valuedata), 11)
                  FROM tmpBranch
                       LEFT JOIN tmpToolsWeighing_Branch        ON tmpToolsWeighing_Branch.ValueData       = tmpBranch.BranchId :: TVarChar
                       LEFT JOIN tmpToolsWeighing_DiffSaleOrder ON tmpToolsWeighing_DiffSaleOrder.ParentId = tmpToolsWeighing_Branch.ParentId
                  LIMIT 1
                  );

     RETURN QUERY
     WITH
      tmpPartnerLinkGoodsProperty AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS  PartnerId
                                           , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                      FROM ObjectLink AS ObjectLink_Partner_Juridical
                                         INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                                              AND Coalesce (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                      WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                        AND (ObjectLink_Partner_Juridical.ObjectId = inFromId OR inFromId = 0)
                                    )

    , tmpGoodsArticle AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                               , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId          AS GoodsId
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
       
                            INNER JOIN ObjectString AS ObjectString_Article
                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                                   AND COALESCE (ObjectString_Article.ValueData, '') <> ''
       
                            LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                   ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                  AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
       
                          WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                          )

    --     ПРОДАЖИ -------------------
    , tmpMovementSale AS (SELECT Movement.Id                                AS MovementId_Sale
                               , COALESCE (Movement_Order.Id,0)             AS MovementId_Order
                               , Movement_Order.OperDate                                                           AS OperDate_Order
                               , CASE WHEN inIsByDoc = TRUE THEN Movement.OperDate ELSE NULL END ::TDateTime       AS OperDate_Sale
                               , CASE WHEN inIsByDoc = TRUE THEN MovementDate_OperDatePartner.ValueData ELSE NULL END  ::TDateTime AS OperDatePartner_Sale
                               , MovementDate_OperDatePartner_order.ValueData                                      AS OperDatePartner_Order
                               
                               , CASE WHEN inIsByDoc = TRUE THEN Movement.InvNumber ELSE NULL END                  AS InvNumber_Sale
                               , CASE WHEN inIsByDoc = TRUE THEN Movement_Order.InvNumber ELSE NULL END            AS InvNumber_Order
                               , CASE WHEN inIsByDoc = TRUE 
                                      THEN TRIM (COALESCE (MovementString_InvNumberOrder.ValueData, ''))
                                          /* 
                                           CASE WHEN TRIM (COALESCE (MovementString_InvNumberOrder.ValueData, '')) <> ''
                                                     THEN MovementString_InvNumberOrder.ValueData
                                                ELSE '***' || Movement_Order.InvNumber
                                           END 
                                         */
                                      ELSE NULL
                                 END                                                                  :: TVarChar AS InvNumberPartner_Order
                               
                               , MovementLinkObject_From.ObjectId           AS FromId
                               , MovementLinkObject_Route.ObjectId          AS RouteId
                               , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                               
                           FROM Movement

                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                               LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                        ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                    
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To() --наоборот, что бы было как в заказе
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                              ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                             AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                               LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId

                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner_order
                                                      ON MovementDate_OperDatePartner_order.MovementId = Movement_Order.Id
                                                     AND MovementDate_OperDatePartner_order.DescId = zc_MovementDate_OperDatePartner()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                            ON MovementLinkObject_Route.MovementId = Movement_Order.Id
                                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice()) ---= zc_Movement_Sale()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                             AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                             AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                           )
    --- Заявки
    , tmpMovementOrder AS (SELECT Movement.Id                                         AS MovementId_Order
                                , CASE WHEN inIsByDoc = TRUE THEN Movement.InvNumber ELSE NULL END AS InvNumber_Order
                                , Movement.OperDate                                   AS OperDate_Order
                                , MovementDate_OperDatePartner.ValueData              AS OperDatePartner_Order
                                , CASE WHEN inIsByDoc = TRUE THEN TRIM (COALESCE (MovementString_InvNumberPartner.ValueData, ''))
                                                                 /*CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner.ValueData, '')) <> ''
                                                                       THEN MovementString_InvNumberPartner.ValueData
                                                                        ELSE '***' || Movement.InvNumber
                                                                   END */
                                                             ELSE NULL
                                  END                                     :: TVarChar AS InvNumberPartner_Order
                                , MovementLinkObject_From.ObjectId                    AS FromId
                                , MovementLinkObject_Route.ObjectId                   AS RouteId
                                , MovementLinkObject_PaidKind.ObjectId                AS PaidKindId
        
                            FROM Movement
                                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                               ON MovementLinkMovement_Order.MovementChildId = Movement.Id  --  заявка 
                                                              AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                     
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
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
        
                            WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_OrderExternal()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
                              AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
                              AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
                              AND COALESCE (MovementLinkMovement_Order.MovementId, 0) = 0
                            )
   -- все продажи и заявки
    , tmpMovementAll AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY tmpMovementAll.MovementId_Order ORDER BY tmpMovementAll.MovementId_Sale) AS Ord
                         FROM (
                               SELECT tmp.MovementId_Sale
                                    , tmp.OperDate_Sale
                                    , tmp.OperDatePartner_Sale
                                    , tmp.InvNumber_Sale
                                    
                                    , tmp.MovementId_Order
                                    , tmp.OperDate_Order
                                    , tmp.OperDatePartner_Order
                                    , tmp.InvNumber_Order
                                    , tmp.InvNumberPartner_Order
      
                                    , tmp.FromId
                                    , tmp.RouteId
                                    , tmp.PaidKindId
                               FROM tmpMovementSale AS tmp
                             UNION 
                               SELECT 0                   AS MovementId_Sale
                                    , NULL :: TDateTime   AS OperDate_Sale
                                    , NULL :: TDateTime   AS OperDatePartner_Sale
                                    , NULL :: TVarChar    AS InvNumber_Sale
      
                                    , tmp.MovementId_Order
                                    , tmp.OperDate_Order
                                    , tmp.OperDatePartner_Order
                                    , tmp.InvNumber_Order
                                    , tmp.InvNumberPartner_Order
       
                                    , tmp.FromId
                                    , tmp.RouteId
                                    , tmp.PaidKindId
                               FROM tmpMovementOrder AS tmp
                               ) AS tmpMovementAll
                        )
                   
     -- данные по продажам
    , tmpMI_Sale AS (SELECT     tmpSale.MovementId_Sale
                              , tmpSale.OperDate_Sale
                              , tmpSale.OperDatePartner_Sale
                              , tmpSale.InvNumber_Sale
                              
                              , tmpSale.MovementId_Order
                              , tmpSale.OperDate_Order
                              , tmpSale.OperDatePartner_Order
                              , tmpSale.InvNumber_Order
                              , tmpSale.InvNumberPartner_Order

                              , tmpSale.FromId
                              , tmpSale.RouteId
                              , tmpSale.PaidKindId

                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                              , MovementItem.ObjectId                                            AS GoodsId
                              , CAST (SUM ((MIFloat_AmountPartner.ValueData * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat) AS AmountSalePartner_Weight    -- Вес у покупателя
                              , CAST (SUM ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MIFloat_AmountPartner.ValueData ELSE 0 END)) AS TFloat)                                   AS AmountSalePartner_Sh        -- кол-во у покупателя
                              , CAST (SUM ((MovementItem.Amount * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat)             AS AmountSale_Weight  -- Вес склад
                              , CAST (SUM ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MovementItem.Amount ELSE 0 END)) AS TFloat)                                               AS AmountSale_Sh      -- кол-во склад
                              , CAST (SUM (MovementItem.Amount) AS TFloat)                                                                                                                                    AS AmountSale
                              , MIFloat_Price.ValueData                                                              AS PriceSale
                              , CAST (SUM((MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData)) AS TFloat)    AS SumSale
                     FROM (SELECT tmpMovementAll.* FROM tmpMovementAll WHERE tmpMovementAll.MovementId_Sale <> 0)    AS tmpSale
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.MovementId_Sale
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
                
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure 
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     GROUP BY  tmpSale.MovementId_Sale
                             , tmpSale.OperDate_Sale
                             , tmpSale.OperDatePartner_Sale
                             , tmpSale.InvNumber_Sale
                             
                             , tmpSale.MovementId_Order
                             , tmpSale.OperDate_Order
                             , tmpSale.OperDatePartner_Order
                             , tmpSale.InvNumber_Order
                             , tmpSale.InvNumberPartner_Order

                             , tmpSale.FromId
                             , tmpSale.RouteId
                             , tmpSale.PaidKindId

                             , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                             , MovementItem.ObjectId
                             , MIFloat_Price.ValueData
                     )
    -- данные по всем заявкам
    , tmpMI_Order AS (SELECT tmpMovement2.MovementId_Sale
                           , tmpMovement2.OperDate_Sale
                           , tmpMovement2.OperDatePartner_Sale
                           , tmpMovement2.InvNumber_Sale
                           
                           , tmpMovement2.MovementId_Order
                           , tmpMovement2.OperDate_Order
                           , tmpMovement2.OperDatePartner_Order
                           , tmpMovement2.InvNumber_Order
                           , tmpMovement2.InvNumberPartner_Order

                           , tmpMovement2.FromId
                           , tmpMovement2.RouteId
                           , tmpMovement2.PaidKindId

                           , tmpMovement2.GoodsKindId
                           , tmpMovement2.GoodsId
                           
                           , tmpMovement2.AmountSumm1        AS AmountSumm1
                           , tmpMovement2.AmountSumm2        AS AmountSumm2
                           , tmpMovement2.AmountSummTotal    AS AmountSummTotal
                           , tmpMovement2.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
                
                           , CAST (SUM(tmpMovement2.Amount1 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight1
                           , CAST (SUM(CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount1 ELSE 0 END) AS TFloat)                                                           AS Amount_Sh1
                
                           , CAST (SUM(tmpMovement2.Amount2 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight2
                           , CAST (SUM(CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount2 ELSE 0 END) AS TFloat)                                                           AS Amount_Sh2
                
                           , CAST (SUM( (tmpMovement2.Amount1 + tmpMovement2.Amount2) * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Amount_Weight_Itog
                           , CAST (SUM(CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN (tmpMovement2.Amount1 + tmpMovement2.Amount2) ELSE 0 END) AS TFloat)                                    AS Amount_Sh_Itog
                
                           , CAST (SUM(tmpMovement2.Amount_Dozakaz * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)     AS Amount_Weight_Dozakaz
                           , CAST (SUM(CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMovement2.Amount_Dozakaz ELSE 0 END) AS TFloat)                                       AS Amount_Sh_Dozakaz
                
                           , CAST (SUM(tmpMovement2.Amount1 + tmpMovement2.Amount2) AS TFloat)                                                                                                          AS Amount12
                           , CAST (SUM(tmpMovement2.Amount_Dozakaz) AS TFloat)                                                                                                                          AS Amount_Dozakaz
                      FROM (
                            SELECT tmpOrder.MovementId_Sale
                                 , tmpOrder.OperDate_Sale
                                 , tmpOrder.OperDatePartner_Sale
                                 , tmpOrder.InvNumber_Sale
                                 
                                 , tmpOrder.MovementId_Order
                                 , tmpOrder.OperDate_Order
                                 , tmpOrder.OperDatePartner_Order
                                 , tmpOrder.InvNumber_Order
                                 , tmpOrder.InvNumberPartner_Order
   
                                 , tmpOrder.FromId
                                 , tmpOrder.RouteId
                                 , tmpOrder.PaidKindId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())                                                                   AS GoodsKindId
                                 , MovementItem.ObjectId                                                                                                              AS GoodsId
                                 , CAST (SUM((CASE WHEN tmpOrder.OperDate_Order = tmpOrder.OperDatePartner_Order THEN MovementItem.Amount ELSE 0 END)) AS TFloat)                 AS Amount1
                                 , CAST (SUM((CASE WHEN tmpOrder.OperDate_Order <> tmpOrder.OperDatePartner_Order THEN MovementItem.Amount ELSE 0 END)) AS TFloat)                AS Amount2
                                 , CAST (SUM(COALESCE(MIFloat_AmountSecond.ValueData, 0)) AS TFloat)                                                                  AS Amount_Dozakaz
         
                                 , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                 THEN CAST ( ( COALESCE ((CASE WHEN tmpOrder.OperDate_Order = tmpOrder.OperDatePartner_Order THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData,0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                 ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                         END) AS TFloat)                      AS AmountSumm1
                      
                                 , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                 THEN CAST ( ( COALESCE ((CASE WHEN tmpOrder.OperDate_Order <> tmpOrder.OperDatePartner_Order THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
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
      
                          FROM (SELECT tmpMovementAll.* FROM tmpMovementAll WHERE tmpMovementAll.MovementId_Order <> 0 AND COALESCE (tmpMovementAll.Ord, 1) = 1
                                ) AS tmpOrder
                                -- строки
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpOrder.MovementId_Order
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
                          GROUP BY tmpOrder.MovementId_Sale
                                 , tmpOrder.OperDate_Sale
                                 , tmpOrder.OperDatePartner_Sale
                                 , tmpOrder.InvNumber_Sale
                                 
                                 , tmpOrder.MovementId_Order
                                 , tmpOrder.OperDate_Order
                                 , tmpOrder.OperDatePartner_Order
                                 , tmpOrder.InvNumber_Order
                                 , tmpOrder.InvNumberPartner_Order
   
                                 , tmpOrder.FromId
                                 , tmpOrder.RouteId
                                 , tmpOrder.PaidKindId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                                 , MovementItem.ObjectId
                          ) AS tmpMovement2
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                     ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                      GROUP BY  tmpMovement2.MovementId_Sale
                              , tmpMovement2.OperDate_Sale
                              , tmpMovement2.OperDatePartner_Sale
                              , tmpMovement2.InvNumber_Sale
                              
                              , tmpMovement2.MovementId_Order
                              , tmpMovement2.OperDate_Order
                              , tmpMovement2.OperDatePartner_Order
                              , tmpMovement2.InvNumber_Order
                              , tmpMovement2.InvNumberPartner_Order

                              , tmpMovement2.FromId
                              , tmpMovement2.RouteId
                              , tmpMovement2.PaidKindId
                              , tmpMovement2.GoodsKindId
                              , tmpMovement2.GoodsId
                              , tmpMovement2.AmountSumm1
                              , tmpMovement2.AmountSumm2
                              , tmpMovement2.AmountSummTotal
                              , tmpMovement2.AmountSumm_Dozakaz 
                    )
     -----
    , tmpDataUnion AS (SELECT tmpMovementOrder.MovementId_Sale
                            , tmpMovementOrder.OperDate_Sale
                            , tmpMovementOrder.OperDatePartner_Sale
                            , tmpMovementOrder.InvNumber_Sale
                            
                            , tmpMovementOrder.MovementId_Order
                            , tmpMovementOrder.OperDate_Order
                            , tmpMovementOrder.OperDatePartner_Order
                            , tmpMovementOrder.InvNumber_Order
                            , tmpMovementOrder.InvNumberPartner_Order

                            , tmpMovementOrder.FromId
                            , tmpMovementOrder.RouteId
                            , tmpMovementOrder.PaidKindId

                            , tmpMovementOrder.GoodsKindId
                            , tmpMovementOrder.GoodsId

                            , tmpMovementOrder.AmountSumm1           AS AmountSumm1
                            , tmpMovementOrder.AmountSumm2           AS AmountSumm2
                            , tmpMovementOrder.AmountSummTotal       AS AmountSummTotal
                            , tmpMovementOrder.AmountSumm_Dozakaz    AS AmountSumm_Dozakaz
                            , tmpMovementOrder.Amount_Weight1        AS Amount_Weight1
                            , tmpMovementOrder.Amount_Sh1            AS Amount_Sh1
                            , tmpMovementOrder.Amount_Weight2        AS Amount_Weight2
                            , tmpMovementOrder.Amount_Sh2            AS Amount_Sh2
                            , tmpMovementOrder.Amount_Weight_Itog    AS Amount_Weight_Itog
                            , tmpMovementOrder.Amount_Sh_Itog        AS Amount_Sh_Itog
                            , tmpMovementOrder.Amount_Weight_Dozakaz AS Amount_Weight_Dozakaz
                            , tmpMovementOrder.Amount_Sh_Dozakaz     AS Amount_Sh_Dozakaz
                            , tmpMovementOrder.Amount12              AS Amount12
                            , tmpMovementOrder.Amount_Dozakaz        AS Amount_Dozakaz
                            , CAST (0 AS TFloat)                     AS AmountSalePartner_Weight
                            , CAST (0 AS TFloat)                     AS AmountSalePartner_Sh
                            , CAST (0 AS TFloat)                     AS AmountSale_Weight
                            , CAST (0 AS TFloat)                     AS AmountSale_Sh
                            , CAST (0 AS TFloat)                     AS AmountSale
                            , CAST (0 AS TFloat)                     AS PriceSale
                            , CAST (0 AS TFloat)                     AS SumSale
                       FROM tmpMI_Order AS tmpMovementOrder
                    UNION ALL
                       SELECT tmpMovementSale.MovementId_Sale
                            , tmpMovementSale.OperDate_Sale
                            , tmpMovementSale.OperDatePartner_Sale
                            , tmpMovementSale.InvNumber_Sale
                            
                            , tmpMovementSale.MovementId_Order
                            , tmpMovementSale.OperDate_Order
                            , tmpMovementSale.OperDatePartner_Order
                            , tmpMovementSale.InvNumber_Order
                            , tmpMovementSale.InvNumberPartner_Order
    
                            , tmpMovementSale.FromId
                            , tmpMovementSale.RouteId
                            , tmpMovementSale.PaidKindId
    
                            , tmpMovementSale.GoodsKindId
                            , tmpMovementSale.GoodsId
                            , CAST (0 AS TFloat)     AS AmountSumm1
                            , CAST (0 AS TFloat)     AS AmountSumm2
                            , CAST (0 AS TFloat)     AS AmountSummTotal
                            , CAST (0 AS TFloat)     AS AmountSumm_Dozakaz
                            , CAST (0 AS TFloat)     AS Amount_Weight1
                            , CAST (0 AS TFloat)     AS Amount_Sh1
                            , CAST (0 AS TFloat)     AS Amount_Weight2
                            , CAST (0 AS TFloat)     AS Amount_Sh2
                            , CAST (0 AS TFloat)     AS Amount_Weight_Itog
                            , CAST (0 AS TFloat)     AS Amount_Sh_Itog
                            , CAST (0 AS TFloat)     AS Amount_Weight_Dozakaz
                            , CAST (0 AS TFloat)     AS Amount_Sh_Dozakaz
                            , CAST (0 AS TFloat)     AS Amount12
                            , CAST (0 AS TFloat)     AS Amount_Dozakaz
                            , tmpMovementSale.AmountSalePartner_Weight  AS AmountSalePartner_Weight
                            , tmpMovementSale.AmountSalePartner_Sh      AS AmountSalePartner_Sh
                            , tmpMovementSale.AmountSale_Weight  AS AmountSale_Weight
                            , tmpMovementSale.AmountSale_Sh      AS AmountSale_Sh
                            , tmpMovementSale.AmountSale         AS AmountSale
                            , tmpMovementSale.PriceSale
                            , tmpMovementSale.SumSale
                 
                       FROM tmpMI_Sale AS tmpMovementSale
                      )

    , tmpData1 AS (SELECT tmpDataUnion.MovementId_Sale
                       , tmpDataUnion.OperDate_Sale
                       , tmpDataUnion.OperDatePartner_Sale
                       , tmpDataUnion.InvNumber_Sale
                       
                       , tmpDataUnion.MovementId_Order
                       , tmpDataUnion.OperDate_Order
                       , tmpDataUnion.OperDatePartner_Order
                       , tmpDataUnion.InvNumber_Order
                       , tmpDataUnion.InvNumberPartner_Order

                       , tmpDataUnion.FromId
                       , tmpDataUnion.RouteId
                       , tmpDataUnion.PaidKindId

                       , tmpDataUnion.GoodsKindId
                       , tmpDataUnion.GoodsId

                       , SUM (tmpDataUnion.AmountSumm1)           AS AmountSumm1
                       , SUM (tmpDataUnion.AmountSumm2)           AS AmountSumm2
                       , SUM (tmpDataUnion.AmountSummTotal)       AS AmountSummTotal
                       , SUM (tmpDataUnion.AmountSumm_Dozakaz)    AS AmountSumm_Dozakaz
                       , SUM (tmpDataUnion.Amount_Weight1)        AS Amount_Weight1
                       , SUM (tmpDataUnion.Amount_Sh1)            AS Amount_Sh1
                       , SUM (tmpDataUnion.Amount_Weight2)        AS Amount_Weight2
                       , SUM (tmpDataUnion.Amount_Sh2)            AS Amount_Sh2
                       , SUM (tmpDataUnion.Amount_Weight_Itog)    AS Amount_Weight_Itog
                       , SUM (tmpDataUnion.Amount_Sh_Itog)        AS Amount_Sh_Itog
                       , SUM (tmpDataUnion.Amount_Weight_Dozakaz) AS Amount_Weight_Dozakaz
                       , SUM (tmpDataUnion.Amount_Sh_Dozakaz)     AS Amount_Sh_Dozakaz
                       , SUM (tmpDataUnion.Amount12)              AS Amount12
                       , SUM (tmpDataUnion.Amount_Dozakaz)        AS Amount_Dozakaz
                       , SUM (tmpDataUnion.AmountSalePartner_Weight)  AS AmountSalePartner_Weight
                       , SUM (tmpDataUnion.AmountSalePartner_Sh)      AS AmountSalePartner_Sh
                       , SUM (tmpDataUnion.AmountSale_Weight)     AS AmountSale_Weight
                       , SUM (tmpDataUnion.AmountSale_Sh)         AS AmountSale_Sh
                       , SUM (tmpDataUnion.AmountSale)            AS AmountSale
                       , MAX (tmpDataUnion.PriceSale)             AS PriceSale
                       , SUM (tmpDataUnion.SumSale)               AS SumSale

                       -- итого по заявке, если 1 заявка и несколько продаж нужно свернуть суммы
                      -- , SUM (tmpDataUnion.AmountSale_Sh)     OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalSale_Sh
                      -- , SUM (tmpDataUnion.AmountSale_Weight) OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalSale_Weight
                  FROM tmpDataUnion
                  GROUP BY tmpDataUnion.MovementId_Sale
                         , tmpDataUnion.OperDate_Sale
                         , tmpDataUnion.OperDatePartner_Sale
                         , tmpDataUnion.InvNumber_Sale
                         , tmpDataUnion.MovementId_Order
                         , tmpDataUnion.OperDate_Order
                         , tmpDataUnion.OperDatePartner_Order
                         , tmpDataUnion.InvNumber_Order
                         , tmpDataUnion.InvNumberPartner_Order
                         , tmpDataUnion.FromId
                         , tmpDataUnion.RouteId
                         , tmpDataUnion.PaidKindId
                         , tmpDataUnion.GoodsKindId
                         , tmpDataUnion.GoodsId
                  )

    , tmpData AS (SELECT tmpDataUnion.MovementId_Sale
                       , tmpDataUnion.OperDate_Sale
                       , tmpDataUnion.OperDatePartner_Sale
                       , tmpDataUnion.InvNumber_Sale
                       
                       , tmpDataUnion.MovementId_Order
                       , tmpDataUnion.OperDate_Order
                       , tmpDataUnion.OperDatePartner_Order
                       , tmpDataUnion.InvNumber_Order
                       , tmpDataUnion.InvNumberPartner_Order

                       , tmpDataUnion.FromId
                       , tmpDataUnion.RouteId
                       , tmpDataUnion.PaidKindId

                       , tmpDataUnion.GoodsKindId
                       , tmpDataUnion.GoodsId

                       ,  (tmpDataUnion.AmountSumm1)           AS AmountSumm1
                       ,  (tmpDataUnion.AmountSumm2)           AS AmountSumm2
                       ,  (tmpDataUnion.AmountSummTotal)       AS AmountSummTotal
                       ,  (tmpDataUnion.AmountSumm_Dozakaz)    AS AmountSumm_Dozakaz
                       ,  (tmpDataUnion.Amount_Weight1)        AS Amount_Weight1
                       ,  (tmpDataUnion.Amount_Sh1)            AS Amount_Sh1
                       ,  (tmpDataUnion.Amount_Weight2)        AS Amount_Weight2
                       ,  (tmpDataUnion.Amount_Sh2)            AS Amount_Sh2
                       ,  (tmpDataUnion.Amount_Weight_Itog)    AS Amount_Weight_Itog
                       ,  (tmpDataUnion.Amount_Sh_Itog)        AS Amount_Sh_Itog
                       ,  (tmpDataUnion.Amount_Weight_Dozakaz) AS Amount_Weight_Dozakaz
                       ,  (tmpDataUnion.Amount_Sh_Dozakaz)     AS Amount_Sh_Dozakaz
                       ,  (tmpDataUnion.Amount12)              AS Amount12
                       ,  (tmpDataUnion.Amount_Dozakaz)        AS Amount_Dozakaz
                       ,  (tmpDataUnion.AmountSalePartner_Weight)  AS AmountSalePartner_Weight
                       ,  (tmpDataUnion.AmountSalePartner_Sh)      AS AmountSalePartner_Sh
                       ,  (tmpDataUnion.AmountSale_Weight)     AS AmountSale_Weight
                       ,  (tmpDataUnion.AmountSale_Sh)         AS AmountSale_Sh
                       ,  (tmpDataUnion.AmountSale)            AS AmountSale
                       ,  (tmpDataUnion.PriceSale)             AS PriceSale
                       ,  (tmpDataUnion.SumSale)               AS SumSale

                       -- итого по заявке, если 1 заявка и несколько продаж нужно свернуть суммы
                      , SUM (COALESCE (tmpDataUnion.AmountSale_Sh,0))     OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalSale_Sh
                      , SUM (COALESCE (tmpDataUnion.AmountSale_Weight,0)) OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalSale_Weight
                      , SUM (COALESCE (tmpDataUnion.Amount_Sh_Itog,0) + COALESCE (tmpDataUnion.Amount_Sh_Dozakaz,0))         OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalAmount_Sh
                      , SUM (COALESCE (tmpDataUnion.Amount_Weight_Itog,0) + COALESCE (tmpDataUnion.Amount_Weight_Dozakaz,0)) OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalAmount_Weight
                      , SUM (COALESCE (tmpDataUnion.Amount12,0) + COALESCE (tmpDataUnion.Amount_Dozakaz,0))                  OVER (PARTITION BY tmpDataUnion.MovementId_Order, tmpDataUnion.GoodsId, tmpDataUnion.GoodsKindId) AS TotalAmount
                  FROM tmpData1 AS tmpDataUnion
                  )

    , tmpData_All_1 AS (SELECT tmp.OperDate_Order
                           , tmp.OperDatePartner_Order
                           , tmp.OperDate_Sale
                           , tmp.OperDatePartner_Sale
                           , tmp.InvNumber_Sale
                           , tmp.InvNumber_Order
                           , tmp.InvNumberPartner_Order
                           , tmp.FromId
                           , tmp.RouteId
                           , tmp.PaidKindId
                           , tmp.GoodsKindId
                           , tmp.GoodsId
                           , tmp.AmountSumm1
                           , tmp.AmountSumm2
                           , tmp.AmountSummTotal
                           , tmp.AmountSumm_Dozakaz
                           , tmp.Amount_Weight1
                           , tmp.Amount_Sh1
                           , tmp.Amount_Weight2
                           , tmp.Amount_Sh2
                           , tmp.Amount_Weight_Itog
                           , tmp.Amount_Sh_Itog
                           , tmp.Amount_Weight_Dozakaz
                           , tmp.Amount_Sh_Dozakaz
                           , tmp.Amount12
                           , tmp.Amount_Dozakaz
                           , tmp.AmountSalePartner_Weight
                           , tmp.AmountSalePartner_Sh
                           , tmp.AmountSale_Weight
                           , tmp.AmountSale_Sh
                           , tmp.AmountSale
                           , tmp.PriceSale
                           , tmp.SumSale
                           
                          , CASE WHEN COALESCE (tmp.TotalSale_Sh,0) - COALESCE (tmp.TotalAmount_Sh,0) > 0
                                 THEN COALESCE (tmp.TotalSale_Sh,0) - COALESCE (tmp.TotalAmount_Sh,0)
                                 ELSE 0
                            END :: TFloat AS TotalCountDiff_B
                          , CASE WHEN       COALESCE (tmp.TotalSale_Sh,0) - COALESCE (tmp.TotalAmount_Sh,0) < 0
                                 THEN -1 * (COALESCE (tmp.TotalSale_Sh,0) - COALESCE (tmp.TotalAmount_Sh,0))
                                 ELSE 0
                            END :: TFloat AS TotalCountDiff_M

                          , CASE WHEN COALESCE (tmp.TotalSale_Weight,0) - COALESCE (tmp.TotalAmount_Weight,0) > 0
                                 THEN COALESCE (tmp.TotalSale_Weight,0) - COALESCE (tmp.TotalAmount_Weight,0)
                                 ELSE 0
                            END :: TFloat AS TotalWeightDiff_B
                          , CASE WHEN       COALESCE (tmp.TotalSale_Weight,0) - COALESCE (tmp.TotalAmount_Weight,0) < 0
                                 THEN -1 * (COALESCE (tmp.TotalSale_Weight,0) - COALESCE (tmp.TotalAmount_Weight,0))
                                 ELSE 0
                            END :: TFloat AS TotalWeightDiff_M

                           --кол-во заказа по % откл.
                          , (COALESCE (tmp.TotalAmount,0) * vbDiffTax / 100) :: TFloat AS AmountTax
                          --вес заказа по % откл.
                          , (COALESCE (tmp.TotalAmount_Weight,0) * vbDiffTax / 100) :: TFloat AS WeightTax

                          , CASE WHEN COALESCE (tmp.AmountSale_Sh,0) - COALESCE (tmp.Amount_Sh_Itog,0) - COALESCE (tmp.Amount_Sh_Dozakaz,0) > 0
                                 THEN COALESCE (tmp.AmountSale_Sh,0) - COALESCE (tmp.Amount_Sh_Itog,0) - COALESCE (tmp.Amount_Sh_Dozakaz,0)
                                 ELSE 0
                            END :: TFloat AS CountDiff_B
                          , CASE WHEN       COALESCE (tmp.AmountSale_Sh,0) - COALESCE (tmp.Amount_Sh_Itog,0) - COALESCE (tmp.Amount_Sh_Dozakaz,0) < 0
                                 THEN -1 * (COALESCE (tmp.AmountSale_Sh,0) - COALESCE (tmp.Amount_Sh_Itog,0))- COALESCE (tmp.Amount_Sh_Dozakaz,0)
                                 ELSE 0
                            END :: TFloat AS CountDiff_M

                          , CASE WHEN COALESCE (tmp.AmountSale_Weight,0) - COALESCE (tmp.Amount_Weight_Itog,0) - COALESCE (tmp.Amount_Weight_Dozakaz,0) > 0
                                 THEN COALESCE (tmp.AmountSale_Weight,0) - COALESCE (tmp.Amount_Weight_Itog,0)- COALESCE (tmp.Amount_Weight_Dozakaz,0)
                                 ELSE 0
                            END :: TFloat AS WeightDiff_B
                          , CASE WHEN       COALESCE (tmp.AmountSale_Weight,0) - COALESCE (tmp.Amount_Weight_Itog,0)- COALESCE (tmp.Amount_Weight_Dozakaz,0) < 0
                                 THEN -1 * (COALESCE (tmp.AmountSale_Weight,0) - COALESCE (tmp.Amount_Weight_Itog,0)- COALESCE (tmp.Amount_Weight_Dozakaz,0))
                                 ELSE 0
                            END :: TFloat AS WeightDiff_M
                            
                           --кол-во заказа по % откл.
                          --, ((COALESCE (tmp.Amount12,0) + COALESCE (tmp.Amount_Dozakaz,0)) * vbDiffTax / 100) :: TFloat AS AmountTax
                          --вес заказа по % откл.
                          --, ((COALESCE (tmp.Amount_Weight_Itog,0)+ COALESCE (tmp.Amount_Weight_Dozakaz,0)) * vbDiffTax / 100) :: TFloat AS WeightTax
                       FROM tmpData AS tmp
                      )
  , tmpData_All AS (SELECT tmpData_All.*
                         , SUM (COALESCE (tmpData_All.CountDiff_M,0) - COALESCE (tmpData_All.CountDiff_B,0)) OVER (PARTITION BY tmpData_All.InvNumber_Order, tmpData_All.FromId, tmpData_All.GoodsKindId, tmpData_All.GoodsId) AS TotalCount_Diff
                         , SUM (COALESCE (tmpData_All.WeightDiff_M,0) - COALESCE (tmpData_All.WeightDiff_B,0)) OVER (PARTITION BY tmpData_All.InvNumber_Order, tmpData_All.FromId, tmpData_All.GoodsKindId, tmpData_All.GoodsId) AS TotalWeight_Diff
                         , SUM (COALESCE (tmpData_All.AmountTax,0)) OVER (PARTITION BY tmpData_All.InvNumber_Order, tmpData_All.FromId, tmpData_All.GoodsKindId, tmpData_All.GoodsId) AS TotalAmountTax
                         , SUM (COALESCE (tmpData_All.WeightTax,0)) OVER (PARTITION BY tmpData_All.InvNumber_Order, tmpData_All.FromId, tmpData_All.GoodsKindId, tmpData_All.GoodsId) AS TotalWeightTax

           , CASE WHEN (COALESCE (tmpData_All.TotalCountDiff_M,0)  - COALESCE (tmpData_All.TotalCountDiff_B,0) <> 0 AND COALESCE (tmpData_All.TotalCountDiff_M,0)   - COALESCE (tmpData_All.TotalCountDiff_B,0) >= tmpData_All.AmountTax) 
                    OR (COALESCE (tmpData_All.TotalWeightDiff_M,0) - COALESCE (tmpData_All.TotalWeightDiff_B,0) <> 0 AND COALESCE (tmpData_All.TotalWeightDiff_M,0) - COALESCE (tmpData_All.TotalWeightDiff_B,0) >= tmpData_All.WeightTax )
                     THEN TRUE 
                     ELSE FALSE
             END 
             AS isPrint_M
             
                    FROM tmpData_All_1 AS tmpData_All
                    )
       -- запрос
       SELECT
             tmpMovement.OperDate_Order        ::TDateTime    AS OperDate
           , tmpMovement.OperDatePartner_Order ::TDateTime    AS OperDatePartner
           , tmpMovement.OperDate_Sale         ::TDateTime 
           , tmpMovement.OperDatePartner_Sale  ::TDateTime 
           , tmpMovement.InvNumber_Sale         ::TVarChar     AS InvNumber
           --, tmpMovement.InvNumberPartner_Sale         ::TVarChar AS InvNumberPartner_Sale
           , COALESCE (tmpMovement.InvNumberPartner_Order, '')  ::TVarChar AS InvNumberOrderPartner
           , tmpMovement.InvNumber_Order         ::TVarChar     AS InvNumber_Order
           , ObjectDesc_From.ItemName                   AS FromDescName
           , Object_From.Id                             AS FromId
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_Route.Id                            AS RouteId
           , Object_Route.ValueData                     AS RouteName
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

           , tmpMovement.AmountSumm1             ::TFloat       AS AmountSumm1
           , tmpMovement.AmountSumm2             ::TFloat       AS AmountSumm2
           , tmpMovement.AmountSummTotal         ::TFloat       AS AmountSummTotal
           , tmpMovement.AmountSumm_Dozakaz      ::TFloat       AS AmountSumm_Dozakaz

           , tmpMovement.Amount_Weight1          ::TFloat       AS Amount_Weight1
           , tmpMovement.Amount_Sh1              ::TFloat       AS Amount_Sh1
           , tmpMovement.Amount_Weight2          ::TFloat       AS Amount_Weight2
           , tmpMovement.Amount_Sh2              ::TFloat       AS Amount_Sh2
           , tmpMovement.Amount_Weight_Itog      ::TFloat       AS Amount_Weight_Itog
           , tmpMovement.Amount_Sh_Itog          ::TFloat       AS Amount_Sh_Itog

           , tmpMovement.Amount_Weight_Dozakaz   ::TFloat       AS Amount_Weight_Dozakaz
           , tmpMovement.Amount_Sh_Dozakaz       ::TFloat       AS Amount_Sh_Dozakaz
           , tmpMovement.Amount12                ::TFloat       AS Amount_Order
           , tmpMovement.Amount_Dozakaz          ::TFloat       AS Amount_Dozakaz
           , CAST (0 AS TFloat)                  ::TFloat       AS Amount_WeightSK
           , tmpMovement.AmountSalePartner_Weight ::TFloat      AS AmountSalePartner_Weight
           , tmpMovement.AmountSalePartner_Sh     ::TFloat      AS AmountSalePartner_Sh
           , tmpMovement.AmountSale_Weight        ::TFloat      AS AmountSale_Weight
           , tmpMovement.AmountSale_Sh            ::TFloat      AS AmountSale_Sh
           , tmpMovement.AmountSale               ::TFloat      AS AmountSale
           , tmpMovement.PriceSale                ::TFloat
           , tmpMovement.SumSale                  ::TFloat
           , Object_InfoMoney_View.InfoMoneyName        AS InfoMoneyName

           , tmpMovement.TotalCountDiff_B  :: TFloat AS TotalCountDiff_B
           , tmpMovement.TotalCountDiff_M  :: TFloat AS TotalCountDiff_M
           , tmpMovement.TotalWeightDiff_B :: TFloat AS TotalWeightDiff_B
           , tmpMovement.TotalWeightDiff_M :: TFloat AS TotalWeightDiff_M

           , COALESCE (tmpMovement.CountDiff_B,0)  :: TFloat AS CountDiff_B
           , COALESCE (tmpMovement.CountDiff_M,0)  :: TFloat AS CountDiff_M
           , COALESCE (tmpMovement.WeightDiff_B,0) :: TFloat AS WeightDiff_B
           , COALESCE (tmpMovement.WeightDiff_M,0) :: TFloat AS WeightDiff_M
           
           , tmpMovement.TotalWeightDiff_M :: TFloat AS Diff_M
          -- , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMovement.TotalCountDiff_M ELSE tmpMovement.TotalWeightDiff_M END :: TFloat AS Diff_M

          /* , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN COALESCE (tmpMovement.CountDiff_M,0) - COALESCE (tmpMovement.CountDiff_B,0)
                  ELSE COALESCE (tmpMovement.WeightDiff_M,0) - COALESCE (tmpMovement.WeightDiff_B,0)
             END :: TFloat AS Diff_M*/
           , tmpMovement.AmountTax    :: TFloat AS AmountTax
           , tmpMovement.WeightTax    :: TFloat AS WeightTax
           , vbDiffTax                :: TFloat AS DiffTax


          -- , CASE WHEN tmpMovement.isPrint_M = TRUE THEN tmpMovement.AmountSale_Weight ELSE 0 END AS AmountSale_Weight_M
          , tmpMovement.isPrint_M ::Boolean
           /*, CASE WHEN (COALESCE (tmpMovement.TotalCountDiff_M,0)  - COALESCE (tmpMovement.TotalCountDiff_B,0) <> 0 AND COALESCE (tmpMovement.TotalCountDiff_M,0)   - COALESCE (tmpMovement.TotalCountDiff_B,0) >= tmpMovement.AmountTax) 
                    OR (COALESCE (tmpMovement.TotalWeightDiff_M,0) - COALESCE (tmpMovement.TotalWeightDiff_B,0) <> 0 AND COALESCE (tmpMovement.TotalWeightDiff_M,0) - COALESCE (tmpMovement.TotalWeightDiff_B,0) >= tmpMovement.WeightTax )
                     THEN TRUE 
                     ELSE FALSE
             END 
             AS isPrint_M
             */
          /* , CASE WHEN (COALESCE (tmpMovement.TotalCount_Diff,0) <> 0 AND COALESCE (tmpMovement.TotalCount_Diff,0) >= tmpMovement.TotalAmountTax) 
                    OR (COALESCE (tmpMovement.TotalWeight_Diff,0) <> 0 AND COALESCE (tmpMovement.TotalWeight_Diff,0) >= tmpMovement.TotalWeightTax )
                  THEN TRUE 
                  ELSE FALSE
             END              AS isPrint_M*/

           , SUM (CASE WHEN ( tmpMovement.TotalCountDiff_M <> 0 AND tmpMovement.TotalCountDiff_M >= tmpMovement.AmountTax) OR (tmpMovement.TotalWeightDiff_M <> 0 AND tmpMovement.TotalWeightDiff_M >= tmpMovement.WeightTax ) THEN 1 ELSE 0 END) OVER (PARTITION BY Object_From.Id, tmpMovement.InvNumber_Order)  ::TFloat AS CountPrint_M

           --для печати
           , CASE WHEN tmpMovement.isPrint_M = TRUE THEN tmpMovement.AmountSale_Weight ELSE 0 END        ::TFloat AS AmountSale_Weight_M
           , CASE WHEN tmpMovement.isPrint_M = TRUE THEN COALESCE (tmpMovement.Amount_Weight1,0) + COALESCE (tmpMovement.Amount_Weight2,0) ELSE 0 END ::TFloat AS Amount_Weight_M
           , CASE WHEN tmpMovement.isPrint_M = TRUE THEN tmpMovement.Amount_Weight_Dozakaz ELSE 0 END    ::TFloat AS Amount_Weight_Dozakaz_M
           
           --информационно для проверки
           , tmpMovement.TotalCount_Diff ::TFloat
           , tmpMovement.TotalWeight_Diff ::TFloat
           , tmpMovement.TotalAmountTax ::TFloat
           , tmpMovement.TotalWeightTax ::TFloat
       FROM tmpData_All AS tmpMovement
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId
          
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
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
 11.07.18         * 
 06.07.18         *
 09.12.15         * add
 02.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_Sale (inStartDate:= '06.08.2018', inEndDate:= '06.08.2018', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := True, inSession:= '2')