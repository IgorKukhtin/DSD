-- Function: gpSelect_Object_ChoiceCell_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ChoiceCell (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ChoiceCell(
    IN inShowAll       Boolean , -- показать удаленные Да/нет
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar  
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , NPP TFloat, BoxCount TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);
  
     -- Результат
     RETURN QUERY 

    -- Результат
    SELECT 
           Object_ChoiceCell.Id          AS Id
         , Object_ChoiceCell.ObjectCode  AS Code
         , Object_ChoiceCell.ValueData   AS Name

         , Object_Goods.Id         AS GoodsId
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsGroup.ValueData AS GoodsGroupName 
         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

         , ObjectFloat_NPP.ValueData AS NPP
         , ObjectFloat_BoxCount.ValueData AS BoxCount

         , ObjectString_Comment.ValueData  AS Comment

         , Object_ChoiceCell.isErased      AS isErased
       
    FROM Object AS Object_ChoiceCell 

        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ChoiceCell_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                             ON ObjectLink_GoodsKind.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                              ON ObjectFloat_NPP.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_NPP.DescId = zc_ObjectFloat_ChoiceCell_NPP()

        LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                              ON ObjectFloat_BoxCount.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_ChoiceCell_BoxCount()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_ChoiceCell.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_ChoiceCell_Comment()
        --
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

    WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()  
      AND (Object_ChoiceCell.isErased = FALSE OR inShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ChoiceCell (FALSE, zfCalc_UserAdmin())
