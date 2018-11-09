-- Function: gpSelect_Object_GoodsSeparate()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSeparate ( Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSeparate(
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsGroupNameFull_Master TVarChar, 
               GoodsMasterId Integer, GoodsMasterCode Integer, GoodsMasterName TVarChar,
               MeasureName_Master TVarChar, Weight_Master TFloat,
               GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               MeasureName TVarChar, Weight TFloat,
               InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar,
               InsertName TVarChar, UpdateName TVarChar,
               InsertDate TDateTime, UpdateDate TDateTime,
               isCalculated Boolean,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsSeparate());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

     SELECT Object_GoodsSeparate.Id       AS Id
     
          , ObjectString_Goods_GoodsGroupFull_Master.ValueData AS GoodsGroupNameFull_Master
          , Object_GoodsMaster.Id              AS GoodsMasterId
          , Object_GoodsMaster.ObjectCode      AS GoodsMasterCode
          , Object_GoodsMaster.ValueData       AS GoodsMasterName
          , Object_Measure_Master.ValueData     AS MeasureName_Master
          , ObjectFloat_Weight_Master.ValueData AS Weight_Master
     
          , Object_GoodsGroup.Id          AS GoodsGroupId
          , Object_GoodsGroup.ValueData   AS GoodsGroupName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

          , Object_Goods.Id               AS GoodsId
          , Object_Goods.ObjectCode       AS GoodsCode
          , Object_Goods.ValueData        AS GoodsName
 
          , Object_GoodsKind.Id           AS GoodsKindId
          , Object_GoodsKind.ObjectCode   AS GoodsKindCode
          , Object_GoodsKind.ValueData    AS GoodsKindName
         
          , Object_Measure.ValueData      AS MeasureName
          , ObjectFloat_Weight.ValueData  AS Weight

          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName

          , Object_Insert.ValueData              AS InsertName
          , Object_Update.ValueData              AS UpdateName
          , ObjectDate_Protocol_Insert.ValueData AS InsertDate
          , ObjectDate_Protocol_Update.ValueData AS UpdateDate
         
          , ObjectBoolean_Calculated.ValueData   AS isCalculated
          , Object_GoodsSeparate.isErased        AS isErased

     FROM Object AS Object_GoodsSeparate
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_GoodsSeparate.isErased

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Calculated
                                  ON ObjectBoolean_Calculated.ObjectId = Object_GoodsSeparate.Id
                                 AND ObjectBoolean_Calculated.DescId = zc_ObjectBoolean_GoodsSeparate_Calculated()

          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_GoodsMaster
                               ON ObjectLink_GoodsSeparate_GoodsMaster.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_GoodsSeparate_GoodsMaster.DescId = zc_ObjectLink_GoodsSeparate_GoodsMaster()
          LEFT JOIN Object AS Object_GoodsMaster ON Object_GoodsMaster.Id = ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_Goods
                               ON ObjectLink_GoodsSeparate_Goods.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_GoodsSeparate_Goods.DescId = zc_ObjectLink_GoodsSeparate_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsSeparate_Goods.ChildObjectId
   
          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_GoodsKind
                               ON ObjectLink_GoodsSeparate_GoodsKind.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_GoodsSeparate_GoodsKind.DescId = zc_ObjectLink_GoodsSeparate_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsSeparate_GoodsKind.ChildObjectId
    
          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsSeparate_Goods.ChildObjectId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsSeparate_Goods.ChildObjectId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = ObjectLink_GoodsSeparate_Goods.ChildObjectId
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsSeparate_Goods.ChildObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_GoodsSeparate_Goods.ChildObjectId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_Master
                                 ON ObjectString_Goods_GoodsGroupFull_Master.ObjectId = ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId
                                AND ObjectString_Goods_GoodsGroupFull_Master.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight_Master
                                ON ObjectFloat_Weight_Master.ObjectId = ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId
                               AND ObjectFloat_Weight_Master.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_Master
                               ON ObjectLink_Goods_Measure_Master.ObjectId = ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId
                              AND ObjectLink_Goods_Measure_Master.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_Master ON Object_Measure_Master.Id = ObjectLink_Goods_Measure_Master.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
          
     WHERE Object_GoodsSeparate.DescId = zc_Object_GoodsSeparate()
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.18         *
 07.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsSeparate (FALSE, '2') 
