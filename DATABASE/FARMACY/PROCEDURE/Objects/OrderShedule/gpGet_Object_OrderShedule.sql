-- Function: gpGet_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpGet_Object_OrderShedule(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OrderShedule(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer,
               Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, 
               Value5 TFloat, Value6 TFloat, Value7 TFloat,
               UnitId Integer, UnitName TVarChar,
               ContractId Integer, ContractName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_OrderShedule()); 
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_OrderShedule()) AS Code
      
           , CAST (0 as TFloat)   AS Value1
           , CAST (0 as TFloat)   AS Value2
           , CAST (0 as TFloat)   AS Value3
           , CAST (0 as TFloat)   AS Value4
           , CAST (0 as TFloat)   AS Value5
           , CAST (0 as TFloat)   AS Value6
           , CAST (0 as TFloat)   AS Value7
           
           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName 

           , CAST (0 as Integer)   AS ContractId
           , CAST ('' as TVarChar) AS ContractName 
           
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT
             Object_OrderShedule.Id           AS Id
           , Object_OrderShedule.ObjectCode   AS Code
       
           , '0' ::TFloat   AS Value1
           , '1' ::TFloat   AS Value2
           , '2' ::TFloat   AS Value3
           , '3' ::TFloat   AS Value4
           , '0' ::TFloat   AS Value5
           , '0' ::TFloat   AS Value6
           , '0' ::TFloat   AS Value7
           
           , Object_Unit.Id             AS UnitId
           , Object_Unit.ValueData      AS UnitName 

           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS ContractName 
                     
           , Object_OrderShedule.isErased     AS isErased
           
       FROM Object AS Object_OrderShedule
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_OrderShedule_Contract.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderShedule_Unit.ChildObjectId           
                                  
      WHERE Object_OrderShedule.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.16         *

*/

-- тест
-- SELECT * FROM gpGet_Object_OrderShedule(0,'2')