-- Function: gpSelect_Object_LabReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_LabReceiptChild (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_LabReceiptChild(
    IN inLabMarkId    Integer,
    IN inGoodsId      Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value TFloat
             , LabMarkId Integer, LabMarkName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_LabReceiptChild());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

     SELECT 
           tmpLabReceiptChild.Id
         , tmpLabReceiptChild.Value

         , Object_LabMark.Id        AS LabMarkId
         , Object_LabMark.ValueData AS LabMarkName

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , tmpLabReceiptChild.isErased
         
     FROM (SELECT Object_LabReceiptChild.Id                         AS Id
                , ObjectLink_LabReceiptChild_LabMark.ChildObjectId  AS LabMarkId
                , ObjectLink_LabReceiptChild_Goods.ChildObjectId    AS GoodsId
                , ObjectFloat_LabReceiptChild_Value.ValueData       AS Value
                , Object_LabReceiptChild.isErased                   AS isErased

           FROM Object AS Object_LabReceiptChild
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_LabReceiptChild.isErased
                
                LEFT JOIN ObjectLink AS ObjectLink_LabReceiptChild_LabMark
                                     ON ObjectLink_LabReceiptChild_LabMark.ObjectId = Object_LabReceiptChild.Id
                                    AND ObjectLink_LabReceiptChild_LabMark.DescId = zc_ObjectLink_LabReceiptChild_LabMark()

                LEFT JOIN ObjectLink AS ObjectLink_LabReceiptChild_Goods
                                     ON ObjectLink_LabReceiptChild_Goods.ObjectId = Object_LabReceiptChild.Id
                                    AND ObjectLink_LabReceiptChild_Goods.DescId = zc_ObjectLink_LabReceiptChild_Goods()

                LEFT JOIN ObjectFloat AS ObjectFloat_LabReceiptChild_Value
                                      ON ObjectFloat_LabReceiptChild_Value.ObjectId = Object_LabReceiptChild.Id
                                     AND ObjectFloat_LabReceiptChild_Value.DescId =zc_ObjectFloat_LabReceiptChild_Value()

           WHERE Object_LabReceiptChild.DescId = zc_Object_LabReceiptChild()
             AND (ObjectLink_LabReceiptChild_LabMark.ChildObjectId = inLabMarkId OR inLabMarkId = 0)
             AND (ObjectLink_LabReceiptChild_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
          ) AS tmpLabReceiptChild

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpLabReceiptChild.GoodsId
          LEFT JOIN Object AS Object_LabMark ON Object_LabMark.Id = tmpLabReceiptChild.LabMarkId
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_LabReceiptChild (0, 0  ,FALSE, '2')

