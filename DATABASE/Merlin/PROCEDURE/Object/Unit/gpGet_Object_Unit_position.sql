-- Function: gpGet_Object_Unit_Position(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit_Position (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit_Position(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer, Left Integer, Top Integer, Width Integer, Height Integer
 ) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

       RETURN QUERY
       SELECT 
             Object_Unit.Id                        AS Id
           , ObjectFloat_Left.ValueData::Integer   AS Left
           , ObjectFloat_Top.ValueData::Integer    AS Top
           , ObjectFloat_Width.ValueData::Integer  AS Width
           , ObjectFloat_Height.ValueData::Integer AS Height
       FROM Object AS Object_Unit
           LEFT JOIN ObjectFloat AS ObjectFloat_Left
                                 ON ObjectFloat_Left.ObjectId = Object_Unit.Id
                                AND ObjectFloat_Left.DescId = zc_ObjectFloat_Unit_Left()
           LEFT JOIN ObjectFloat AS ObjectFloat_Top
                                 ON ObjectFloat_Top.ObjectId = Object_Unit.Id
                                AND ObjectFloat_Top.DescId = zc_ObjectFloat_Unit_Top()
           LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                 ON ObjectFloat_Width.ObjectId = Object_Unit.Id
                                AND ObjectFloat_Width.DescId = zc_ObjectFloat_Unit_Width()
           LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                 ON ObjectFloat_Height.ObjectId = Object_Unit.Id
                                AND ObjectFloat_Height.DescId = zc_ObjectFloat_Unit_Height()
      WHERE Object_Unit.Id = inId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.08.22         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Unit_Position(1,'2')