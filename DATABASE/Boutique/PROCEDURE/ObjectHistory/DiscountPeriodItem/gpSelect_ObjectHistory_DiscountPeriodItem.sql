-- Function: gpSelect_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodItem(
    IN inUnitId             Integer   , -- ���� 
    IN inOperDate           TDateTime , -- ���� ��������
    IN inShowAll            Boolean,   
    IN inSession            TVarChar    -- ������ ������������
)                              
RETURNS TABLE  (  Id Integer , ObjectId Integer
                , StartDate TDateTime, EndDate TDateTime
                , ValuePrice TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime

                , PartnerName          TVarChar  
                , UnitName             TVarChar  
                , OperDate             TDateTime  
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar  
                , isErased Boolean
                , GroupNameFull        TVarChar  
                , CurrencyName         TVarChar  
                , OperPrice            TFloat  
                , PriceSale            TFloat  
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
                , GoodsSizeName        TVarChar 
               )
AS
$BODY$
BEGIN

   IF inShowAll THEN 

    -- �������� ������
     RETURN QUERY 
     WITH
     tmpDiscount AS
                  (SELECT ObjectHistory_DiscountPeriodItem.Id AS DiscountPeriodItemId
                        , ObjectHistory_DiscountPeriodItem.ObjectId  AS DiscountPeriodItemObjectId
                        , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           
                        , ObjectHistory_DiscountPeriodItem.StartDate
                        , ObjectHistory_DiscountPeriodItem.EndDate
                        , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

                   FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                        LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                               ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                              AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                               ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                              AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                              AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                               ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                              AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

                   WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
                     AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
                     AND (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData <> 0 OR ObjectHistory_DiscountPeriodItem.StartDate <> zc_DateStart())
                   )
    , tmpPartionGoods AS
                   (SELECT Object_Partner.ValueData            AS PartnerName
                         , Object_Unit.ValueData               AS UnitName
                         , Object_PartionGoods.OperDate        AS OperDate
                         , Object_PartionGoods.GoodsId         AS GoodsId
                         , Object_Currency.ValueData           AS CurrencyName
                         , Object_PartionGoods.OperPrice       AS OperPrice
                         , Object_PartionGoods.PriceSale       AS PriceSale
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
                         , Object_GoodsSize.ValueData          AS GoodsSizeName
                    FROM Object_PartionGoods
                         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartiONGoods.PartnerId
                         LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = Object_PartionGoods.UnitId
                         LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = Object_PartionGoods.CurrencyId
                         LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId
                         LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = Object_PartionGoods.PeriodId
                         LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = Object_PartionGoods.FabrikaId
                         LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                         LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                         LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                         LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                         LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                         LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                         LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
                         LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                    WHERE Object_PartionGoods.isErased = FALSE 
                      AND Object_PartionGoods.UnitId = inUnitId
                    ) 
                 
       SELECT
             tmpDiscount.DiscountPeriodItemId AS Id
           , tmpDiscount.DiscountPeriodItemObjectId AS ObjectId

           , tmpDiscount.StartDate
           , tmpDiscount.EndDate
           , COALESCE(tmpDiscount.ValuePrice, NULL) ::TFloat  AS ValuePrice

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , tmpPartionGoods.PartnerName
           , tmpPartionGoods.UnitName
           , tmpPartionGoods.OperDate
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods.isErased               AS Goods_isErased 
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , tmpPartionGoods.CurrencyName
           , tmpPartionGoods.OperPrice    ::Tfloat
           , tmpPartionGoods.PriceSale    ::Tfloat
           , tmpPartionGoods.BrandName
           , tmpPartionGoods.PeriodName
           , tmpPartionGoods.PeriodYear
           , tmpPartionGoods.FabrikaName
           , tmpPartionGoods.GoodsGroupName
           , tmpPartionGoods.MeasureName    
           , tmpPartionGoods.CompositionName
           , tmpPartionGoods.GoodsInfoName
           , tmpPartionGoods.LineFabricaName
           , tmpPartionGoods.LabelName
           , tmpPartionGoods.CompositionGroupName
           , tmpPartionGoods.GoodsSizeName

       FROM tmpPartionGoods
        FULL JOIN tmpDiscount ON tmpDiscount.GoodsId= tmpPartionGoods.GoodsId
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpPartionGoods.GoodsId,tmpDiscount.GoodsId)
        LEFT JOIN ObjectString AS Object_GroupNameFull
                               ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                              AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()     

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = tmpDiscount.DiscountPeriodItemObjectId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = tmpDiscount.DiscountPeriodItemObjectId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = tmpDiscount.DiscountPeriodItemObjectId
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = tmpDiscount.DiscountPeriodItemObjectId
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId              
      ;

   ELSE
    
     -- �������� ������
     RETURN QUERY 
     WITH
     tmpDiscount AS       
                  (SELECT ObjectHistory_DiscountPeriodItem.Id AS Id
                        , ObjectHistory_DiscountPeriodItem.ObjectId  AS ObjectId
                        , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           
                        , ObjectHistory_DiscountPeriodItem.StartDate
                        , ObjectHistory_DiscountPeriodItem.EndDate
                        , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

                   FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                        LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                               ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                              AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                               ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                              AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                              AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                               ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                              AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

                   WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
                     AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
                     AND (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData <> 0 OR ObjectHistory_DiscountPeriodItem.StartDate <> zc_DateStart())
                   )

    , tmpPartionGoods AS
                   (SELECT Object_Partner.ValueData            AS PartnerName
                         , Object_Unit.ValueData               AS UnitName
                         , Object_PartionGoods.OperDate        AS OperDate
                         , Object_PartionGoods.GoodsId         AS GoodsId
                         , Object_Currency.ValueData           AS CurrencyName
                         , Object_PartionGoods.OperPrice       AS OperPrice
                         , Object_PartionGoods.PriceSale       AS PriceSale
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
                         , Object_GoodsSize.ValueData          AS GoodsSizeName
                    FROM Object_PartionGoods
                         INNER JOIN (SELECT DISTINCT tmpDiscount.GoodsId FROM tmpDiscount) AS tmpGoods ON tmpGoods.GoodsId = Object_PartionGoods.GoodsId
                         LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.PartnerId
                         LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = Object_PartionGoods.UnitId
                         LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = Object_PartionGoods.CurrencyId
                         LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId
                         LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = Object_PartionGoods.PeriodId
                         LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = Object_PartionGoods.FabrikaId
                         LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                         LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                         LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                         LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                         LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                         LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                         LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
                         LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                    WHERE Object_PartionGoods.isErased = FALSE 
                      AND Object_PartionGoods.UnitId = inUnitId
                    ) 

       SELECT
             tmpDiscount.Id
           , tmpDiscount.ObjectId

           , tmpDiscount.StartDate
           , tmpDiscount.EndDate
           , tmpDiscount.ValuePrice

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , tmpPartionGoods.PartnerName
           , tmpPartionGoods.UnitName
           , tmpPartionGoods.OperDate
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods.isErased 
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , tmpPartionGoods.CurrencyName
           , tmpPartionGoods.OperPrice    ::Tfloat
           , tmpPartionGoods.PriceSale    ::Tfloat
           , tmpPartionGoods.BrandName
           , tmpPartionGoods.PeriodName
           , tmpPartionGoods.PeriodYear
           , tmpPartionGoods.FabrikaName
           , tmpPartionGoods.GoodsGroupName
           , tmpPartionGoods.MeasureName    
           , tmpPartionGoods.CompositionName
           , tmpPartionGoods.GoodsInfoName
           , tmpPartionGoods.LineFabricaName
           , tmpPartionGoods.LabelName
           , tmpPartionGoods.CompositionGroupName
           , tmpPartionGoods.GoodsSizeName

       FROM tmpDiscount
            FULL JOIN tmpPartionGoods ON tmpPartionGoods.GoodsId = tmpDiscount.GoodsId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpPartionGoods.GoodsId,tmpDiscount.GoodsId)
            LEFT JOIN ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()  

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId =tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId             
            ;
       
     END IF;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.17         * ������ + ��-�� ������
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())

--select * from gpSelect_ObjectHistory_DiscountPeriodItem(inUnitId := 18879 , inOperDate := ('11.11.2015')::TDateTime , inShowAll := 'False' ,  inSession := '5');
