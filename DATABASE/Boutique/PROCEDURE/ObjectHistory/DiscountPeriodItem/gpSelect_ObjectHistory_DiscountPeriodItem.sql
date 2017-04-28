-- Function: gpSelect_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodItem(
    IN inUnitId             Integer   , -- ключ 
    IN inOperDate           TDateTime , -- Дата действия
    IN inShowAll            Boolean,   
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , isErased Boolean, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , GoodsGroupId         Integer
                , GoodsGroupName       TVarChar
                , CompositionGroupId   Integer
                , CompositionGroupName TVarChar
                , CompositionId        Integer
                , CompositionName      TVarChar
                , GoodsInfoId          Integer
                , GoodsInfoName        TVarChar
                , LineFabricaId        Integer
                , LineFabricaName      TVarChar
                , LabelId              Integer
                , LabelName            TVarChar
                , StartDate TDateTime, EndDate TDateTime
                , ValuePrice TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime



               )
AS
$BODY$
BEGIN

   IF inShowAll THEN 

    -- Выбираем данные
     RETURN QUERY 
                 
       SELECT
             tmpPrice.DiscountPeriodItemId AS Id
           , tmpPrice.DiscountPeriodItemObjectId AS ObjectId
           , Object_Goods.Id          AS GoodsId               
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , Object_Goods.isErased    AS isErased 
           
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName
           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName    
           , Object_Composition.Id          AS CompositionId
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.Id            AS GoodsInfoId
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.Id          AS LineFabricaId
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.Id                AS LabelId
           , Object_Label.ValueData         AS LabelName

           , tmpPrice.StartDate
           , tmpPrice.EndDate
           , COALESCE(tmpPrice.ValuePrice, NULL) ::TFloat  AS ValuePrice

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM Object AS Object_Goods
          
        LEFT JOIN (SELECT
                          ObjectHistory_DiscountPeriodItem.Id AS DiscountPeriodItemId
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
                   )  as tmpPrice on tmpPrice.GoodsId= Object_Goods.Id
         
          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.DiscountPeriodItemObjectId
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.DiscountPeriodItemObjectId
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpPrice.DiscountPeriodItemObjectId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = tmpPrice.DiscountPeriodItemObjectId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId              

          --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Composition
                                 ON ObjectLink_Goods_Composition.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Composition.DescId = zc_ObjectLink_Goods_Composition()
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = ObjectLink_Goods_Composition.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id 
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsInfo
                                 ON ObjectLink_Goods_GoodsInfo.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsInfo.DescId = zc_ObjectLink_Goods_GoodsInfo()
            LEFT JOIN Object AS Object_GoodsInfo ON Object_GoodsInfo.Id = ObjectLink_Goods_GoodsInfo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                 ON ObjectLink_Goods_LineFabrica.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = ObjectLink_Goods_LineFabrica.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Label
                                 ON ObjectLink_Goods_Label.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Label.DescId = zc_ObjectLink_Goods_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_Goods_Label.ChildObjectId

       where  Object_Goods.DescId = zc_Object_Goods()
      
       ;

   ELSE
    
     -- Выбираем данные
     RETURN QUERY 
                 
       SELECT
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectHistory_DiscountPeriodItem.ObjectId
           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
           , Object_Goods.isErased   AS isErased 
           
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData     AS MeasureName
           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName    
           , Object_Composition.Id          AS CompositionId
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.Id            AS GoodsInfoId
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.Id          AS LineFabricaId
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.Id                AS LabelId
           , Object_Label.ValueData         AS LabelName

           , ObjectHistory_DiscountPeriodItem.StartDate
           , ObjectHistory_DiscountPeriodItem.EndDate
           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_DiscountPeriodItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                   AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = ObjectHistory_DiscountPeriodItem.ObjectId
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = ObjectHistory_DiscountPeriodItem.ObjectId
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = ObjectHistory_DiscountPeriodItem.ObjectId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = ObjectHistory_DiscountPeriodItem.ObjectId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId             

          --
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Composition
                                 ON ObjectLink_Goods_Composition.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Composition.DescId = zc_ObjectLink_Goods_Composition()
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = ObjectLink_Goods_Composition.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id 
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsInfo
                                 ON ObjectLink_Goods_GoodsInfo.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsInfo.DescId = zc_ObjectLink_Goods_GoodsInfo()
            LEFT JOIN Object AS Object_GoodsInfo ON Object_GoodsInfo.Id = ObjectLink_Goods_GoodsInfo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                 ON ObjectLink_Goods_LineFabrica.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = ObjectLink_Goods_LineFabrica.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Label
                                 ON ObjectLink_Goods_Label.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Label.DescId = zc_ObjectLink_Goods_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_Goods_Label.ChildObjectId

       WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
         AND (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData <> 0 OR ObjectHistory_DiscountPeriodItem.StartDate <> zc_DateStart())
       ;
       
     END IF;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.17         * битики + св-ва товара
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())

--select * from gpSelect_ObjectHistory_DiscountPeriodItem(inUnitId := 18879 , inOperDate := ('11.11.2015')::TDateTime , inShowAll := 'False' ,  inSession := '5');
