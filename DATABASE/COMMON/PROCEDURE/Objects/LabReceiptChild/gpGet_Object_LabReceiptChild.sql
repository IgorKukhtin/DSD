-- Function: gpGet_Object_ReceiptChild(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_LabReceiptChild (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_LabReceiptChild (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_LabReceiptChild(
    IN inId          Integer,       --  
    IN inLabMarkId   Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value TFloat
             , LabMarkId Integer, LabMarkName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , isErased boolean
               ) AS
$BODY$
DECLARE vbLabMarkName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_LabReceiptChild());

   vbLabMarkName := (SELECT ValueData FROM Object WHERE Object.Id = inLabMarkId AND inLabMarkId <> 0);
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , CAST (0 as TFloat)    AS Value  
         
           , CAST (inLabMarkId)    AS LabMarkId
           , COALESCE (vbLabMarkName,'')::TVarChar AS LabMarkName

           , CAST (0 as Integer)   AS GoodsId
           , CAST ('' as TVarChar) AS GoodsName

           , CAST (NULL AS Boolean) AS isErased
       ;

   ELSE
     RETURN QUERY 
     SELECT 
           Object_LabReceiptChild.Id   AS Id
         , ObjectFloat_LabReceiptChild_Value.ValueData AS Value  

         , Object_LabMark.Id           AS LabMarkId
         , Object_LabMark.ValueData    AS LabMarkName

         , Object_Goods.Id             AS GoodsId
         , Object_Goods.ValueData      AS GoodsName

         , Object_LabReceiptChild.isErased AS isErased
         
     FROM Object AS Object_LabReceiptChild
          LEFT JOIN ObjectLink AS ObjectLink_LabReceiptChild_LabMark
                               ON ObjectLink_LabReceiptChild_LabMark.ObjectId = Object_LabReceiptChild.Id
                              AND ObjectLink_LabReceiptChild_LabMark.DescId = zc_ObjectLink_LabReceiptChild_LabMark()
          LEFT JOIN Object AS Object_LabMark ON Object_LabMark.Id = ObjectLink_LabReceiptChild_LabMark.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_LabReceiptChild_Goods
                               ON ObjectLink_LabReceiptChild_Goods.ObjectId = Object_LabReceiptChild.Id
                              AND ObjectLink_LabReceiptChild_Goods.DescId = zc_ObjectLink_LabReceiptChild_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_LabReceiptChild_Goods.ChildObjectId
 
          LEFT JOIN ObjectFloat AS ObjectFloat_LabReceiptChild_Value
                                ON ObjectFloat_LabReceiptChild_Value.ObjectId = Object_LabReceiptChild.Id
                               AND ObjectFloat_LabReceiptChild_Value.DescId = zc_ObjectFloat_LabReceiptChild_Value()
                               
     WHERE Object_LabReceiptChild.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_LabReceiptChild (0, '2')
