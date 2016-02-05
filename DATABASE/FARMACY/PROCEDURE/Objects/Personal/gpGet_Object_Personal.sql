-- Function: gpGet_Object_Personal(Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники
    IN inMemberId    Integer,       -- физ.лицо 
    IN inMaskId      Integer   ,    -- id для копирования
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionName TVarChar,
               UnitId Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime,
               isDateOut Boolean, isOfficial Boolean, isMain Boolean) AS
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

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupName

         , Object_Personal_View.DateIn
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isOfficial
         , Object_Personal_View.isMain

    FROM Object_Personal_View
          
    WHERE Object_Personal_View.PersonalId = inMaskId;
   END IF;

   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) = 0))
   THEN
       RETURN QUERY
       SELECT
             COALESCE (Object_Member.Id, 0)         :: Integer   AS MemberId
           , COALESCE (Object_Member.ObjectCode, 0) :: Integer   AS MemberCode
           , COALESCE (Object_Member.ValueData, '') :: TVarChar  AS MemberName

           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS PersonalGroupId
           , CAST ('' as TVarChar) AS PersonalGroupName

           , CURRENT_DATE :: TDateTime AS DateIn
           , CURRENT_DATE :: TDateTime AS DateOut
           , FALSE AS isDateOut
           , FALSE AS isOfficial
           , FALSE AS isMain
         FROM Object AS Object_Member 
         WHERE Object_Member.Id = COALESCE(inMemberId,0) ;

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

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupName

         , Object_Personal_View.DateIn
         -- , Object_Personal_View.DateOut
         , CASE WHEN Object_Personal_View.DateOut_user IS NULL THEN CURRENT_DATE ELSE Object_Personal_View.DateOut_user END :: TDateTime AS DateOut

         , Object_Personal_View.isDateOut
         , Object_Personal_View.isOfficial
         , Object_Personal_View.isMain

    FROM Object_Personal_View
          
    WHERE Object_Personal_View.PersonalId = inId;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Personal (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.16         *
 
*/

-- тест
-- SELECT * FROM gpGet_Object_Personal (100, '2')

--select * from gpGet_Object_Personal(Id := 0 ::Integer, inMemberId := 942571::Integer , inMaskId := False ,  inSession := '3'::TVarChar);