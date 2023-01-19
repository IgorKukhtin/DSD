-- Function:  gpReport_Goods_RemainsCurrent()

DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_RemainsCurrent(
    IN inUnitId           Integer  ,  -- Подразделение / группа
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inGoodsGroupId     Integer  ,  -- группа товара
    IN inIsPartion        Boolean  ,  -- показать <Документ партия №> (Да/Нет)
    IN inIsPartner        Boolean  ,  -- показать Поставщика (Да/Нет)
    IN inIsZero           Boolean  ,  -- Показать с остатком = 0
    IN inIsPartNumber     Boolean  ,  -- по серийным номерам
    IN inIsOrderClient    Boolean  ,  -- Заказ клиента №
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PartionId            Integer
             , MovementId_Partion   Integer
             , InvNumber_Partion    TVarChar
             , InvNumberAll_Partion TVarChar
             , OperDate_Partion     TDateTime
             , DescName_Partion     TVarChar
             , UnitName_Partion     TVarChar
             , FromName_Partion     TVarChar

             , UnitId               Integer
             , UnitName             TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, Article_all TVarChar, PartNumber TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar

             , GoodsTagName         TVarChar
             , GoodsTypeName        TVarChar
             , ProdColorName        TVarChar
             , GoodsSizeName        TVarChar

             , PriceListId_Basis    Integer
             , PriceListName_Basis  TVarChar

             , Amount_partion          TFloat    -- кол-во Приход в партии
             , EKPrice                 TFloat    -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
             , CountForPrice           TFloat    -- Кол. в цене вх.
             , OperPriceList           TFloat    -- Цена по прайсу без НДС
             , CostPrice               TFloat    -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)

             , Remains                 TFloat    -- Факт Кол-во - остаток
             , Remains_sum             TFloat    -- Факт Сумма - остаток
             , EKPrice_remains         TFloat    -- Цена вх. без НДС, для остатка
             , SummCost_remains        TFloat    -- Сумма затрат
             , SummPriceList_remains   TFloat    -- Сумма по прайсу

             , PriceTax                TFloat    -- % наценки

             , Amount_reserve          TFloat

             , Comment_Partion         TVarChar
             , VATPercent_Partion      TFloat

             , InvNumberFull_OrderClient TVarChar, FromName_OrderClient TVarChar, ProductName_OrderClient TVarChar, CIN_OrderClient TVarChar
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsOperPrice Boolean;
   DECLARE vbPriceListName_Basis TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- Получили - показывать ЛИ цену ВХ.
    --vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId) OR vbUserId = 1078646;

    -- для возможности изменениея цен добавояем прайс лист Базис
    vbPriceListName_Basis := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_PriceList_Basis()) ::TVarChar;

    -- !!!замена!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
    END IF;

    -- список подразделений
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId, 0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT lfSelect.UnitId
          FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT Object_Unit.Id
          FROM Object AS Object_Unit
          WHERE Object_Unit.DescId = zc_Object_Unit()
            AND Object_Unit.isErased = FALSE;
    END IF;


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfSelect.GoodsId
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object_Goods.Id
           FROM Object AS Object_Goods
           WHERE Object_Goods.DescId = zc_Object_Goods()
            AND Object_Goods.isErased = FALSE;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;

    -- Результат
    RETURN QUERY
    WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                , tmp.ValuePrice
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                    , inOperDate   := CURRENT_DATE) AS tmp
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmp.GoodsId
                          )
     -- остатки
   , tmpContainer_All AS (SELECT Container.*
                          FROM Container
                               -- Ограничение - Подразделение
                               INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                               -- Ограничение - Товары
                               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId

                           WHERE Container.DescId = zc_Container_Count()
                             -- только остатки или все
                             AND (Container.Amount <> 0 OR inIsZero = TRUE)
                         )

   , tmpContainer_Summ AS (SELECT tmpContainer_All.Id AS ContainerId_Count
                                , tmpContainer_All.ObjectId
                                , tmpContainer_All.PartionId
                                , SUM (COALESCE (Container.Amount,0)) AS Amount      -- Сумма
                           FROM tmpContainer_All
                                INNER JOIN Container ON Container.ParentId = tmpContainer_All.Id
                                                    AND Container.DescId   = zc_Container_Summ()
                           GROUP BY tmpContainer_All.Id
                                  , tmpContainer_All.ObjectId
                                  , tmpContainer_All.PartionId
                          )
     -- Партии
   , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                FROM Object_PartionGoods
                                WHERE Object_PartionGoods.ObjectId IN (SELECT DISTINCT tmpContainer_All.ObjectId FROM tmpContainer_All)
                               )

     -- Резерв кол-во из zc_Movement_OrderClient.zc_MI_Child
   , tmpReserv AS (SELECT MovementItem.PartionId            AS PartionId
                        , MILinkObject_Unit.ObjectId        AS UnitId
                        , MovementItem.ObjectId             AS ObjectId
                        , SUM (COALESCE (MovementItem.Amount, 0)) AS Amount
                   FROM Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId     = zc_MI_Child()
                                               AND MovementItem.isErased   = FALSE

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                   WHERE Movement.DescId = zc_Movement_OrderClient()
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                     AND COALESCE (MovementItem.Amount,0) > 0
                     AND COALESCE (MILinkObject_Goods.ObjectId, 0) = 0
                   GROUP BY MovementItem.PartionId
                          , MILinkObject_Unit.ObjectId
                          , MovementItem.ObjectId
                  )
     -- Остатки + Партии
   , tmpContainer AS (SELECT Container.PartionId            AS PartionId
                           , Container.ObjectId             AS GoodsId
                           , Container.WhereObjectId        AS UnitId
                             -- Остаток кол-во
                           , Container.Amount               AS Remains
                             -- Остаток сумма
                           , COALESCE (tmpContainer_Summ.Amount, 0) AS Remains_sum
                             --
                           , Object_PartionGoods.FromId
                           , Object_PartionGoods.GoodsSizeId
                           , Object_PartionGoods.MeasureId
                           , Object_PartionGoods.GoodsGroupId
                           , Object_PartionGoods.GoodsTagId
                           , Object_PartionGoods.GoodsTypeId
                           , Object_PartionGoods.ProdColorId
                           , Object_PartionGoods.TaxKindId AS TaxKindId
                           , Object_PartionGoods.TaxValue  AS TaxKindValue

                           , Object_PartionGoods.MovementId

                             -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
                           , Object_PartionGoods.EKPrice
                           , Object_PartionGoods.CountForPrice

                             -- Цена по прайсу без НДС
                           , COALESCE (tmpPriceBasis.ValuePrice, Object_PartionGoods.OperPriceList) AS OperPriceList

                             -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
                           , Object_PartionGoods.CostPrice

                           , Object_PartionGoods.UnitId     AS UnitId_partion

                           , COALESCE (tmpReserv.Amount,0) AS Amount_reserve

                             --  № п/п - только для = 1 возьмем Amount_partion
                           , ROW_NUMBER() OVER (PARTITION BY Container.PartionId ORDER BY CASE WHEN Container.WhereObjectId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord

                      FROM tmpContainer_All AS Container
                           LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                        AND Object_PartionGoods.ObjectId       = Container.ObjectId

                           LEFT JOIN tmpContainer_Summ ON tmpContainer_Summ.ContainerId_Count = Container.Id
                                                      AND tmpContainer_Summ.PartionId         = Container.PartionId
                                                      AND tmpContainer_Summ.ObjectId          = Container.ObjectId
                            -- цена из Прайс-листа
                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Container.ObjectId

                           -- Резерв кол-во из zc_Movement_OrderClient.zc_MI_Child
                           LEFT JOIN tmpReserv ON tmpReserv.PartionId = Container.PartionId
                                              AND tmpReserv.ObjectId  = Container.ObjectId
                                              AND tmpReserv.UnitId    = Container.WhereObjectId

                      WHERE (Object_PartionGoods.FromId = inPartnerId OR inPartnerId = 0)
                     )
         --
       , tmpMovementString AS (SELECT MovementString.*
                               FROM MovementString
                               WHERE MovementString.MovementId IN (SELECT DISTINCT tmpContainer.MovementId FROM tmpContainer)
                                 AND MovementString.DescId = zc_MovementString_Comment()
                                 AND inIsPartion = TRUE
                              )
       , tmpMovementFloat AS (SELECT MovementFloat.*
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpContainer.MovementId FROM tmpContainer)
                                AND MovementFloat.DescId = zc_MovementFloat_VATPercent()
                                AND inIsPartion = TRUE
                             )
       , tmpMIString AS (SELECT *
                         FROM MovementItemString AS MIString_PartNumber
                         WHERE MIString_PartNumber.MovementItemId IN (SELECT DISTINCT tmpContainer.PartionId FROM tmpContainer)
                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                        )
       , tmpMIFloat_OrderClient AS (SELECT MIFloat_MovementId.MovementItemId
                                         , MIFloat_MovementId.ValueData ::Integer
                                         , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
                                         , Object_From.ValueData                                     AS FromName
                                         , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
                                         , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
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

                                    WHERE MIFloat_MovementId.MovementItemId IN (SELECT DISTINCT tmpContainer.PartionId FROM tmpContainer)
                                      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                      AND inIsOrderClient = TRUE
                                   )
           , tmpData AS (SELECT tmpContainer.UnitId
                              , tmpContainer.GoodsId

                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.PartionId        ELSE 0    END AS PartionId
                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.MovementId       ELSE 0    END AS MovementId_Partion
                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.UnitId_partion   ELSE 0    END AS UnitId_partion

                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.EKPrice          ELSE 0  END AS EKPrice
                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.CostPrice        ELSE 0  END AS CostPrice
                              , CASE WHEN inIsPartion = TRUE THEN tmpContainer.OperPriceList    ELSE 0  END AS OperPriceList

                              , CASE WHEN inIsPartner = TRUE THEN tmpContainer.FromId           ELSE 0  END AS FromId_Partion

                                --  только для Ord = 1
                              , SUM (CASE WHEN tmpContainer.Ord = 1 THEN MovementItem.Amount ELSE 0 END) AS Amount_partion

                              , STRING_AGG (MIString_PartNumber.ValueData, ' ;')  AS PartNumber

                              , tmpContainer.GoodsSizeId
                              , tmpContainer.MeasureId
                              , tmpContainer.GoodsGroupId
                              , tmpContainer.GoodsTagId
                              , tmpContainer.GoodsTypeId
                              , tmpContainer.ProdColorId

                                -- если вдруг остаток = 0, покажем эти
                              , MAX (tmpContainer.EKPrice)          AS EKPrice_max
                              , MAX (tmpContainer.CostPrice)        AS CostPrice_max
                              , MAX (tmpContainer.OperPriceList)    AS OperPriceList_max

                                -- Остаток кол-во
                              , SUM (tmpContainer.Remains)         AS Remains
                                -- Остаток сумма
                              , SUM (tmpContainer.Remains_sum)     AS Remains_sum
                                -- Сумма затрат - Факт остаток
                              , SUM (zfCalc_SummIn (tmpContainer.Remains, tmpContainer.CostPrice, tmpContainer.CountForPrice)) AS SummCost_remains
                                -- Сумма по прайсу - Факт остаток
                              , SUM (zfCalc_SummPriceList (tmpContainer.Remains, tmpContainer.OperPriceList))                  AS SummPriceList_remains
                                -- Резерв
                              , SUM (tmpContainer.Amount_reserve)  AS Amount_reserve

                                -- OrderClient
                              , MIFloat_MovementId.InvNumberFull_OrderClient AS InvNumberFull_OrderClient
                              , MIFloat_MovementId.FromName                  AS FromName_OrderClient
                              , MIFloat_MovementId.ProductName               AS ProductName_OrderClient
                              , MIFloat_MovementId.CIN                       AS CIN_OrderClient
  
                         FROM tmpContainer
                              LEFT JOIN tmpMIString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = tmpContainer.PartionId
                              LEFT JOIN MovementItem ON MovementItem.Id = tmpContainer.PartionId

                              LEFT JOIN tmpMIFloat_OrderClient AS MIFloat_MovementId
                                                               ON MIFloat_MovementId.MovementItemId = tmpContainer.PartionId
                                                              AND COALESCE (MIFloat_MovementId.ValueData,0) <> 0
                         GROUP BY tmpContainer.UnitId
                                , tmpContainer.GoodsId

                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.PartionId        ELSE 0    END
                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.MovementId       ELSE 0    END
                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.UnitId_partion   ELSE 0    END

                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.EKPrice          ELSE 0    END
                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.CostPrice        ELSE 0    END
                                , CASE WHEN inIsPartion = TRUE THEN tmpContainer.OperPriceList    ELSE 0    END

                                  -- FromId_Partion
                                , CASE WHEN inIsPartner = TRUE THEN tmpContainer.FromId           ELSE 0 END

                                  -- PartNumber
                                , CASE WHEN inIsPartNumber = TRUE THEN MIString_PartNumber.ValueData ELSE '' END

                                , tmpContainer.GoodsSizeId
                                , tmpContainer.MeasureId
                                , tmpContainer.GoodsGroupId
                                , tmpContainer.GoodsTagId
                                , tmpContainer.GoodsTypeId
                                , tmpContainer.ProdColorId

                                  -- OrderClient
                                , MIFloat_MovementId.InvNumberFull_OrderClient
                                , MIFloat_MovementId.FromName
                                , MIFloat_MovementId.ProductName
                                , MIFloat_MovementId.CIN
                  )
        -- Результат
        SELECT
             tmpData.PartionId                      AS PartionId
           , tmpData.MovementId_Partion             AS MovementId_Partion
           , Movement_Partion.InvNumber             AS InvNumber_Partion
           , zfCalc_InvNumber_isErased (MovementDesc_Partion.ItemName, Movement_Partion.InvNumber, Movement_Partion.OperDate, Movement_Partion.StatusId) AS InvNumberAll_Partion
           , Movement_Partion.OperDate              AS OperDate_Partion
           , MovementDesc_Partion.ItemName          AS DescName_Partion

           , Object_Unit_partion.ValueData          AS UnitName_Partion
           , Object_From_partion.ValueData          AS FromName_Partion

           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData AS Article
           , zfCalc_Article_all (ObjectString_Article.ValueData)::TVarChar AS Article_all
           , tmpData.PartNumber ::TVarChar
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName

           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_GoodsSize.ValueData     AS GoodsSizeName

           , Object_PriceList_Basis.Id         ::Integer  AS PriceListId_Basis
           , Object_PriceList_Basis.ValueData  ::TVarChar AS PriceListName_Basis

             -- Кол-во - Партия прихода
           , tmpData.Amount_partion    :: TFloat AS Amount_partion

             -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
           , CASE WHEN tmpData.EKPrice <> 0 THEN tmpData.EKPrice
                  WHEN tmpData.Remains_sum <> 0 AND tmpData.Remains <> 0 THEN tmpData.Remains_sum / tmpData.Remains
                  ELSE tmpData.EKPrice_max
             END :: TFloat AS EKPrice

           , 1 :: TFloat AS CountForPrice

             -- Цена по прайсу без НДС
           , CASE WHEN tmpData.OperPriceList <> 0 THEN tmpData.OperPriceList
                  WHEN tmpData.SummPriceList_remains <> 0 AND tmpData.Remains <> 0 THEN tmpData.SummPriceList_remains / tmpData.Remains
                  ELSE tmpData.OperPriceList_max
             END :: TFloat AS OperPriceList

             -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
           , CASE WHEN tmpData.CostPrice <> 0 THEN tmpData.CostPrice
                  WHEN tmpData.SummCost_remains <> 0 AND tmpData.Remains <> 0 THEN tmpData.SummCost_remains / tmpData.Remains
                  ELSE tmpData.CostPrice_max
             END :: TFloat AS CostPrice

             -- Кол-во остаток
           , tmpData.Remains :: TFloat AS Remains
             -- Сумма вх. без НДС (остаток)
           , tmpData.Remains_sum :: TFloat AS Remains_sum
             -- Цена вх. без НДС (остаток) , с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
           , CASE WHEN tmpData.Remains_sum <> 0 AND tmpData.Remains <> 0 THEN tmpData.Remains_sum / tmpData.Remains
                  WHEN tmpData.EKPrice <> 0 THEN tmpData.EKPrice
                  ELSE tmpData.EKPrice_max
             END :: TFloat AS EKPrice

             -- Сумма затрат без НДС (остаток) 
           , tmpData.SummCost_remains :: TFloat AS SummCost_remains
             -- Сумма по прайсу без НДС (остаток) 
           , tmpData.SummPriceList_remains :: TFloat AS SummPriceList_remains


             -- % наценки
           , (zfCalc_Value_VAT (CASE WHEN tmpData.Remains_sum <> 0 AND tmpData.Remains <> 0 THEN tmpData.Remains_sum / tmpData.Remains
                                     WHEN tmpData.EKPrice <> 0 THEN tmpData.EKPrice
                                     ELSE tmpData.EKPrice_max
                                END
                              , CASE WHEN tmpData.OperPriceList <> 0 THEN tmpData.OperPriceList
                                     WHEN tmpData.SummPriceList_remains <> 0 AND tmpData.Remains <> 0 THEN tmpData.SummPriceList_remains / tmpData.Remains
                                     ELSE tmpData.OperPriceList_max
                                END
                               ) :: NUMERIC (16, 1)) :: TFloat AS PriceTax

           -- резерв
           , COALESCE (tmpData.Amount_reserve,0) ::TFloat AS Amount_reserve

           , MS_Comment.ValueData         AS Comment_Partion
           , MF_VATPercent.ValueData      AS VATPercent_Partion

           , tmpData.InvNumberFull_OrderClient   ::TVarChar
           , tmpData.FromName_OrderClient        ::TVarChar
           , tmpData.ProductName_OrderClient     ::TVarChar
           , tmpData.CIN_OrderClient             ::TVarChar

        FROM tmpData
            LEFT JOIN Object AS Object_Unit       ON Object_Unit.Id       = tmpData.UnitId
            LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpData.GoodsSizeId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpData.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpData.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpData.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpData.ProdColorId

            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = tmpData.UnitId_partion
            LEFT JOIN Object AS Object_From_partion ON Object_From_partion.Id = tmpData.FromId_Partion

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()

            LEFT JOIN Object AS Object_PriceList_Basis ON Object_PriceList_Basis.Id = zc_PriceList_Basis()

            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpData.MovementId_Partion
            LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

            LEFT JOIN tmpMovementString AS MS_Comment
                                        ON MS_Comment.MovementId = tmpData.MovementId_Partion
                                       AND MS_Comment.DescId     = zc_MovementString_Comment()
            LEFT JOIN tmpMovementFloat AS MF_VATPercent
                                       ON MF_VATPercent.MovementId = tmpData.MovementId_Partion
                                      AND MF_VATPercent.DescId     = zc_MovementFloat_VATPercent()


           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.21         *
*/
-- тест
-- SELECT * FROM Object_PartionGoods limit 10
-- SELECT * FROM gpReport_Goods_RemainsCurrent (inUnitId := 35139 , inPartnerId := 0 , inGoodsGroupId := 0 , inIsPartion := 'True' , inIsPartner := 'False' , inIsZero := 'False', inIsOrderClient:= TRUE, inIsPartNumber := 'False' ,  inSession := '5');
