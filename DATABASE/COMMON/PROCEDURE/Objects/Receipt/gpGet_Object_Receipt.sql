﻿-- Function: gpGet_Object_Receipt(integer, TVarChar)

--DROP FUNCTION gpGet_Object_Receipt(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Receipt(
    IN inId          Integer,       -- Составляющие рецептур 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, Code TVarChar, Comment TVarChar,
               Value TFloat, ValueCost TFloat, TaxExit TFloat, PartionValue TFloat, PartionCount TFloat, WeightPackage TFloat,
               StartDate TDateTime, EndDate TDateTime,
               Main boolean,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,                
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               GoodsKindCompleteId Integer, GoodsKindCompleteCode Integer, GoodsKindCompleteName TVarChar,
               ReceiptCostId Integer, ReceiptCostCode Integer, ReceiptCostName TVarChar,    
               ReceiptKindId Integer, ReceiptKindCode Integer, ReceiptKindName TVarChar,                
               isErased boolean
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Receipt());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , CAST ('' as TVarChar) AS NAME
          
           , CAST ('' as TVarChar) AS Code
           , CAST ('' as TVarChar) AS Comment         
 
           , CAST ('' as TVarChar) AS Value  
           , CAST ('' as TVarChar) AS ValueCost
           , CAST ('' as TVarChar) AS TaxExit
           , CAST ('' as TVarChar) AS PartionValue
           , CAST ('' as TVarChar) AS PartionCount
           , CAST ('' as TVarChar) AS WeightPackage
                                                        
           , CAST ('' as TDateTime) AS StartDate
           , CAST ('' as TDateTime) AS EndDate
        
           , CAST (NULL AS Boolean) AS Main
         
           , CAST (0 as Integer)   AS GoodsId
           , CAST (0 as Integer)   AS GoodsCode
           , CAST ('' as TVarChar) AS GoodsName

           , CAST (0 as Integer)   AS GoodsKindId
           , CAST (0 as Integer)   AS GoodsKindCode
           , CAST ('' as TVarChar) AS GoodsKindName

           , CAST (0 as Integer)   AS GoodsKindCompleteId
           , CAST (0 as Integer)   AS GoodsKindCompleteCode
           , CAST ('' as TVarChar) AS GoodsKindCompleteName

           , CAST (0 as Integer)   AS ReceiptCostId
           , CAST (0 as Integer)   AS ReceiptCostCode
           , CAST ('' as TVarChar) AS ReceiptCostName

           , CAST (0 as Integer)   AS ReceiptKindId
           , CAST (0 as Integer)   AS ReceiptKindCode
           , CAST ('' as TVarChar) AS ReceiptKindName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object 
       WHERE Object.DescId = zc_Object_Receipt();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Receipt.Id        AS Id
         , Object_Receipt.ValueData AS NAME
          
         , ObjectString_Code.ValueData    AS Code
         , ObjectString_Comment.ValueData AS Comment         
 
         , ObjectFloat_Value.ValueData         AS Value  
         , ObjectFloat_ValueCost.ValueData     AS ValueCost
         , ObjectFloat_TaxExit.ValueData       AS TaxExit
         , ObjectFloat_PartionValue.ValueData  AS PartionValue
         , ObjectFloat_PartionCount.ValueData  AS PartionCount
         , ObjectFloat_WeightPackage.ValueData AS WeightPackage
                                                        
         , ObjectDate_StartDate.ValueData AS StartDate
         , ObjectDate_EndDate.ValueData   AS EndDate
        
         , ObjectBoolean_Main.ValueData AS Main
         
         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsKindComplete.Id          AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ObjectCode  AS GoodsKindCompleteCode
         , Object_GoodsKindComplete.ValueData   AS GoodsKindCompleteName

         , Object_ReceiptCost.Id          AS ReceiptCostId
         , Object_ReceiptCost.ObjectCode  AS ReceiptCostCode
         , Object_ReceiptCost.ValueData   AS ReceiptCostName

         , Object_ReceiptKind.Id          AS ReceiptKindId
         , Object_ReceiptCost.ObjectCode  AS ReceiptKindCode
         , Object_ReceiptCost.ValueData   AS ReceiptKindName

         , Object_Receipt.isErased AS isErased
         
     FROM OBJECT AS Object_Receipt
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                              ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                             AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                               ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = ObjectLink_Receipt_GoodsKindComplete.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptCost
                               ON ObjectLink_Receipt_ReceiptCost.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptCost.DescId = zc_ObjectLink_Receipt_ReceiptCost()
          LEFT JOIN Object AS Object_ReceiptCost ON Object_ReceiptCost.Id = ObjectLink_Receipt_ReceiptCost.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptKind
                               ON ObjectLink_Receipt_ReceiptKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptKind.DescId = zc_ObjectLink_Receipt_ReceiptKind()
          LEFT JOIN Object AS Object_ReceiptKind ON Object_ReceiptKind.Id = ObjectLink_Receipt_ReceiptKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                               ON ObjectDate_StartDate.ObjectId = Object_Receipt.Id 
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_Receipt_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = Object_Receipt.Id 
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_Receipt_End()
            
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id 
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                 
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Receipt.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()
                                
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost 
                                ON ObjectFloat_ValueCost.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()
                               
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionValue
                                ON ObjectFloat_PartionValue.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_PartionValue.DescId = zc_ObjectFloat_Receipt_PartionValue()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionCount 
                                ON ObjectFloat_PartionCount.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_PartionCount.DescId = zc_ObjectFloat_Receipt_PartionCount()

          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage 
                                ON ObjectFloat_WeightPackage.ObjectId = Object_Receipt.Id 
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_Receipt_WeightPackage()
                               
     WHERE Object_Receipt.Id = inId;
     
  END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Receipt(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.13         * rename zc_ObjectDate_
 09.07.13         *              

*/

-- тест
-- SELECT * FROM gpGet_Object_Receipt (100, '2')