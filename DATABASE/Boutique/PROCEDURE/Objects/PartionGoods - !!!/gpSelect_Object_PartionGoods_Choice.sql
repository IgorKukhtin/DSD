-- Function: gpSelect_Object_PartionGoods (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods_Choice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods_Choice(
    IN inUnitId      Integer,       --  признак показать удаленные да/нет
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSessiON     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id                   Integer           
             , MovementItemId       Integer
             , MovementId           Integer
             , InvNumber            TVarChar  
             , InvNumber_Full       TVarChar
             --, SybaseId             Integer  
             , PartnerName          TVarChar  
             , UnitName             TVarChar  
             , OperDate             TDateTime
             , GoodsId              Integer
             , GoodsName            TVarChar  
             , GroupNameFull        TVarChar  
             , CurrencyName         TVarChar  
             , Amount               TFloat  
             , Remains              TFloat
             , OperPrice            TFloat
             , PriceSale            TFloat
             , PriceSale_Partion    TFloat  
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
     vbUserId:= lpGetUserBySessiON (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
     WITH
     tmpPrice AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                  FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                       INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                             ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                            AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                            AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                              AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                  WHERE ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                 )

       SELECT Object_PartionGoods.MovementItemId  AS Id
            , Object_PartionGoods.MovementItemId  AS MovementItemId
            , Movement.Id                         AS MovementId
            , Movement.InvNumber                  AS InvNumber
            , ('№ ' || Movement.InvNumber ||' от '||zfConvert_DateToString(Movement.OperDate) ) :: TVarChar AS InvNumber_full         
            , Object_Partner.ValueData            AS PartnerName
            , Object_Unit.ValueData               AS UnitName
            , Object_PartionGoods.OperDate        AS OperDate
            , Object_PartionGoods.GoodsId         AS GoodsId
            , Object_Goods.ValueData              AS GoodsName
            , Object_GroupNameFull.ValueData      As GroupNameFull
            , Object_Currency.ValueData           AS CurrencyName
            , Object_PartionGoods.Amount          AS Amount
            , COALESCE (Container.Amount,0) ::TFloat AS Remains            
            , Object_PartionGoods.OperPrice       AS OperPrice
            , tmpPrice.ValuePrice                 AS PriceSale
            , Object_PartionGoods.PriceSale       AS PriceSale_Partion
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
           
       FROM Container
           LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                        AND (Object_PartionGoods.isErased = FALSE)

           LEFT JOIN  Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.PartnerId
           LEFT JOIN  Object AS Object_Unit    ON Object_Unit.Id    = Object_PartionGoods.UnitId
           LEFT JOIN  Object AS Object_Goods   ON Object_Goods.Id   = Object_PartionGoods.GoodsId

           LEFT JOIN  ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()                   

           LEFT JOIN  Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
           LEFT JOIN  Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
           LEFT JOIN  Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
           LEFT JOIN  Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
           LEFT JOIN  Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
           LEFT JOIN  Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
           LEFT JOIN  Object AS Object_CompositiON      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
           LEFT JOIN  Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
           LEFT JOIN  Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
           LEFT JOIN  Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
           LEFT JOIN  Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
           LEFT JOIN  Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

           LEFT JOIN  Movement ON Movement.Id = Object_PartionGoods.MovementId

           LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_PartionGoods.GoodsId

     WHERE Container.DescId = zc_Container_count()
       AND Container.WhereObjectId = inUnitId  
       AND (COALESCE (Container.Amount,0) <> 0 OR inIsShowAll = TRUE)       
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
29.06.17          *
21.06.17          *
09.05.17          *
25.04.17          * _Choice
15.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionGoods_Choice (506,TRUE, zfCalc_UserAdmin())