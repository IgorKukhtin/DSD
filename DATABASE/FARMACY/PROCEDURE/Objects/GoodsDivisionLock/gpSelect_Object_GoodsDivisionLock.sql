-- Function: gpSelect_Object_GoodsDivisionLock(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsDivisionLock(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsDivisionLock(
    IN inUnitId      Integer ,      -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , isLock Boolean
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_GoodsDivisionLock.Id                     AS Id
         , Object_GoodsDivisionLock.ObjectCode             AS Code
         , Object_GoodsDivisionLock.ValueData              AS Name

         , Object_Unit.Id                                  AS UnitId
         , Object_Unit.ObjectCode                          AS UnitCode
         , Object_Unit.ValueData                           AS UnitName

         , Object_Goods.Id                                 AS GoodsId
         , Object_Goods.ObjectCode                         AS GoodsCode
         , Object_Goods.ValueData                          AS GoodsName

         , ObjectBoolean_GoodsDivisionLock_Lock.ValueData  AS isLock
         , Object_GoodsDivisionLock.isErased               AS isErased
     FROM OBJECT AS Object_GoodsDivisionLock

          INNER JOIN ObjectLink AS ObjectLink_GoodsDivisionLock_Goods
                                ON ObjectLink_GoodsDivisionLock_Goods.ObjectId = Object_GoodsDivisionLock.Id
                               AND ObjectLink_GoodsDivisionLock_Goods.DescId = zc_ObjectLink_GoodsDivisionLock_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsDivisionLock_Goods.ChildObjectId
            
          INNER JOIN ObjectLink AS ObjectLink_GoodsDivisionLock_Unit
                                ON ObjectLink_GoodsDivisionLock_Unit.ObjectId = Object_GoodsDivisionLock.Id
                               AND ObjectLink_GoodsDivisionLock_Unit.DescId = zc_ObjectLink_GoodsDivisionLock_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_GoodsDivisionLock_Unit.ChildObjectId
            
          LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsDivisionLock_Lock
                                  ON ObjectBoolean_GoodsDivisionLock_Lock.ObjectId = Object_GoodsDivisionLock.Id
                                 AND ObjectBoolean_GoodsDivisionLock_Lock.DescId = zc_ObjectBoolean_GoodsDivisionLock_Lock()

     WHERE Object_GoodsDivisionLock.DescId = zc_Object_GoodsDivisionLock()
       AND (inUnitId = 0 OR ObjectLink_GoodsDivisionLock_Goods.ChildObjectId = inUnitId);
    
END;
$BODY$
   
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsDivisionLock(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.05.21                                                      *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_GoodsDivisionLock(0, '3')