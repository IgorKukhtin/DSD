-- Function: gpSelect_Object_GoodsScaleCeh()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsScaleCeh ( Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsScaleCeh(
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureName TVarChar, Weight TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsScaleCeh());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

     SELECT Object_GoodsScaleCeh.Id       AS Id

          , Object_From.Id                AS FromId
          , Object_From.ValueData         AS FromName

          , Object_To.Id                  AS ToId
          , Object_To.ValueData           AS ToName

          , Object_Goods.Id               AS GoodsId
          , Object_Goods.ObjectCode       AS GoodsCode
          , Object_Goods.ValueData        AS GoodsName

          , Object_GoodsGroup.Id          AS GoodsGroupId
          , Object_GoodsGroup.ValueData   AS GoodsGroupName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

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
         
          , Object_GoodsScaleCeh.isErased        AS isErased

     FROM Object AS Object_GoodsScaleCeh
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_GoodsScaleCeh.isErased

          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_Goods
                               ON ObjectLink_GoodsScaleCeh_Goods.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_GoodsScaleCeh_Goods.DescId = zc_ObjectLink_GoodsScaleCeh_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
   
          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_From
                               ON ObjectLink_GoodsScaleCeh_From.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_GoodsScaleCeh_From.DescId = zc_ObjectLink_GoodsScaleCeh_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_GoodsScaleCeh_From.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_To
                               ON ObjectLink_GoodsScaleCeh_To.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_GoodsScaleCeh_To.DescId = zc_ObjectLink_GoodsScaleCeh_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_GoodsScaleCeh_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
          
     WHERE Object_GoodsScaleCeh.DescId = zc_Object_GoodsScaleCeh()
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsScaleCeh (FALSE, '2') 
