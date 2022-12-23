-- Function: gpGet_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptGoods(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , GoodsId Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar 
             , UnitId Integer, UnitName TVarChar
             
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptGoods())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS UserCode
           , '' :: TVarChar           AS Comment
           , TRUE :: Boolean          AS isMain
           , 0  :: Integer            AS GoodsId
           , '' :: TVarChar           AS GoodsName 
           , 0  :: Integer            AS GoodsGroupId
           , '' :: TVarChar           AS GoodsGroupName
           , 0  :: Integer            AS ColorPatternId
           , '' :: TVarChar           AS ColorPatternName
           , 0  :: Integer            AS UnitId
           , '' :: TVarChar           AS UnitName

       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ReceiptGoods.Id         AS Id 
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean  AS isMain

         , Object_Goods.Id                    ::Integer  AS GoodsId
         , Object_Goods.ValueData             ::TVarChar AS GoodsName
         , Object_GoodsGroup.Id               AS GoodsGroupId
         , Object_GoodsGroup.ValueData        AS GoodsGroupName

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

         , Object_Unit.Id                     AS UnitId
         , Object_Unit.ValueData              AS UnitName
     FROM Object AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()  
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()  

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptGoods.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptGoods_Main() 

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_ReceiptGoods_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
      AND Object_ReceiptGoods.Id = inId
     ;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.22         * Unit
 11.12.20         *
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptGoods (1, zfCalc_UserAdmin())
