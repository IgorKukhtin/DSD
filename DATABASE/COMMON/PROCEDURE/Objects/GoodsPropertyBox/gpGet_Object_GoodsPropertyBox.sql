-- Function: gpGet_Object_GoodsPropertyBox()


DROP FUNCTION IF EXISTS gpGet_Object_GoodsPropertyBox( Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPropertyBox(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer
             , WeightOnBox TFloat, CountOnBox TFloat
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , BoxId Integer, BoxName TVarChar
             )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyBox());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT CAST (0 as Integer)   AS Id

            , CAST (0 as TFloat)    AS WeightOnBox
            , CAST (0 as TFloat)    AS CountOnBox

            , 0                     AS GoodsId
            , CAST ('' as TVarChar) AS GoodsName
            
            , 0                     AS GoodsKindId
            , CAST ('' as TVarChar) AS GoodsKindName
     
            , 0                     AS BoxId
            , CAST ('' as TVarChar) AS BoxName
           ;

   ELSE
       RETURN QUERY 
       SELECT Object_GoodsPropertyBox.Id           AS Id
            , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
            , ObjectFloat_CountOnBox.ValueData     AS CountOnBox
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName
            , Object_Box.Id                        AS BoxId
            , Object_Box.ValueData                 AS BoxName

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

       WHERE Object_GoodsPropertyBox.Id = inId;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsPropertyBox(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.17         * add TaxDoc
 24.09.15         *
 26.05.15         * ADD StartPosInt, EndPosInt, StartPosFrac, EndPosFrac
 12.06.13         *
 00.06.13

*/

-- ТЕСТ
-- SELECT * FROM gpGet_Object_GoodsPropertyBox (1, '2')
