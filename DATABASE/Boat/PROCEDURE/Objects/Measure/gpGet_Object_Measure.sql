-- Function: gpGet_Object_Measure()

DROP FUNCTION IF EXISTS gpGet_Object_Measure (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Measure(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MeasureCodeId Integer, MeasureCodeName TVarChar
             , InternalCode TVarChar, InternalName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , lfGet_ObjectCode(0, zc_Object_Measure())  AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS MeasureCodeId
           , '' :: TVarChar                            AS MeasureCodeName
           , '' :: TVarChar                            AS InternalCode
           , '' :: TVarChar                            AS InternalName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name

           , Object_MeasureCode.Id        AS MeasureCodeId
           , Object_MeasureCode.ValueData AS MeasureCodeName

           , OS_Measure_InternalCode.ValueData  AS InternalCode
           , OS_Measure_InternalName.ValueData  AS InternalName
       FROM Object
        LEFT JOIN ObjectString AS OS_Measure_InternalName
                               ON OS_Measure_InternalName.ObjectId = Object.Id
                              AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()
        LEFT JOIN ObjectString AS OS_Measure_InternalCode
                               ON OS_Measure_InternalCode.ObjectId = Object.Id
                              AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()
        LEFT JOIN ObjectLink AS ObjectLink_MeasureCode
                             ON ObjectLink_MeasureCode.ObjectId = Object.Id
                            AND ObjectLink_MeasureCode.DescId = zc_ObjectLink_Measure_MeasureCode()
        LEFT JOIN Object AS Object_MeasureCode ON Object_MeasureCode.Id = ObjectLink_MeasureCode.ChildObjectId
                              
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 17.02.22         *
 08.05.17                                                         *
 16.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Measure (1,'2')
