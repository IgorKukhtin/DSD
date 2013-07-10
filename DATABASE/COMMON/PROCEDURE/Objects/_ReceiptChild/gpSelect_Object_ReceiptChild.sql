-- Function: gpSelect_Object_ReceiptChild()

-- DROP FUNCTION gpSelect_Object_ReceiptChild();

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptChild(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value   TFloat,Weight boolean, TaxExit boolean,
               StartDate TDateTime, EndDate TDateTime, Comment TVarChar,
               ReceiptId Integer, ReceiptName TVarChar, 
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
     SELECT 
           Object_ReceiptChild.Id      AS Id
         , ObjectFloat_Value.ValueData AS Value  
         
         , ObjectBoolean_Weight.ValueData   AS Weight
         , ObjectBoolean_TaxExit.ValueData AS TaxExit
         , ObjectDate_StartDate.ValueData  AS StartDate
         , ObjectDate_EndDate.ValueData    AS EndDate
         , ObjectString_Comment.ValueData  AS Comment
 
         , Object_Receipt.Id         AS ReceiptId
         , Object_Receipt.ValueData  AS ReceiptName

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_ReceiptChild.isErased AS isErased
         
     FROM OBJECT AS Object_ReceiptChild
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                               ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                               ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptChild_Goods.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                              ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                             AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_ReceiptChild_GoodsKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                               ON ObjectDate_StartDate.ObjectId = Object_ReceiptChild.Id 
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ReceiptChild_StartDate()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = Object_ReceiptChild.Id 
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ReceiptChild_EndDate()
            
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Weight
                                  ON ObjectBoolean_Weight.ObjectId = Object_ReceiptChild.Id 
                                 AND ObjectBoolean_Weight.DescId = zc_ObjectBoolean_ReceiptChild_Weight()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                  ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                 AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptChild_Comment()
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
     
     WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptChild (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.13         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptChild ('2')