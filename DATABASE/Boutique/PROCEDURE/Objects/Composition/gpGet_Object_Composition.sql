-- Function: gpGet_Object_Composition()

DROP FUNCTION IF EXISTS gpGet_Object_Composition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Composition(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Name_UKR TVarChar
             , CompositionGroupId Integer, CompositionGroupName TVarChar) 
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
           , lfGet_ObjectCode(0, zc_Object_Composition())   AS Code
           , '' :: TVarChar   AS Name
           , '' :: TVarChar   AS Name_UKR
           ,  0 :: Integer    AS CompositionGroupId
           , '' :: TVarChar   AS CompositionGroupName
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Composition.Id               AS Id
           , Object_Composition.ObjectCode       AS Code
           , Object_Composition.ValueData        AS Name
           , COALESCE (ObjectString_UKR.ValueData, NULL) :: TVarChar AS Name_UKR

           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
       FROM Object AS Object_Composition
            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_UKR
                                   ON ObjectString_UKR.ObjectId = Object_Composition.Id
                                  AND ObjectString_UKR.DescId = zc_ObjectString_Composition_UKR()

       WHERE Object_Composition.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
25.08.20          * add Name_UKR
17.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Composition(1,'2')
