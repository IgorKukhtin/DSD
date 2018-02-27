-- Function: gpSelect_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ 
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
             tmpPrice.PriceListItemId AS Id
           , tmpPrice.PriceListItemObjectId AS ObjectId
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
                          ObjectHistory_PriceListItem.Id AS PriceListItemId
                        , ObjectHistory_PriceListItem.ObjectId  AS PriceListItemObjectId
                        , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
           
                        , ObjectHistory_PriceListItem.StartDate
                        , ObjectHistory_PriceListItem.EndDate
                        , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

                   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                               ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                              AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                              AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                               ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                              AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                     AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                   )  as tmpPrice on tmpPrice.GoodsId= Object_Goods.Id
         
          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.PriceListItemObjectId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = tmpPrice.PriceListItemObjectId
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
             ObjectHistory_PriceListItem.Id
           , ObjectHistory_PriceListItem.ObjectId
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
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

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

         , Object_Insert.ValueData   AS InsertName
         , Object_Update.ValueData   AS UpdateName
         , ObjectDate_Protocol_Insert.ValueData AS InsertDate
         , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = ObjectHistory_PriceListItem.ObjectId
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = ObjectHistory_PriceListItem.ObjectId
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

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
       ;
       
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.17         * битики + св-ва товара
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (inPriceListId:= 0, inOperDate:= '11.05.2017', inShowAll:= FALSE, inSession := zfCalc_UserAdmin());
