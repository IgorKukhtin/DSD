-- Function: gpSelect_Object_PartionGoods (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods(
    IN inUnitId      Integer,
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (            
             MovementItemId       Integer
           , InvNumber            TVarChar  
           --, SybaseId             Integer  
           , PartnerName          TVarChar 
           , UnitId               Integer
           , UnitName             TVarChar  
           , OperDate             TDateTime  
           , GoodsId              Integer
           , GoodsName            TVarChar  
           , GroupNameFull        TVarChar  
           , CurrencyName         TVarChar  
           , Amount               TFloat
           , OperPrice            TFloat  
           , OperPriceList        TFloat  
           , BrandName            TVarChar  
           , PeriodName           TVarChar  
           , PeriodYear           Integer  
           , FabrikaName          TVarChar  
           , GoodsGroupName       TVarChar  
           , MeasureName          TVarChar  
           , CompositionName      TVarChar  
           , GoodsInfoName        TVarChar  
           , LineFabricaName      TVarChar  
           , LabelName            TVarChar  
           , CompositionGroupName TVarChar  
           , GoodsSizeId          Integer
           , GoodsSizeName        TVarChar  
           , isErased             Boolean  
           , isArc                Boolean  

) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_PartionGoods.MovementItemId  AS MovementItemId
           , Movement.InvNumber                  AS InvNumber
           --, Object_PartionGoods.SybaseId        AS SybaseId
           , Object_Partner.ValueData            AS PartnerName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , Object_PartionGoods.OperDate        AS OperDate
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ValueData              AS GoodsName
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , Object_Currency.ValueData           AS CurrencyName
           , Object_PartionGoods.Amount          AS Amount
           , Object_PartionGoods.OperPrice       AS OperPrice
           , Object_PartionGoods.OperPriceList   AS OperPriceList
           , Object_Brand.ValueData              AS BrandName
           , Object_Period.ValueData             AS PeriodName
           , Object_PartionGoods.PeriodYear      AS PeriodYear
           , Object_Fabrika.ValueData            AS FabrikaName
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName    
           , Object_Composition.ValueData        AS CompositionName
           , Object_GoodsInfo.ValueData          AS GoodsInfoName
           , Object_LineFabrica.ValueData        AS LineFabricaName
           , Object_Label.ValueData              AS LabelName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_GoodsSize.Id                 AS GoodsSizeId
           , Object_GoodsSize.ValueData          AS GoodsSizeName
           , Object_PartionGoods.isErased        AS isErased
           , Object_PartionGoods.isArc           AS isArc
           
       FROM Object_PartionGoods

           LEFT JOIN  Object AS Object_Partner on Object_Partner.Id = Object_PartionGoods.PartnerId
           LEFT JOIN  Object AS Object_Unit on Object_Unit.Id = Object_PartionGoods.UnitId
           LEFT JOIN  Object AS Object_Goods on Object_Goods.Id = Object_PartionGoods.GoodsId
           LEFT JOIN  ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()                   
           LEFT JOIN  Object AS Object_Currency on Object_Currency.Id = Object_PartionGoods.CurrencyId
           LEFT JOIN  Object AS Object_Brand on Object_Brand.Id = Object_PartionGoods.BrandId
           LEFT JOIN  Object AS Object_Period on Object_Period.Id = Object_PartionGoods.PeriodId
           LEFT JOIN  Object AS Object_Fabrika on Object_Fabrika.Id = Object_PartionGoods.FabrikaId
           LEFT JOIN  Object AS Object_GoodsGroup on Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
           LEFT JOIN  Object AS Object_Measure on Object_Measure.Id = Object_PartionGoods.MeasureId
           LEFT JOIN  Object AS Object_Composition on Object_Composition.Id = Object_PartionGoods.CompositionId
           LEFT JOIN  Object AS Object_GoodsInfo on Object_GoodsInfo.Id = Object_PartionGoods.GoodsInfoId
           LEFT JOIN  Object AS Object_LineFabrica on Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
           LEFT JOIN  Object AS Object_Label on Object_Label.Id = Object_PartionGoods.LabelId
           LEFT JOIN  Object AS Object_CompositionGroup on Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
           LEFT JOIN  Object AS Object_GoodsSize on Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId
           LEFT JOIN  Movement on Movement.Id = Object_PartionGoods.MovementId
           
     WHERE (Object_PartionGoods.isErased = FALSE OR inIsShowAll = TRUE)
       AND Object_PartionGoods.UnitId = inUnitId
     --LIMIT 10000

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
23.01.18          *
18.01.18          *
15.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionGoods (inUnitId := 1151, TRUE, zfCalc_UserAdmin())
--SELECT * FROM gpSelect_Object_PartionGoods (inUnitId := 1151, FALSE, zfCalc_UserAdmin())