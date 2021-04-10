-- Function:  gpReport_Goods_RemainsCurrent()

DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_RemainsCurrent(
    IN inUnitId           Integer  ,  -- Подразделение / группа
    --IN inBrandId          Integer  ,  -- Торговая марка
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inGoodsGroupId     Integer  ,  -- группа товара
    IN inIsPartion        Boolean  ,  -- показать <Документ партия №> (Да/Нет)
    IN inIsPartner        Boolean  ,  -- показать Поставщика (Да/Нет)
    IN inIsRemains        Boolean  ,  -- Показать с остатком = 0
    IN inisPartNumber     Boolean  ,  -- по серийным номерам
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId       Integer
             , MovementId_Partion   Integer
             , InvNumber_Partion    TVarChar
             , InvNumberAll_Partion TVarChar
             , OperDate_Partion     TDateTime
             , DescName_Partion     TVarChar
             , UnitId               Integer
             , UnitName             TVarChar
             , UnitName_in          TVarChar
             , PartnerName          TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, PartNumber TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar

             , GoodsTagName         TVarChar
             , GoodsTypeName        TVarChar
             , ProdColorName        TVarChar
             , TaxKindName          TVarChar
             , GoodsSizeId          Integer
             , GoodsSizeName        TVarChar
             , GoodsSizeName_real   TVarChar
             , PriceListId_Basis    Integer
             , PriceListName_Basis  TVarChar

             , Amount_in               TFloat -- Итого кол-во Приход от поставщика
             , OperPrice               TFloat -- Цена вх. 
             , CountForPrice           TFloat -- Кол. в цене вх.
             , OperPriceList           TFloat -- Цена по прайсу   
             , OperPrice_cost          TFloat -- сумма затраты
             , CostPrice               TFloat -- Цена вх + затрата
             , Remains                 TFloat -- Кол-во - остаток
             , TotalSummEKPrice        TFloat -- Сумма по входным ценам
             , TotalSummPriceList      TFloat -- Сумма по прайсу
             , Summ_Cost               TFloat -- Сумма затрат
             , TotalSumm_Cost          TFloat -- Сумма вх+ затраты
             , PriceTax                TFloat -- % скидки !!!НА!!! zc_DateEnd
                    
             , Comment_in       TVarChar
             , DiscountTax_in   TFloat
             , VATPercent_in    TFloat
           
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
   --остатки
   , tmpContainer_All AS (SELECT Container.*
                          FROM Container
                               INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                           WHERE Container.DescId = zc_Container_Count()
                            AND (COALESCE(Container.Amount,0) <> 0 OR inIsRemains = TRUE)
                          )

   , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                FROM Object_PartionGoods
                                WHERE Object_PartionGoods.ObjectId IN (SELECT DISTINCT tmpContainer_All.ObjectId FROM tmpContainer_All)
                                )
   -- Остатки + Партии
   , tmpContainer AS (SELECT Container.WhereObjectId        AS UnitId
                           --, Container.PartionId            AS PartionId
                           , Object_PartionGoods.MovementItemId
                           , Container.ObjectId             AS GoodsId
                           , COALESCE (Container.Amount, 0) AS Remains
                           --, Object_PartionGoods.BrandId
                           , Object_PartionGoods.FromId AS PartnerId

                           , Object_PartionGoods.GoodsSizeId
                           , Object_PartionGoods.MeasureId
                           , Object_PartionGoods.GoodsGroupId
                           , Object_PartionGoods.GoodsTagId
                           , Object_PartionGoods.GoodsTypeId
                           , Object_PartionGoods.ProdColorId
                           , Object_PartionGoods.TaxKindId
                           , Object_PartionGoods.TaxValue AS TaxKindValue

                           , Object_PartionGoods.MovementId
                             -- Если есть права видеть Цену вх.
                           --, CASE WHEN vbIsOperPrice = TRUE THEN Object_PartionGoods.OperPrice ELSE 0 END AS OperPrice
                           , Object_PartionGoods.EKPrice
                           , Object_PartionGoods.CountForPrice

                           , COALESCE (tmpPriceBasis.ValuePrice, Object_PartionGoods.OperPriceList) AS OperPriceList

                             -- Цена без НДС затраты
                           , Object_PartionGoods.CostPrice     ::TFloat
                             -- Цена вх. с затратами без НДС
                           , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
              
                           , Object_PartionGoods.Amount     AS Amount_in
                           , Object_PartionGoods.UnitId     AS UnitId_in
                           
                             --  № п/п - только для = 1 возьмем Amount_in
                           , ROW_NUMBER() OVER (PARTITION BY Container.PartionId ORDER BY CASE WHEN Container.WhereObjectId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord

                      FROM tmpContainer_All AS Container
                           INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                                         AND Object_PartionGoods.ObjectId        = Container.ObjectId
                                                         AND (Object_PartionGoods.isErased      = FALSE
                                                           OR Object_PartionGoods.Amount        > 0
                                                             )
                            -- цена из Прайс-листа
                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Container.ObjectId

                      WHERE (Object_PartionGoods.FromId = inPartnerId  OR inPartnerId = 0)
                      )
--
       , tmpMovementString AS (SELECT MovementString.*
                               FROM MovementString
                               WHERE MovementString.MovementId IN (SELECT DISTINCT tmpContainer.MovementId FROM tmpContainer)
                                 AND MovementString.DescId = zc_MovementString_Comment()
                                 AND inisPartion = TRUE
                              )
       , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpContainer.MovementId FROM tmpContainer)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_DiscountTax()
                                                            , zc_MovementFloat_VATPercent()
                                                            )
                                 AND inisPartion = TRUE
                               )

       , tmpMIString AS (SELECT *
                         FROM MovementItemString AS MIString_PartNumber
                         WHERE MIString_PartNumber.MovementItemId IN (SELECT DISTINCT tmpContainer.MovementItemId FROM tmpContainer)
                           AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                         ) 

       , tmpData_All AS (SELECT tmpContainer.UnitId
                              , tmpContainer.GoodsId
                              , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementItemId   ELSE 0  END AS MovementItemId
                              , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementId       ELSE 0  END AS MovementId_Partion
                              , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END AS DescName_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END AS InvNumber_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END AS OperDate_Partion
                              , CASE WHEN inisPartner = TRUE THEN tmpContainer.PartnerId        ELSE 0  END AS PartnerId
                              , tmpContainer.GoodsSizeId
                              , tmpContainer.MeasureId
                              , tmpContainer.GoodsGroupId
                              , tmpContainer.GoodsTagId
                              , tmpContainer.GoodsTypeId
                              , tmpContainer.ProdColorId
                              , tmpContainer.TaxKindId
                              , tmpContainer.TaxKindValue
                              , tmpContainer.OperPriceList
                              , SUM (tmpContainer.CostPrice) AS CostPrice_summ
                              , tmpContainer.CountForPrice
                              , tmpContainer.UnitId_in

                                --  только для Ord = 1
                              , SUM (CASE WHEN tmpContainer.Ord = 1 THEN tmpContainer.Amount_in ELSE 0 END) AS Amount_in
                              , SUM (tmpContainer.Remains)         AS Remains
                              , SUM (zfCalc_SummIn        (tmpContainer.Remains, tmpContainer.EKPrice, tmpContainer.CountForPrice)) AS TotalSummEKPrice
                              , SUM (zfCalc_SummPriceList (tmpContainer.Remains, tmpContainer.OperPriceList))                       AS TotalSummPriceList
                              , SUM (zfCalc_SummPriceList (tmpContainer.Remains, tmpContainer.CostPrice))                           AS TotalSumm_cost
                              , SUM (zfCalc_SummPriceList (tmpContainer.Remains, tmpContainer.OperPrice_cost))                      AS TotalSummPrice_cost

                              , STRING_AGG (MS_Comment.ValueData, ' ;') ::TVarChar AS Comment_in
                              , COALESCE (MF_DiscountTax.ValueData, 0)      AS DiscountTax_in
                              , COALESCE (MF_VATPercent.ValueData, 0)       AS VATPercent_in
                              , STRING_AGG (MIString_PartNumber.ValueData, ' ;') ::TVarChar AS PartNumber

                         FROM tmpContainer
                              LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpContainer.MovementId
                              LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

                              LEFT JOIN tmpMovementString AS MS_Comment
                                                          ON MS_Comment.MovementId = tmpContainer.MovementId
                                                         AND MS_Comment.DescId = zc_MovementString_Comment()
                                                         AND inisPartion = TRUE
                              LEFT JOIN tmpMovementFloat AS MF_DiscountTax
                                                         ON MF_DiscountTax.MovementId = tmpContainer.MovementId
                                                        AND MF_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()
                                                        AND inisPartion                 = TRUE
                              LEFT JOIN tmpMovementFloat AS MF_VATPercent
                                                         ON MF_VATPercent.MovementId = tmpContainer.MovementId
                                                        AND MF_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                                                        AND inisPartion            = TRUE
                              LEFT JOIN tmpMIString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = tmpContainer.MovementItemId
                         GROUP BY tmpContainer.UnitId
                                , tmpContainer.GoodsId
                                , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementItemId   ELSE 0 END
                                , CASE WHEN inisPartion = TRUE THEN tmpContainer.MovementId       ELSE 0  END
                                , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END
                                , CASE WHEN inisPartner = TRUE THEN tmpContainer.PartnerId        ELSE 0  END
                                , CASE WHEN inisPartNumber = TRUE THEN MIString_PartNumber.ValueData ELSE '' END
                                , tmpContainer.GoodsSizeId
                                , tmpContainer.MeasureId
                                , tmpContainer.GoodsGroupId
                                , tmpContainer.GoodsTagId
                                , tmpContainer.GoodsTypeId
                                , tmpContainer.ProdColorId
                                , tmpContainer.TaxKindId
                                , tmpContainer.TaxKindValue
                                , tmpContainer.OperPriceList
                                , tmpContainer.UnitId_in
                                , MF_DiscountTax.ValueData
                                , MF_VATPercent.ValueData
                                , tmpContainer.CountForPrice
                  )

       , tmpData AS (SELECT tmpData_All.UnitId
                          , tmpData_All.GoodsId
                          , tmpData_All.MovementItemId
                          , tmpData_All.MovementId_Partion
                          , tmpData_All.DescName_Partion
                          , tmpData_All.InvNumber_Partion
                          , tmpData_All.OperDate_Partion
                          , tmpData_All.PartnerId
                          , Object_GoodsSize.Id        AS GoodsSizeId
                          , Object_GoodsSize.ValueData AS GoodsSizeName_real
                          , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData) AS GoodsSizeName
                          , tmpData_All.MeasureId
                          , tmpData_All.GoodsGroupId
                          , tmpData_All.GoodsTagId
                          , tmpData_All.GoodsTypeId
                          , tmpData_All.ProdColorId
                          , tmpData_All.TaxKindId
                          , tmpData_All.PartNumber
                          
                          , tmpData_All.OperPriceList
                          , SUM (tmpData_All.CostPrice_summ) AS CostPrice_summ
                          , tmpData_All.CountForPrice

                          , tmpData_All.UnitId_in
                          , tmpData_All.Comment_in
                          , tmpData_All.DiscountTax_in
                          , tmpData_All.VATPercent_in

                          , SUM (tmpData_All.Amount_in)           AS Amount_in
                          , SUM (tmpData_All.Remains)             AS Remains
                          , SUM (tmpData_All.TotalSummEKPrice)    AS TotalSummEKPrice
                          , SUM (tmpData_All.TotalSummPriceList)  AS TotalSummPriceList
                          , SUM (tmpData_All.TotalSummPrice_cost) AS TotalSummPrice_cost
                          , SUM (tmpData_All.TotalSumm_cost)      AS TotalSumm_cost
                     FROM tmpData_All
                          LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_All.GoodsSizeId
                     GROUP BY tmpData_All.UnitId
                            , tmpData_All.GoodsId
                            , tmpData_All.MovementItemId
                            , tmpData_All.MovementId_Partion
                            , tmpData_All.DescName_Partion
                            , tmpData_All.InvNumber_Partion
                            , tmpData_All.OperDate_Partion
                            , tmpData_All.PartnerId
                            , Object_GoodsSize.Id
                            , Object_GoodsSize.ValueData
                            , tmpData_All.MeasureId
                            , tmpData_All.GoodsGroupId
                            , tmpData_All.GoodsTagId
                            , tmpData_All.GoodsTypeId
                            , tmpData_All.ProdColorId
                            , tmpData_All.TaxKindId
                            , tmpData_All.TaxKindValue
                            , tmpData_All.OperPriceList
                            , tmpData_All.UnitId_in
                            , tmpData_All.Comment_in
                            , tmpData_All.DiscountTax_in
                            , tmpData_All.VATPercent_in
                            , tmpData_All.PartNumber
                            , tmpData_All.CountForPrice
              )
                                                  
        -- Результат
        SELECT
             tmpData.MovementItemId                 AS MovementItemId
           , tmpData.MovementId_Partion             AS MovementId_Partion
           , tmpData.InvNumber_Partion :: TVarChar  AS InvNumber_Partion
           , zfCalc_PartionMovementName (0, '', tmpData.InvNumber_Partion, tmpData.OperDate_Partion) AS InvNumberAll_Partion
           , CASE WHEN tmpData.OperDate_Partion = zc_DateStart() THEN NULL ELSE tmpData.OperDate_Partion END  :: TDateTime AS OperDate_Partion
           , tmpData.DescName_Partion  :: TVarChar  AS DescName_Partion

           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Unit_in.ValueData       AS UnitName_in
           , Object_Partner.ValueData       AS PartnerName

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData AS Article
           , tmpData.PartNumber ::TVarChar
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName

           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_TaxKind.ValueData       AS TaxKindName

           , tmpData.GoodsSizeId            AS GoodsSizeId
           , tmpData.GoodsSizeName      ::TVarChar AS GoodsSizeName
           , tmpData.GoodsSizeName_real ::TVarChar AS GoodsSizeName_real
           
           , Object_PriceList_Basis.Id         ::Integer  AS PriceListId_Basis
           , Object_PriceList_Basis.ValueData  ::TVarChar AS PriceListName_Basis

             -- Итого кол-во Приход от поставщика
           , tmpData.Amount_in    :: TFloat AS Amount_in

           , CASE WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummEKPrice / tmpData.Amount_in
                  ELSE 0
             END :: TFloat AS OperPrice
           , COALESCE (tmpData.CountForPrice,1)   :: TFloat AS CountForPrice

             -- Цена по прайсу
           , tmpData.OperPriceList :: TFloat

           --, tmpData.OperPrice_cost   :: TFloat
           , CASE WHEN tmpData.Amount_in  <> 0 THEN COALESCE (tmpData.TotalSummEKPrice,0) + COALESCE (tmpData.CostPrice_summ,0) / tmpData.Amount_in
                  ELSE 0
             END :: TFloat AS OperPrice_cost
           , tmpData.CostPrice_summ        :: TFloat AS CostPrice

             -- Кол-во - остаток
           , tmpData.Remains                 :: TFloat AS Remains
             -- Сумма по входным ценам
           , tmpData.TotalSummEKPrice      :: TFloat AS TotalSummEKPrice
             -- Сумма по прайсу - 
           , tmpData.TotalSummPriceList      :: TFloat AS TotalSummPriceList
           
           , tmpData.TotalSumm_Cost  :: TFloat AS Summ_Cost
           , tmpData.TotalSummPrice_cost  :: TFloat AS TotalSummPrice_cost

             -- % наценки 
           , CAST (CASE WHEN  tmpData.TotalSummPrice_cost <> 0
                        THEN (100 * tmpData.TotalSummPriceList / tmpData.TotalSummPrice_cost - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

           , tmpData.Comment_in       :: TVarChar
           , tmpData.DiscountTax_in   :: TFloat
           , tmpData.VATPercent_in    :: TFloat

        FROM tmpData
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_in ON Object_Unit_in.Id = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpData.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpData.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpData.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpData.ProdColorId
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = tmpData.TaxKindId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            
            LEFT JOIN Object AS Object_PriceList_Basis ON Object_PriceList_Basis.Id = zc_PriceList_Basis()

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
-- SELECT * FROM gpReport_Goods_RemainsCurrent (inUnitId:= 1531,  inPartnerId:= 0, inisPartion:= FALSE, inisPartner:= FALSE, inIsRemains:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpReport_Goods_RemainsCurrent (inUnitId := 0 , inPartnerId := 0 ,inGoodsGroupId:=0, inIsPartion := 'True' , inIsPartner := 'False', inIsRemains := 'False' ,  inSession := '2');

--select * from Object_PartionGoods limit 10
