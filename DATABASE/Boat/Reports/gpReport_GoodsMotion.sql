-- Function: gpReport_GoodsMotion ()

DROP FUNCTION IF EXISTS gpReport_GoodsMotion (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMotion (TDateTime, TDateTime, Integer, Integer, Integer, Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMotion (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMotion (
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inUnitGroupId      Integer   ,
    IN inGoodsId          Integer   ,
    IN inPartionId        Integer   ,
    IN inisPartNumber     Boolean   ,
    IN inIsPartion        Boolean  ,  -- показать <Документ партия №> (Да/Нет)
    IN inIsPartner        Boolean  ,  -- показать Поставщика (Да/Нет)
    IN inIsOrderClient    Boolean  ,  -- Заказ клиента №
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE  (LocationId Integer, DescName_location TVarChar, LocationCode Integer, LocationName TVarChar
              , GoodsId Integer, DescName_goods TVarChar, GoodsCode Integer, GoodsName TVarChar
              , PartnerName TVarChar
              , Article TVarChar, Article_all TVarChar
              , PartNumber TVarChar
              , GoodsGroupNameFull TVarChar
              , GoodsGroupName TVarChar
              , MeasureName TVarChar
              , GoodsTagName TVarChar
              , GoodsTypeName TVarChar
              , ProdColorName TVarChar
              , GoodsSizeName TVarChar

              , Price_start TFloat, Price_end TFloat
              , Price_partner_start TFloat, Price_partner_end TFloat

              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat
              , SummStart   TFloat, SummIn   TFloat, SummOut   TFloat, SummEnd   TFloat

              , EKPrice                TFloat -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , CostPrice              TFloat -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , OperPriceList          TFloat -- Цена по прайсу без НДС

                -- Заказ Клиента
              , InvNumberFull_OrderClient TVarChar, FromName_OrderClient TVarChar, ProductName_OrderClient TVarChar, CIN_OrderClient TVarChar

                -- из партии
              , PartionId            Integer
              , MovementId_Partion   Integer
              , InvNumber_Partion    TVarChar
              , InvNumberAll_Partion TVarChar
              , OperDate_Partion     TDateTime
              , DescName_Partion     TVarChar

                -- надо вернуть дату, тогда в гриде не будет кривых данных
              , tmpDate TDateTime             
              )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    -- !!!замена!!!
    IF inIsPartion = TRUE
    THEN
        inIsPartner    := TRUE;
        inIsOrderClient:= TRUE;
    END IF;


    RETURN QUERY
    WITH tmpReceiptGoods AS (-- "виртуальные" узлы
                             SELECT OL.ChildObjectId AS GoodsId
                             FROM ObjectLink AS OL
                                  -- Не удален
                                  INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = OL.ObjectId
                                                                               AND Object_ReceiptGoodsChild.isErased = FALSE

                                  INNER JOIN ObjectLink AS OL_ReceiptGoodsChild_ReceiptGoods
                                                        ON OL_ReceiptGoodsChild_ReceiptGoods.ObjectId = OL.ObjectId
                                                       AND OL_ReceiptGoodsChild_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                  -- Не удален
                                  INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = OL_ReceiptGoodsChild_ReceiptGoods.ChildObjectId
                                                                          AND Object_ReceiptGoods.isErased = FALSE
                             WHERE OL.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                               AND OL.ChildObjectId > 0

                            UNION
                             -- Узлы
                             SELECT OL.ChildObjectId AS GoodsId
                             FROM ObjectLink AS OL
                                  -- Не удален
                                  INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = OL.ObjectId
                                                                          AND Object_ReceiptGoods.isErased = FALSE
                             WHERE OL.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                               AND OL.ChildObjectId > 0
                             
                     )
       , tmpWhere AS (SELECT lfSelect.UnitId               AS LocationId
                      FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect
                      wHERE COALESCE (inUnitGroupId,0) <> 0
                     UNION
                      SELECT Object.Id  AS LocationId
                      FROM Object
                      WHERE Object.DescId = zc_Object_Unit()
                        AND Object.isErased = FALSE
                        AND COALESCE (inUnitGroupId,0) = 0
                     )
       , tmpGoods AS (SELECT inGoodsId AS GoodsId
                      WHERE COALESCE (inGoodsId,0) <> 0
                     UNION
                      SELECT Object.Id AS LocationId
                      FROM Object
                      WHERE Object.DescId = zc_Object_Goods()
                        AND Object.isErased = FALSE
                        AND COALESCE (inGoodsId,0) = 0
                     UNION
                      SELECT Object.Id  AS LocationId
                      FROM Object
                      WHERE Object.DescId = zc_Object_Product()
                        AND Object.isErased = FALSE
                        AND COALESCE (inGoodsId,0) = 0
                     )
       , tmpPriceBasis AS (SELECT tmp.GoodsId
                                , tmp.ValuePrice
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                    , inOperDate   := CURRENT_DATE) AS tmp
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
                          )
         -- список Container_Count
       , tmpContainer_Count AS (SELECT Container.Id              AS ContainerId
                                     , Container.WhereObjectId   AS LocationId
                                     , Container.ObjectId        AS GoodsId
                                     , Container.PartionId       AS PartionId
                                     , Container.Amount          AS Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND (Container.PartionId = inPartionId OR inPartionId = 0)
                                     INNER JOIN tmpWhere ON tmpWhere.LocationId = Container.WhereObjectId
                               )

         -- проводки Container_Count
       , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                              , tmpContainer_Count.LocationId
                              , tmpContainer_Count.GoodsId
                              , tmpContainer_Count.PartionId
                                -- за период
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0
                                               THEN 1 * MIContainer.Amount
                                          ELSE 0
                                     END) AS AmountIn
                                -- за период
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0
                                               THEN -1 * MIContainer.Amount
                                          ELSE 0
                                     END) AS AmountOut
                                -- Остаток начальный
                              , tmpContainer_Count.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS AmountStart
                                -- Остаток конечный
                              , tmpContainer_Count.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END) AS AmountEnd

                         FROM tmpContainer_Count
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                             AND MIContainer.OperDate    >= inStartDate
                         GROUP BY tmpContainer_Count.ContainerId
                                , tmpContainer_Count.LocationId
                                , tmpContainer_Count.GoodsId
                                , tmpContainer_Count.PartionId
                                , tmpContainer_Count.Amount
                        )
         -- список Container_Summ
       , tmpContainer_Summ AS (SELECT tmpContainer_Count.ContainerId AS ContainerId_Count
                                    , Container.Id                   AS ContainerId
                                    , Container.Amount               AS Amount
                               FROM tmpContainer_Count
                                    INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                        AND Container.DescId   = zc_Container_Summ()
                                )
      -- проводки Container_summ
    , tmpMI_Summ_all AS (SELECT tmpContainer_Summ.ContainerId_Count
                              , tmpContainer_Summ.ContainerId
                                -- за период
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount > 0
                                               THEN 1 * MIContainer.Amount
                                          ELSE 0
                                     END) AS AmountIn
                                -- за период
                              , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.Amount < 0
                                               THEN -1 * MIContainer.Amount
                                          ELSE 0
                                     END) AS AmountOut
                                -- Остаток начальный
                              , tmpContainer_Summ.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS AmountStart
                                -- Остаток конечный
                              , tmpContainer_Summ.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END) AS AmountEnd
                        FROM tmpContainer_Summ
                             LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId
                                                                           AND MIContainer.OperDate    >= inStartDate
                        GROUP BY tmpContainer_Summ.ContainerId_Count
                               , tmpContainer_Summ.ContainerId
                               , tmpContainer_Summ.Amount
                       )
         -- проводки Container_summ
        , tmpMI_Summ AS (SELECT tmpMI_Summ_all.ContainerId_Count
                                -- за период
                              , SUM (tmpMI_Summ_all.AmountIn)    AS AmountIn
                                -- за период
                              , SUM (tmpMI_Summ_all.AmountOut)   AS AmountOut
                                -- Остаток начальный
                              , SUM (tmpMI_Summ_all.AmountStart) AS AmountStart
                                -- Остаток конечный
                              , SUM (tmpMI_Summ_all.AmountEnd)   AS AmountEnd
                        FROM tmpMI_Summ_all
                        GROUP BY tmpMI_Summ_all.ContainerId_Count
                       )
      -- кол-во + суммы
    , tmpMIContainer_group AS (SELECT tmpMI_Count.ContainerId
                                    , tmpMI_Count.LocationId
                                    , tmpMI_Count.GoodsId
                                    , tmpMI_Count.PartionId
                                      --
                                    , tmpMI_Count.AmountStart
                                    , tmpMI_Count.AmountEnd
                                    , tmpMI_Count.AmountIn
                                    , tmpMI_Count.AmountOut
                                      --
                                    , COALESCE (tmpMI_Summ.AmountStart, 0) AS SummStart
                                    , COALESCE (tmpMI_Summ.AmountEnd, 0)   AS SummEnd
                                    , COALESCE (tmpMI_Summ.AmountIn, 0)    AS SummIn
                                    , COALESCE (tmpMI_Summ.AmountOut, 0)   AS SummOut
                               FROM tmpMI_Count
                                    LEFT JOIN tmpMI_Summ ON tmpMI_Summ.ContainerId_Count = tmpMI_Count.ContainerId
                              )
    -- S/N
  , tmpMIString AS (SELECT *
                    FROM MovementItemString AS MIString_PartNumber
                    WHERE MIString_PartNumber.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.PartionId FROM tmpMIContainer_group)
                      AND MIString_PartNumber.DescId    = zc_MIString_PartNumber()
                      AND MIString_PartNumber.ValueData <> ''
                   )
    -- Заказ Клиента
  , tmpMIFloat_OrderClient AS (SELECT MIFloat_MovementId.MovementItemId
                                    , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
                                    , Object_From.ValueData AS FromName_OrderClient
                                    , zfCalc_ValueData_isErased (Object_Product.ValueData,   Object_Product.isErased) AS ProductName_OrderClient
                                    , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN_OrderClient
                               FROM MovementItemFloat AS MIFloat_MovementId
                                    LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData ::Integer

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                                    LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

                                    LEFT JOIN ObjectString AS ObjectString_CIN
                                                           ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                          AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                               WHERE MIFloat_MovementId.MovementItemId IN (SELECT DISTINCT tmpMIContainer_group.PartionId FROM tmpMIContainer_group)
                                 AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                 AND inIsOrderClient = TRUE
                              )
          -- РЕЗУЛЬТАТ
        , tmpDataAll AS (SELECT tmpMIContainer_group.LocationId
                              , tmpMIContainer_group.GoodsId
                                -- если нужна "партия"
                              , CASE WHEN inIsPartion = TRUE THEN tmpMIContainer_group.PartionId ELSE 0 END AS PartionId

                                -- из партии
                              , Object_PartionGoods.GoodsSizeId
                              , Object_PartionGoods.MeasureId
                              , Object_PartionGoods.GoodsGroupId
                              , Object_PartionGoods.GoodsTagId
                              , Object_PartionGoods.GoodsTypeId
                              , Object_PartionGoods.ProdColorId
                                -- если нужен "поставщик"
                              , CASE WHEN inIsPartner = TRUE THEN Object_PartionGoods.FromId ELSE 0 END AS FromId_partion

                                -- S/N
                              , STRING_AGG (DISTINCT MIString_PartNumber.ValueData, '; ') AS PartNumber

                                -- Заказ Клиента
                              , MIFloat_MovementId.InvNumberFull_OrderClient
                              , MIFloat_MovementId.FromName_OrderClient
                              , MIFloat_MovementId.ProductName_OrderClient
                              , MIFloat_MovementId.CIN_OrderClient

                                -- кол-во
                              , SUM (tmpMIContainer_group.AmountStart) AS AmountStart
                              , SUM (tmpMIContainer_group.AmountIn)    AS AmountIn
                              , SUM (tmpMIContainer_group.AmountOut)   AS AmountOut
                              , SUM (tmpMIContainer_group.AmountEnd)   AS AmountEnd
                                -- суммы
                              , SUM (tmpMIContainer_group.SummStart)   AS SummStart
                              , SUM (tmpMIContainer_group.SummIn)      AS SummIn
                              , SUM (tmpMIContainer_group.SummOut)     AS SummOut
                              , SUM (tmpMIContainer_group.SummEnd)     AS SummEnd

                                -- информативно по партии - Кол-во приход
                              , SUM (MovementItem.Amount) AS Amount_partion

                         FROM tmpMIContainer_group
                              -- партия
                              LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer_group.PartionId
                                                           AND Object_PartionGoods.ObjectId       = tmpMIContainer_group.GoodsId
                                                         --AND Object_PartionGoods.isErased       = FALSE
                              -- S/N
                              LEFT JOIN tmpMIString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = tmpMIContainer_group.PartionId
                              -- Заказ Клиента
                              LEFT JOIN tmpMIFloat_OrderClient AS MIFloat_MovementId
                                                               ON MIFloat_MovementId.MovementItemId = tmpMIContainer_group.PartionId
                              -- элемент партии
                              LEFT JOIN MovementItem ON MovementItem.MovementId = Object_PartionGoods.MovementId
                                                    AND MovementItem.Id         = Object_PartionGoods.MovementItemId
                                                    -- !!!только когда по партиям!!!
                                                    AND inIsPartion             = TRUE
                         GROUP BY tmpMIContainer_group.LocationId
                                , tmpMIContainer_group.GoodsId
                                  -- если нужна "партия"
                                , CASE WHEN inIsPartion = TRUE THEN tmpMIContainer_group.PartionId ELSE 0 END

                                 -- из партии
                                , Object_PartionGoods.GoodsSizeId
                                , Object_PartionGoods.MeasureId
                                , Object_PartionGoods.GoodsGroupId
                                , Object_PartionGoods.GoodsTagId
                                , Object_PartionGoods.GoodsTypeId
                                , Object_PartionGoods.ProdColorId
                                  -- если нужен "поставщик"
                                , CASE WHEN inIsPartner = TRUE THEN Object_PartionGoods.FromId ELSE 0 END

                                  -- если нужно разделение по S/N
                                , CASE WHEN inIsPartNumber = TRUE THEN MIString_PartNumber.ValueData ELSE '' END

                                  -- Заказ Клиента
                                , MIFloat_MovementId.InvNumberFull_OrderClient
                                , MIFloat_MovementId.FromName_OrderClient
                                , MIFloat_MovementId.ProductName_OrderClient
                                , MIFloat_MovementId.CIN_OrderClient

                         HAVING SUM (tmpMIContainer_group.AmountStart) <> 0
                             OR SUM (tmpMIContainer_group.AmountIn)    <> 0
                             OR SUM (tmpMIContainer_group.AmountOut)   <> 0
                             OR SUM (tmpMIContainer_group.AmountEnd)   <> 0
                             OR SUM (tmpMIContainer_group.SummStart)   <> 0
                             OR SUM (tmpMIContainer_group.SummIn)      <> 0
                             OR SUM (tmpMIContainer_group.SummOut)     <> 0
                             OR SUM (tmpMIContainer_group.SummEnd)     <> 0
                        )

       -- РЕЗУЛЬТАТ
       SELECT tmpDataAll.LocationId        AS LocationId
            , ObjectDesc_Location.ItemName AS DescName_location
            , Object_Location.ObjectCode   AS LocationCode
            , Object_Location.ValueData    AS LocationName

            , tmpDataAll.GoodsId           AS GoodsId
            , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN 'Узел' ELSE ObjectDesc_Goods.ItemName END :: TVarChar AS DescName_goods
            , Object_Goods.ObjectCode      AS GoodsCode
            , Object_Goods.ValueData       AS GoodsName
            , Object_Partner.ValueData     AS PartnerName

            , ObjectString_Article.ValueData                                AS Article
            , zfCalc_Article_all (ObjectString_Article.ValueData)::TVarChar AS Article_all

            , tmpDataAll.PartNumber        :: TVarChar AS PartNumber

            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_GoodsGroup.ValueData           AS GoodsGroupName
            , Object_Measure.ValueData              AS MeasureName
            , Object_GoodsTag.ValueData             AS GoodsTagName
            , Object_GoodsType.ValueData            AS GoodsTypeName
            , Object_ProdColor.ValueData            AS ProdColorName
            , Object_GoodsSize.ValueData ::TVarChar AS GoodsSizeName

              -- нач. Цена вх.
            , CASE WHEN tmpDataAll.AmountStart <> 0 THEN tmpDataAll.SummStart / tmpDataAll.AmountStart
                   WHEN Object_PartionGoods.MovementItemId > 0 AND Object_PartionGoods.EKPrice <> 0 THEN Object_PartionGoods.EKPrice
                   WHEN tmpDataAll.AmountIn    <> 0 THEN tmpDataAll.SummIn    / tmpDataAll.AmountIn
                   WHEN tmpDataAll.AmountOut   <> 0 THEN tmpDataAll.SummOut   / tmpDataAll.AmountOut
                   WHEN tmpDataAll.AmountEnd   <> 0 THEN tmpDataAll.SummEnd   / tmpDataAll.AmountEnd
                   ELSE 0
              END :: TFloat AS Price_start

              -- конеч. Цена вх.
            , CASE WHEN tmpDataAll.AmountEnd   <> 0 THEN tmpDataAll.SummEnd   / tmpDataAll.AmountEnd
                   WHEN Object_PartionGoods.MovementItemId > 0 AND Object_PartionGoods.EKPrice <> 0 THEN Object_PartionGoods.EKPrice
                   WHEN tmpDataAll.AmountStart <> 0 THEN tmpDataAll.SummStart / tmpDataAll.AmountStart
                   WHEN tmpDataAll.AmountIn    <> 0 THEN tmpDataAll.SummIn    / tmpDataAll.AmountIn
                   WHEN tmpDataAll.AmountOut   <> 0 THEN tmpDataAll.SummOut   / tmpDataAll.AmountOut
                   ELSE 0
              END :: TFloat AS Price_end

            , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inStartDate, tmpDataAll.GoodsId, vbUserId) AS lpGet) :: TFloat  AS Price_partner_start
            , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inEndDate, tmpDataAll.GoodsId, vbUserId) AS lpGet)   :: TFloat  AS Price_partner_end

            , CAST (tmpDataAll.AmountStart AS NUMERIC (16,2)) ::TFloat  AS AmountStart
            , CAST (tmpDataAll.AmountIn    AS NUMERIC (16,2)) ::TFloat  AS AmountIn
            , CAST (tmpDataAll.AmountOut   AS NUMERIC (16,2)) ::TFloat  AS AmountOut
            , CAST (tmpDataAll.AmountEnd   AS NUMERIC (16,2)) ::TFloat  AS AmountEnd

            , CAST (tmpDataAll.SummStart   AS NUMERIC (16,2)) ::TFloat  AS SummStart
            , CAST (tmpDataAll.SummIn      AS NUMERIC (16,2)) ::TFloat  AS SummIn
            , CAST (tmpDataAll.SummOut     AS NUMERIC (16,2)) ::TFloat  AS SummOut
            , CAST (tmpDataAll.SummEnd     AS NUMERIC (16,2)) ::TFloat  AS SummEnd

              -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
            , Object_PartionGoods.EKPrice   :: TFloat AS EKPrice
              -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
            , Object_PartionGoods.CostPrice :: TFloat AS CostPrice
              -- Цена по прайсу без НДС
            , tmpPriceBasis.ValuePrice      :: TFloat AS OperPriceList

              -- Заказ Клиента
            , tmpDataAll.InvNumberFull_OrderClient   ::TVarChar
            , tmpDataAll.FromName_OrderClient        ::TVarChar
            , tmpDataAll.ProductName_OrderClient     ::TVarChar
            , tmpDataAll.CIN_OrderClient             ::TVarChar

              -- из партии
            , tmpDataAll.PartionId        :: Integer AS PartionId
            , Object_PartionGoods.MovementId         AS MovementId_Partion
            , Movement_Partion.InvNumber             AS InvNumber_Partion
            , zfCalc_InvNumber_isErased (MovementDesc_Partion.ItemName, Movement_Partion.InvNumber, Movement_Partion.OperDate, Movement_Partion.StatusId) AS InvNumberAll_Partion
            , Movement_Partion.OperDate              AS OperDate_Partion
            , MovementDesc_Partion.ItemName          AS DescName_Partion

              -- надо вернуть дату, тогда в гриде не будет кривых данных
            , CURRENT_TIMESTAMP :: TDateTime   AS tmpDate

       FROM tmpDataAll
            -- партия
            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpDataAll.GoodsId
       
            -- партия
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpDataAll.PartionId
                                         AND Object_PartionGoods.ObjectId       = tmpDataAll.GoodsId
            -- цена из Прайс-листа
            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpDataAll.GoodsId

            LEFT JOIN Object AS Object_Partner  ON Object_Partner.Id  = tmpDataAll.FromId_partion
            LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpDataAll.GoodsId
            LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpDataAll.LocationId

            LEFT JOIN ObjectDesc AS ObjectDesc_Location ON ObjectDesc_Location.Id = Object_Location.DescId
            LEFT JOIN ObjectDesc AS ObjectDesc_Goods    ON ObjectDesc_Goods.Id    = Object_Goods.DescId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpDataAll.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpDataAll.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpDataAll.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpDataAll.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpDataAll.ProdColorId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpDataAll.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpDataAll.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpDataAll.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()

            LEFT JOIN Movement     AS Movement_Partion     ON Movement_Partion.Id     = Object_PartionGoods.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.04.22         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMotion(inStartDate := ('02.03.2020')::TDateTime , inEndDate := ('03.03.2023')::TDateTime , inUnitGroupId := 0, inGoodsId := 0 ,inPartionId := 0, inisPartNumber:=true, inIsPartion:=false, inIsPartner:=true, inIsOrderClient:=false, inSession := '5');
