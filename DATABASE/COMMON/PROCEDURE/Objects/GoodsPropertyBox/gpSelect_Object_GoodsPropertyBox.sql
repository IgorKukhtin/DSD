-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyBox (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPropertyBox(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, WeightOnBox TFloat, CountOnBox TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , BoxVolume TFloat, BoxWeight TFloat
             , BoxHeight TFloat, BoxLength TFloat, BoxWidth TFloat
             , isOrder Boolean, isErased Boolean
)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPropertyBox());
   
   IF inShowAll = FALSE
   THEN

   RETURN QUERY
   WITH
   tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                , ObjectBoolean_Order.ValueData AS isOrder
                           FROM ObjectBoolean AS ObjectBoolean_Order
                                LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                           WHERE ObjectBoolean_Order.ValueData = TRUE
                             AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           )

   SELECT
         Object_GoodsPropertyBox.Id           AS Id

       , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
       , ObjectFloat_CountOnBox.ValueData     AS CountOnBox
       
       , Object_Goods.Id                      AS GoodsId
       , Object_Goods.ObjectCode              AS GoodsCode
       , Object_Goods.ValueData               AS GoodsName
       , Object_Measure.ValueData             AS MeasureName
       , Object_GoodsGroup.ValueData          AS GoodsGroupName 
       , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
       
       , Object_GoodsKind.Id                  AS GoodsKindId
       , Object_GoodsKind.ValueData           AS GoodsKindName

       , Object_Box.Id                        AS BoxId
       , Object_Box.ObjectCode                AS BoxCode
       , Object_Box.ValueData                 AS BoxName
       , ObjectFloat_Volume.ValueData         AS BoxVolume
       , ObjectFloat_Weight.ValueData         AS BoxWeight
       , ObjectFloat_Height.ValueData         AS BoxHeight
       , ObjectFloat_Length.ValueData         AS BoxLength
       , ObjectFloat_Width.ValueData          AS BoxWidth

       , COALESCE (tmpGoodsByGoodsKind.isOrder, FALSE) :: Boolean AS isOrder
       , Object_GoodsPropertyBox.isErased   AS isErased

   FROM Object AS Object_GoodsPropertyBox

        LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                              ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyBox.Id
                             AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()

        LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                              ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyBox.Id
                             AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                             ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = Object_GoodsPropertyBox.Id
                            AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                             ON ObjectLink_GoodsPropertyBox_Goods.ObjectId = Object_GoodsPropertyBox.Id
                            AND ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyBox_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                             ON ObjectLink_GoodsPropertyBox_Box.ObjectId = Object_GoodsPropertyBox.Id
                            AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
        LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyBox_Box.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                              ON ObjectFloat_Volume.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                             AND ObjectFloat_Volume.DescId = zc_ObjectFloat_Box_Volume()
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
        LEFT JOIN ObjectFloat AS ObjectFloat_Height
                              ON ObjectFloat_Height.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                             AND ObjectFloat_Height.DescId = zc_ObjectFloat_Box_Height()
        LEFT JOIN ObjectFloat AS ObjectFloat_Length
                              ON ObjectFloat_Length.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                             AND ObjectFloat_Length.DescId = zc_ObjectFloat_Box_Length()
        LEFT JOIN ObjectFloat AS ObjectFloat_Width
                              ON ObjectFloat_Width.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                             AND ObjectFloat_Width.DescId = zc_ObjectFloat_Box_Width()
                                                                         
        LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                                     AND tmpGoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id 

   WHERE Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
   ;

   ELSE 

   RETURN QUERY
    WITH
      tmpGoodsPropertyBox AS (SELECT Object_GoodsPropertyBox.Id           AS Id
                                   , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
                                   , ObjectFloat_CountOnBox.ValueData     AS CountOnBox
                                   , Object_Goods.Id                      AS GoodsId
                                   , Object_Goods.ObjectCode              AS GoodsCode
                                   , Object_Goods.ValueData               AS GoodsName
                                   , Object_GoodsKind.Id                  AS GoodsKindId
                                   , Object_GoodsKind.ValueData           AS GoodsKindName
                                   , Object_Box.Id                        AS BoxId
                                   , Object_Box.ObjectCode                AS BoxCode
                                   , Object_Box.ValueData                 AS BoxName
                                   , Object_GoodsPropertyBox.isErased     AS isErased
                            
                               FROM Object AS Object_GoodsPropertyBox
                            
                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                          ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                         AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()
                            
                                    LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                          ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                         AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()
                            
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                         ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = Object_GoodsPropertyBox.Id
                                                        AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId
                            
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                                         ON ObjectLink_GoodsPropertyBox_Goods.ObjectId = Object_GoodsPropertyBox.Id
                                                        AND ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                                    LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyBox_Goods.ChildObjectId
                            
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                         ON ObjectLink_GoodsPropertyBox_Box.ObjectId = Object_GoodsPropertyBox.Id
                                                        AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                    LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                          
                               WHERE Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                               )

    , tmpBox AS (SELECT Object_Box.Id                 AS Id
                      , Object_Box.ObjectCode         AS Code
                      , Object_Box.ValueData          AS Name
                      , ObjectFloat_Volume.ValueData  AS BoxVolume
                      , ObjectFloat_Weight.ValueData  AS BoxWeight
                      , ObjectFloat_Height.ValueData  AS BoxHeight
                      , ObjectFloat_Length.ValueData  AS BoxLength
                      , ObjectFloat_Width.ValueData   AS BoxWidth
                 FROM Object AS Object_Box
                      LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                            ON ObjectFloat_Volume.ObjectId = Object_Box.Id
                                           AND ObjectFloat_Volume.DescId = zc_ObjectFloat_Box_Volume()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                            ON ObjectFloat_Weight.ObjectId = Object_Box.Id
                                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                            ON ObjectFloat_Height.ObjectId = Object_Box.Id
                                           AND ObjectFloat_Height.DescId = zc_ObjectFloat_Box_Height()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                            ON ObjectFloat_Length.ObjectId = Object_Box.Id
                                           AND ObjectFloat_Length.DescId = zc_ObjectFloat_Box_Length()
                      LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                            ON ObjectFloat_Width.ObjectId = Object_Box.Id
                                           AND ObjectFloat_Width.DescId = zc_ObjectFloat_Box_Width()
                 WHERE Object_Box.DescId = zc_Object_Box()
                   AND Object_Box.isErased = FALSE
                 )

    , tmpGoodsByGoodsKind_Order AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                         , ObjectBoolean_Order.ValueData AS isOrder
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                    )
    , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                   , Object_GoodsByGoodsKind_View.GoodsCode
                                   , Object_GoodsByGoodsKind_View.GoodsName
                                   , Object_GoodsByGoodsKind_View.GoodsKindId
                                   , Object_GoodsByGoodsKind_View.GoodsKindName
                              FROM Object_GoodsByGoodsKind_View
                              )

   , tmpFull AS (SELECT tmpBox.Id        AS BoxId
                      , tmpBox.Name      AS BoxName
                      , tmpGoodsByGoodsKind.GoodsId
                      , tmpGoodsByGoodsKind.GoodsCode
                      , tmpGoodsByGoodsKind.GoodsName
                      , tmpGoodsByGoodsKind.GoodsKindId
                      , tmpGoodsByGoodsKind.GoodsKindName
                 FROM tmpBox
                      FULL JOIN tmpGoodsByGoodsKind ON 1 = 1
                 )
                           

            SELECT COALESCE (tmpGoodsPropertyBox.Id, 0) AS Id
                 , COALESCE (tmpGoodsPropertyBox.WeightOnBox, 0) ::TFloat AS WeightOnBox
                 , COALESCE (tmpGoodsPropertyBox.CountOnBox, 0)  ::TFloat AS CountOnBox
                 
                 , COALESCE (tmpFull.GoodsId, tmpGoodsPropertyBox.GoodsId)      AS GoodsId
                 , COALESCE (tmpFull.GoodsCode, tmpGoodsPropertyBox.GoodsCode)  AS GoodsCode
                 , COALESCE (tmpFull.GoodsName, tmpGoodsPropertyBox.GoodsName)  AS GoodsName

                 , Object_Measure.ValueData     AS MeasureName
                 , Object_GoodsGroup.ValueData  AS GoodsGroupName 
                 , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                 
                 , COALESCE (tmpFull.GoodsKindId, tmpGoodsPropertyBox.GoodsKindId)     AS GoodsKindId
                 , COALESCE (tmpFull.GoodsKindName, tmpGoodsPropertyBox.GoodsKindName) AS GoodsKindName
          
                 , tmpBox.Id                   AS BoxId
                 , tmpBox.Code                 AS BoxCode
                 , tmpBox.Name                 AS BoxName
                 , tmpBox.BoxVolume            AS BoxVolume
                 , tmpBox.BoxWeight            AS BoxWeight
                 , tmpBox.BoxHeight            AS BoxHeight
                 , tmpBox.BoxLength            AS BoxLength
                 , tmpBox.BoxWidth             AS BoxWidth
                 , COALESCE (tmpGoodsByGoodsKind_Order.isOrder, FALSE) :: Boolean AS isOrder
                 , COALESCE (tmpGoodsPropertyBox.isErased, FALSE)      :: Boolean AS isErased
         
             FROM tmpFull 
                 FUll JOIN tmpGoodsPropertyBox ON tmpGoodsPropertyBox.GoodsId = tmpFull.GoodsId 
                                              AND tmpGoodsPropertyBox.GoodsKindId = tmpFull.GoodsKindId 
                                              AND tmpGoodsPropertyBox.BoxId = tmpFull.BoxId
                  
                 LEFT JOIN tmpGoodsByGoodsKind_Order ON tmpGoodsByGoodsKind_Order.GoodsId = COALESCE (tmpFull.GoodsId, tmpGoodsPropertyBox.GoodsId)
                                                    AND tmpGoodsByGoodsKind_Order.GoodsKindId = COALESCE (tmpFull.GoodsKindId, tmpGoodsPropertyBox.GoodsKindId)
   
                 LEFT JOIN tmpBox ON tmpBox.Id = COALESCE (tmpFull.BoxId, tmpGoodsPropertyBox.BoxId)

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                      ON ObjectLink_Goods_Measure.ObjectId = COALESCE (tmpFull.GoodsId, tmpGoodsPropertyBox.GoodsId)
                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = COALESCE (tmpFull.GoodsId, tmpGoodsPropertyBox.GoodsId)
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                 LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = COALESCE (tmpFull.GoodsId, tmpGoodsPropertyBox.GoodsId)
                                       AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                ;
   END IF;         
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 22.06.18        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPropertyBox (true, zfCalc_UserAdmin())
