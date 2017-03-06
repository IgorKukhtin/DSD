-- Function: gpGet_Object_Composition()

DROP FUNCTION IF EXISTS gpGet_Object_Composition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Composition(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, CompositionGroupId Integer, CompositionGroupName TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Composition());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer    AS Id
           , NEXTVAL ('Object_Composition_seq') :: Integer AS Code
           , '' :: TVarChar   AS Name
           ,  0 :: Integer    AS CompositionGroupId
           , '' :: TVarChar   AS CompositionGroupName
       FROM Object
       WHERE Object.DescId = zc_Object_Composition();
   ELSE
       RETURN QUERY
       SELECT 
             Object_Composition.Id               AS Id
           , Object_Composition.ObjectCode       AS Code
           , Object_Composition.ValueData        AS Name    
           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
       FROM Object AS Object_Composition
            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

       WHERE Object_Composition.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
17.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Composition(1,'2')
