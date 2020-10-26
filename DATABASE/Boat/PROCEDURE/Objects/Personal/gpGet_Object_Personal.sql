-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники
    IN inMaskId      Integer   ,    -- id для копирования
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar,
               UnitId Integer, UnitName TVarChar,
               Comment TVarChar,
               DateIn TDateTime, DateOut TDateTime, isDateOut Boolean, isMain Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Personal());
   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) <> 0))
   THEN
     RETURN QUERY
     SELECT
           Object_Personal_View.MemberId     AS MemberId
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionName
         
         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitName

         , ObjectString_Comment.ValueData    AS Comment

         , Object_Personal_View.DateIn
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut

         , Object_Personal_View.isDateOut
         , FALSE :: Boolean AS isMain

    FROM Object_Personal_View
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Personal_View.PersonalId
                                AND ObjectString_Comment.DescId = zc_ObjectString_Personal_Comment()  
    WHERE Object_Personal_View.PersonalId = inMaskId;
   END IF;

   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) = 0))
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)   AS MemberId
           , CAST (0 as Integer)   AS MemberCode
           , CAST ('' as TVarChar) AS MemberName

           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST ('' as TVarChar) AS Comment

           , CURRENT_DATE :: TDateTime AS DateIn
           , CURRENT_DATE :: TDateTime AS DateOut
           , FALSE  AS isDateOut
           , FALSE  AS isMain;
  END IF;

  IF COALESCE (inId, 0) <> 0
   THEN
     RETURN QUERY
     SELECT
           Object_Personal_View.MemberId     AS MemberId
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitName

         , ObjectString_Comment.ValueData    AS Comment

         , Object_Personal_View.DateIn
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut

         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain

    FROM Object_Personal_View
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Personal_View.PersonalId
                                AND ObjectString_Comment.DescId = zc_ObjectString_Personal_Comment()  
    WHERE Object_Personal_View.PersonalId = inId;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Personal (100, '2')