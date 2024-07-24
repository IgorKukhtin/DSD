-- Function: gpGet_Object_GoodsNormDiff(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsNormDiff (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsNormDiff(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , ValuePF TFloat, ValueGP TFloat
             , Comment TVarChar
           
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsNormDiff());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
         
           , CAST (0 as Integer)   AS GoodsId
           , CAST ('' as TVarChar) AS GoodsName

           , CAST (0 as Integer)   AS GoodsKindId
           , CAST ('' as TVarChar) AS GoodsKindName

           , CAST (0 as TFloat)    AS ValuePF
           , CAST (0 as TFloat)    AS ValueGP

           , CAST ('' as TVarChar) AS Comment
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_GoodsNormDiff.Id        AS Id

          , Object_Goods.Id               AS GoodsId
          , Object_Goods.ValueData        AS GoodsName
          , Object_GoodsKind.Id           AS GoodsKindId
          , Object_GoodsKind.ValueData    AS GoodsKindName

          , ObjectFloat_ValuePF.ValueData AS ValuePF
          , ObjectFloat_ValueGP.ValueData AS ValueGP   
          
          , ObjectString_Comment.ValueData AS Comment

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


     WHERE Object_GoodsNormDiff.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsNormDiff (100, '2')
