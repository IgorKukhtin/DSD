-- Function: gpGet_Object_ReceiptChild(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptChild(
    IN inId          Integer,       -- Составляющие рецептур 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Value TFloat,
               isWeightMain Boolean, isTaxExit Boolean, isReal Boolean, isEtiketka Boolean,
               StartDate TDateTime, EndDate TDateTime, Comment TVarChar,
               ReceiptId Integer, ReceiptName TVarChar, 
               PGoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               isErased Boolean
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ReceiptChild());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , CAST ('' as TVarChar) AS Value  
         
           , CAST (FALSE AS Boolean) AS isWeightMain
           , CAST (FALSE AS Boolean) AS isTaxExit
           , CAST (FALSE AS Boolean) AS isReal  
           , CAST (FALSE AS Boolean) AS isEtiketka
           , CAST ('' as TDateTime)  AS StartDate
           , CAST ('' as TDateTime)  AS EndDate
           , CAST ('' as TVarChar)   AS Comment
 
           , CAST (0 as Integer)   AS ReceiptId
           , CAST ('' as TVarChar) AS ReceiptName

           , CAST (0 as Integer)   AS GoodsId
           , CAST (0 as Integer)   AS GoodsCode
           , CAST ('' as TVarChar) AS GoodsName

           , CAST (0 as Integer)   AS GoodsKindId
           , CAST (0 as Integer)   AS GoodsKindCode
           , CAST ('' as TVarChar) AS GoodsKindName

           , CAST (FALSE AS Boolean) AS isErased
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ReceiptChild.Id      AS Id
         , ObjectFloat_Value.ValueData AS Value  
         
         , ObjectBoolean_WeightMain.ValueData AS isWeightMain
         , ObjectBoolean_TaxExit.ValueData    AS isTaxExit
         , ObjectBoolean_Real.ValueData     ::Boolean AS isReal
         , ObjectBoolean_Etiketka.ValueData ::Boolean AS isEtiketka
         , ObjectDate_StartDate.ValueData     AS StartDate
         , ObjectDate_EndDate.ValueData       AS EndDate
         , ObjectString_Comment.ValueData     AS Comment
 
         , Object_Receipt.Id         AS ReceiptId
         , Object_Receipt.ValueData  AS ReceiptName

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_ReceiptChild.isErased AS isErased
         
     FROM Object AS Object_ReceiptChild
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
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ReceiptChild_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = Object_ReceiptChild.Id 
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ReceiptChild_End()
            
          LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                  ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id 
                                 AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                  ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                 AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Real
                                  ON ObjectBoolean_Real.ObjectId = Object_ReceiptChild.Id
                                 AND ObjectBoolean_Real.DescId = zc_ObjectBoolean_ReceiptChild_Real()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Etiketka
                                  ON ObjectBoolean_Etiketka.ObjectId = Object_ReceiptChild.Id
                                 AND ObjectBoolean_Etiketka.DescId = zc_ObjectBoolean_ReceiptChild_Etiketka()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptChild_Comment()
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                               
     WHERE Object_ReceiptChild.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReceiptChild(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.24         *
 27.09.22         *
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_
 09.07.13         *              

*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptChild (100, '2')
