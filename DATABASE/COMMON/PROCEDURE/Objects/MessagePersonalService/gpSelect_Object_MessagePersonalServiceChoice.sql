--
DROP FUNCTION IF EXISTS gpSelect_Object_MessagePersonalServiceChoice (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MessagePersonalServiceChoice(
    IN inSession                TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer
             , UnitId Integer, UnitName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , InsertDate_min TDateTime, InsertDate_max TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MessagePersonalService());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT tmp.Id
            , tmp.Code   --Session
            , tmp.UnitId
            , tmp.UnitName
            , tmp.PersonalServiceListId
            , tmp.PersonalServiceListName
            , tmp.InsertName
            , tmp.InsertDate
            , tmp.InsertDate_min ::TDateTime
            , tmp.InsertDate_max ::TDateTime
       FROM (SELECT Object_MessagePersonalService.Id           AS Id
                  , Object_MessagePersonalService.ObjectCode   AS Code   --Session
                  , Object_Unit.Id                             AS UnitId
                  , Object_Unit.ValueData                      AS UnitName
                  , Object_PersonalServiceList.Id              AS PersonalServiceListId
                  , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
                  , (Object_Insert.ValueData)                  AS InsertName
                  , ObjectDate_Insert.ValueData                AS InsertDate
                  , ROW_NUMBER () OVER (PARTITION BY Object_Unit.Id, Object_MessagePersonalService.ObjectCode, Object_PersonalServiceList.Id ORDER BY ObjectDate_Insert.ValueData DESC) AS Ord
                  , MIN (ObjectDate_Insert.ValueData) OVER (PARTITION BY Object_MessagePersonalService.ObjectCode, Object_PersonalServiceList.Id) AS InsertDate_min
                  , MAX (ObjectDate_Insert.ValueData) OVER (PARTITION BY Object_MessagePersonalService.ObjectCode, Object_PersonalServiceList.Id) AS InsertDate_max
              FROM Object AS Object_MessagePersonalService

                 LEFT JOIN ObjectLink AS ObjectLink_Unit
                                      ON ObjectLink_Unit.ObjectId = Object_MessagePersonalService.Id
                                     AND ObjectLink_Unit.DescId   = zc_ObjectLink_MessagePersonalService_Unit()
                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                      ON ObjectLink_PersonalServiceList.ObjectId = Object_MessagePersonalService.Id
                                     AND ObjectLink_PersonalServiceList.DescId = zc_ObjectLink_MessagePersonalService_PersonalServiceList()
                 LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_PersonalServiceList.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Insert
                                      ON ObjectLink_Insert.ObjectId = Object_MessagePersonalService.Id
                                     AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                 LEFT JOIN ObjectDate AS ObjectDate_Insert
                                      ON ObjectDate_Insert.ObjectId = Object_MessagePersonalService.Id
                                     AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

              WHERE Object_MessagePersonalService.DescId = zc_Object_MessagePersonalService()
                AND Object_MessagePersonalService.isErased = FALSE
                ) AS tmp
       WHERE tmp.Ord = 1
    /*  UNION
       SELECT 0
            , 0 ::Integer      AS Code
            , 0                AS PersonalServiceListId
            , '' ::TVarChar    AS PersonalServiceListName
            , NULL ::TVarChar  AS InsertName
            , NULL ::TDateTime AS InsertDate
            , NULL ::TDateTime AS InsertDate_min
            , NULL ::TDateTime AS InsertDate_max
            */
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MessagePersonalServiceChoice (inSession:= zfCalc_UserAdmin())
