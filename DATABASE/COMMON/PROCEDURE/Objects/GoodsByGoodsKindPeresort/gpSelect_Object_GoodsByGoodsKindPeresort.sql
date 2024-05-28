-- Function: gpSelect_Object_GoodsByGoodsKindPeresort(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKindPeresort (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKindPeresort (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKindPeresort(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId_in Integer, GoodsCode_in Integer, GoodsName_in TVarChar
             , GoodsKindId_in Integer, GoodsKindName_in TVarChar
             , GoodsGroupNameFull_in TVarChar
             , MeasureName_in TVarChar
             , Weight_in TFloat
             , InfoMoneyCode_in Integer, InfoMoneyGroupName_in TVarChar, InfoMoneyDestinationName_in TVarChar, InfoMoneyName_in TVarChar
             
             , GoodsId_out Integer, GoodsCode_out Integer, GoodsName_out TVarChar
             , GoodsKindId_out Integer, GoodsKindName_out TVarChar
             , GoodsGroupNameFull_out TVarChar
             , MeasureName_out TVarChar
             , Weight_out TFloat
             , InfoMoneyCode_out Integer, InfoMoneyGroupName_out TVarChar, InfoMoneyDestinationName_out TVarChar, InfoMoneyName_out TVarChar 
             , isErased Boolean
              )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
     vbUserId:= lpGetUserBySession (inSession);
     
     RETURN QUERY
     WITH 
     tmpGoodsByGoodsKindPeresort AS (SELECT ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId       AS Id 
                                                  , ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId  AS GoodsId_in
                                                  , Object_Goods_in.ObjectCode                                  AS GoodsCode_in
                                                  , Object_Goods_in.ValueData                                   AS GoodsName_in
                                                  , Object_GoodsKind_in.Id                                      AS GoodsKindId_in
                                                  , Object_GoodsKind_in.ObjectCode                              AS GoodsKindCode_in
                                                  , Object_GoodsKind_in.ValueData                               AS GoodsKindName_in 
                                                  
                                                  , ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId  AS GoodsId_out
                                                  , Object_Goods_out.ObjectCode                                  AS GoodsCode_out
                                                  , Object_Goods_out.ValueData                                   AS GoodsName_out
                                                  , Object_GoodsKind_out.Id                                      AS GoodsKindId_out
                                                  , Object_GoodsKind_out.ObjectCode                              AS GoodsKindCode_out
                                                  , Object_GoodsKind_out.ValueData                               AS GoodsKindName_out
                                                  
                                                  , Object_GoodsByGoodsKindPeresort.isErased                     AS isErased
                                              FROM ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_in
                                                   LEFT JOIN Object AS Object_GoodsByGoodsKindPeresort ON Object_GoodsByGoodsKindPeresort.Id = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                   
                                                   LEFT JOIN Object AS Object_Goods_in ON Object_Goods_in.Id = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId
        
                                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in
                                                                        ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                                       AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in()
                                                   LEFT JOIN Object AS Object_GoodsKind_in ON Object_GoodsKind_in.Id = ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in.ChildObjectId
                                                   
                                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_Goods_out
                                                                        ON ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                                       AND ObjectLink_GoodsByGoodsKindPeresort_Goods_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out()
                                                   LEFT JOIN Object AS Object_Goods_out ON Object_Goods_out.Id = ObjectLink_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId
                                                   
                                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out
                                                                        ON ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ObjectId = ObjectLink_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                                       AND ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out()
                                                   LEFT JOIN Object AS Object_GoodsKind_out ON Object_GoodsKind_out.Id = ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId                    
                                              WHERE ObjectLink_GoodsByGoodsKindPeresort_Goods_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in()
                                                AND (Object_GoodsByGoodsKindPeresort.isErased = inShowAll OR inShowAll = TRUE)
                                              )

       --
       SELECT
             Object_GoodsByGoodsKindPeresort.Id
           , Object_GoodsByGoodsKindPeresort.GoodsId_in
           , Object_GoodsByGoodsKindPeresort.GoodsCode_in
           , Object_GoodsByGoodsKindPeresort.GoodsName_in
           , Object_GoodsByGoodsKindPeresort.GoodsKindId_in
           , Object_GoodsByGoodsKindPeresort.GoodsKindName_in

           , ObjectString_Goods_GoodsGroupFull_in.ValueData    AS GoodsGroupNameFull_in
           , Object_Measure_in.ValueData                       AS MeasureName_in
           , ObjectFloat_Weight_in.ValueData                   AS Weight_in
           , Object_InfoMoney_View_in.InfoMoneyCode            AS InfoMoneyCode_in
           , Object_InfoMoney_View_in.InfoMoneyGroupName       AS InfoMoneyGroupName_in
           , Object_InfoMoney_View_in.InfoMoneyDestinationName AS InfoMoneyDestinationName_in
           , Object_InfoMoney_View_in.InfoMoneyName            AS InfoMoneyName_in

           , Object_GoodsByGoodsKindPeresort.GoodsId_out
           , Object_GoodsByGoodsKindPeresort.GoodsCode_out
           , Object_GoodsByGoodsKindPeresort.GoodsName_out
           , Object_GoodsByGoodsKindPeresort.GoodsKindId_out
           , Object_GoodsByGoodsKindPeresort.GoodsKindName_out

           , ObjectString_Goods_GoodsGroupFull_out.ValueData    AS GoodsGroupNameFull_out
           , Object_Measure_out.ValueData                       AS MeasureName_out
           , ObjectFloat_Weight_out.ValueData                   AS Weight_out
           , Object_InfoMoney_View_out.InfoMoneyCode            AS InfoMoneyCode_out
           , Object_InfoMoney_View_out.InfoMoneyGroupName       AS InfoMoneyGroupName_out
           , Object_InfoMoney_View_out.InfoMoneyDestinationName AS InfoMoneyDestinationName_out
           , Object_InfoMoney_View_out.InfoMoneyName            AS InfoMoneyName_out

           , Object_GoodsByGoodsKindPeresort.isErased 

       FROM tmpGoodsByGoodsKindPeresort AS Object_GoodsByGoodsKindPeresort
            
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight_in
                                  ON ObjectFloat_Weight_in.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_in
                                 AND ObjectFloat_Weight_in.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight_out
                                  ON ObjectFloat_Weight_out.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_out
                                 AND ObjectFloat_Weight_out.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_in
                                   ON ObjectString_Goods_GoodsGroupFull_in.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_in
                                  AND ObjectString_Goods_GoodsGroupFull_in.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_in
                                 ON ObjectLink_Goods_Measure_in.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_in
                                AND ObjectLink_Goods_Measure_in.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_in ON Object_Measure_in.Id = ObjectLink_Goods_Measure_in.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney_in
                                 ON ObjectLink_Goods_InfoMoney_in.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_in
                                AND ObjectLink_Goods_InfoMoney_in.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_in ON Object_InfoMoney_View_in.InfoMoneyId = ObjectLink_Goods_InfoMoney_in.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_out
                                   ON ObjectString_Goods_GoodsGroupFull_out.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_out
                                  AND ObjectString_Goods_GoodsGroupFull_out.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_out
                                 ON ObjectLink_Goods_Measure_out.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_out
                                AND ObjectLink_Goods_Measure_out.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_out ON Object_Measure_out.Id = ObjectLink_Goods_Measure_out.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney_out
                                 ON ObjectLink_Goods_InfoMoney_out.ObjectId = Object_GoodsByGoodsKindPeresort.GoodsId_out
                                AND ObjectLink_Goods_InfoMoney_out.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_out ON Object_InfoMoney_View_out.InfoMoneyId = ObjectLink_Goods_InfoMoney_out.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.24        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKindPeresort (zfCalc_UserAdmin())  limit 10
