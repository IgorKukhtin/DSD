-- Function: gpSelect_Object_JuridicalPriorities()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalPriorities(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalPriorities(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , JuridicalId Integer, JuridicalName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Priorities TFloat
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

   RETURN QUERY
       SELECT
             Object_JuridicalPriorities.Id                         AS Id
           , Object_JuridicalPriorities.ObjectCode                 AS Code
           , Object_Juridical.Id                                   AS JuridicalID
           , Object_Juridical.ValueData                            AS JuridicalName
           , Object_Goods.Id                                       AS GoodsId
           , Object_Goods.ObjectCode                               AS GoodsCode
           , Object_Goods.ValueData                                AS GoodsName

           , ObjectFloat_JuridicalPriorities_Priorities.ValueData  AS Priorities
           
           , Object_JuridicalPriorities.isErased                   AS isErased

       FROM Object AS Object_JuridicalPriorities

           LEFT JOIN ObjectLink AS ObjectLink_JuridicalPriorities_Juridical
                                ON ObjectLink_JuridicalPriorities_Juridical.ObjectId = Object_JuridicalPriorities.Id
                               AND ObjectLink_JuridicalPriorities_Juridical.DescId = zc_ObjectLink_JuridicalPriorities_Juridical()  
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_JuridicalPriorities_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_JuridicalPriorities_Goods
                                ON ObjectLink_JuridicalPriorities_Goods.ObjectId = Object_JuridicalPriorities.Id
                               AND ObjectLink_JuridicalPriorities_Goods.DescId = zc_ObjectLink_JuridicalPriorities_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_JuridicalPriorities_Goods.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalPriorities_Priorities
                                 ON ObjectFloat_JuridicalPriorities_Priorities.ObjectId = Object_JuridicalPriorities.Id
                                AND ObjectFloat_JuridicalPriorities_Priorities.DescId = zc_ObjectFloat_JuridicalPriorities_Priorities()

       WHERE Object_JuridicalPriorities.DescId = zc_Object_JuridicalPriorities()
       ORDER BY Object_JuridicalPriorities.ObjectCode
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_JuridicalPriorities(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.20                                                       *
*/

-- тест
-- 
-- SELECT * FROM gpSelect_Object_JuridicalPriorities ('3')