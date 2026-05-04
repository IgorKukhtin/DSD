-- Function: gpSelect_Object_Position(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Position (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Position (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Position(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               PositionPropertyId Integer, PositionPropertyName TVarChar,
               isnotMemberGoods Boolean,
               isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name

         , Object_SheetWorkTime.Id        AS SheetWorkTimeId 
         , Object_SheetWorkTime.ValueData AS SheetWorkTimeName
         , Object_PositionProperty.Id        AS PositionPropertyId 
         , Object_PositionProperty.ValueData AS PositionPropertyName
         , COALESCE (ObjectBoolean_notMemberGoods.ValueData, FALSE) :: Boolean AS isnotMemberGoods
         , Object_Position.isErased       AS isErased

     FROM Object AS Object_Position
          LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                               ON ObjectLink_Position_SheetWorkTime.ObjectId = Object_Position.Id
                              AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Position_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                               ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                              AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
          LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_notMemberGoods
                                  ON ObjectBoolean_notMemberGoods.ObjectId = Object_Position.Id
                                 AND ObjectBoolean_notMemberGoods.DescId = zc_ObjectBoolean_Position_notMemberGoods()

     WHERE Object_Position.DescId = zc_Object_Position()
       AND (Object_Position.isErased = inIsShowAll OR inIsShowAll = TRUE)

  /*UNION ALL
     SELECT 
           NULL:: Integer        AS Id
         , NULL:: Integer        AS Code
         , '<ПУСТО>' :: TVarChar AS Name
         , 0  :: Integer         AS SheetWorkTimeId 
         , '' :: TVarChar        AS SheetWorkTimeName
         , 0  :: Integer         AS PositionPropertyId 
         , '' :: TVarChar        AS PositionPropertyName
         , CAST (FALSE AS Boolean) AS isnotMemberGoods
         , TRUE :: Boolean       AS isErased*/

     ;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Position(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.26         *
 28.03.25         *
 28.10.24         *
 16.11.16         * add SheetWorkTime
 01.07.13         *              
*/

-- тест
-- SELECT * FROM gpSelect_Object_Position (FALSE, '2')
