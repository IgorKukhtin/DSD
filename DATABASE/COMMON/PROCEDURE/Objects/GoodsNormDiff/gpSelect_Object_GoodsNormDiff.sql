-- Function: gpSelect_Object_GoodsNormDiff()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsNormDiff ( Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsNormDiff(
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , ValuePF TFloat, ValueGP TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsNormDiff());

   RETURN QUERY 

     SELECT Object_GoodsNormDiff.Id       AS Id
          , Object_Goods.Id               AS GoodsId
          , Object_Goods.ObjectCode       AS GoodsCode
          , Object_Goods.ValueData        AS GoodsName
          , Object_GoodsKind.Id           AS GoodsKindId
          , Object_GoodsKind.ValueData    AS GoodsKindName

          , Object_GoodsGroup.Id          AS GoodsGroupId
          , Object_GoodsGroup.ValueData   AS GoodsGroupName
          , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull

          , ObjectFloat_ValuePF.ValueData AS ValuePF
          , ObjectFloat_ValueGP.ValueData AS ValueGP   
          
          , ObjectString_Comment.ValueData AS Comment

          , Object_Insert.ValueData              AS InsertName
          , Object_Update.ValueData              AS UpdateName
          , ObjectDate_Protocol_Insert.ValueData AS InsertDate
          , ObjectDate_Protocol_Update.ValueData AS UpdateDate
         
          , Object_GoodsNormDiff.isErased        AS isErased

     FROM Object AS Object_GoodsNormDiff

          LEFT JOIN ObjectFloat AS ObjectFloat_ValuePF
                                ON ObjectFloat_ValuePF.ObjectId = Object_GoodsNormDiff.Id
                               AND ObjectFloat_ValuePF.DescId = zc_ObjectFloat_GoodsNormDiff_ValuePF()
          LEFT JOIN ObjectFloat AS ObjectFloat_ValueGP
                                ON ObjectFloat_ValueGP.ObjectId = Object_GoodsNormDiff.Id
                               AND ObjectFloat_ValueGP.DescId = zc_ObjectFloat_GoodsNormDiff_ValueGP()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_GoodsNormDiff.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_GoodsNormDiff_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsNormDiff_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
   
          LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                               ON ObjectLink_GoodsKind.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsNormDiff_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods.ChildObjectId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = ObjectLink_Goods.ChildObjectId
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_GoodsNormDiff.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
          
     WHERE Object_GoodsNormDiff.DescId = zc_Object_GoodsNormDiff()
       AND (Object_GoodsNormDiff.isErased = FALSE OR inShowAll = TRUE)
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsNormDiff (FALSE, '2') 
