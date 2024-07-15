-- Function: gpGet_Object_ChoiceCell (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ChoiceCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ChoiceCell(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar  
             , NPP TFloat, BoxCount TFloat
             , Comment TVarChar
             ) AS
$BODY$

  DECLARE vbIndex Integer;
  DECLARE vbGoodsKindId TVarChar;

BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ChoiceCell());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ChoiceCell()) AS Code
           , CAST ('' as TVarChar)  AS Name
 
           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName

           , CAST (0 as Integer)    AS GoodsKindId
           , CAST ('' as TVarChar)  AS GoodsKindName  

           , CAST (NULL as TFloat)  AS NPP
           , CAST (NULL as TFloat)  AS BoxCount
           , CAST ('' as TVarChar)  AS Comment
       ;
   ELSE

       RETURN QUERY 
       SELECT 
              Object_ChoiceCell.Id          AS Id
            , Object_ChoiceCell.ObjectCode  AS Code
            , Object_ChoiceCell.ValueData   AS Name
   
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ValueData  AS GoodsName
   
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
   
            , ObjectFloat_NPP.ValueData AS NPP
            , ObjectFloat_BoxCount.ValueData AS BoxCount
   
            , ObjectString_Comment.ValueData  AS Comment
   
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

       WHERE Object_ChoiceCell.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ChoiceCell (0, inSession := '5')