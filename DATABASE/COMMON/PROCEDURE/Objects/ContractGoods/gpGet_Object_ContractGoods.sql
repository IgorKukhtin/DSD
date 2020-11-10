-- Function: gpGet_Object_ContractGoods (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractGoods(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code INTEGER
             , Price TFloat
             , ContractId Integer, ContractName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractGoods());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractGoods()) AS Code
           , CAST (0 as TFloat)     AS Price
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName  

           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName

           , CAST (0 as Integer)    AS GoodsKindId
           , CAST ('' as TVarChar)  AS GoodsKindName

           , CAST (NULL AS TDateTime)  AS StartDate
           , CAST (NULL AS TDateTime)  AS EndDate
           
           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractGoods.Id          AS Id
           , Object_ContractGoods.ObjectCode  AS Code
          
           , ObjectFloat_Price.ValueData      AS Price
          
           , Object_Contract.Id               AS ContractId
           , Object_Contract.ValueData        AS ContractName

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ValueData           AS GoodsName
           
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName

           , ObjectDate_Start.ValueData   ::TDateTime  AS StartDate
           , ObjectDate_End.ValueData     ::TDateTime  AS EndDate

           , Object_ContractGoods.isErased    AS isErased
           
       FROM Object AS Object_ContractGoods

            LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                  ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                 AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price()

            LEFT JOIN ObjectLink AS ContractGoods_Contract
                                 ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ContractGoods_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                 ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ContractGoods_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                 ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_ContractGoods_GoodsKind.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()

       WHERE Object_ContractGoods.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_ContractGoods (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.15         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractGoods (0, inSession := '5')
