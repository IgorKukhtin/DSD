DROP FUNCTION IF EXISTS gpGet_Object_RecalcMCSSheduler(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RecalcMCSSheduler(
    IN inId       Integer,       -- ID
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar
             , WeekId Integer
             , WeekName TVarChar
             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             , IsErased Boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- Результат
    IF  inId = 0
    THEN
        RETURN QUERY
            SELECT
                0                AS Id
               ,lfGet_ObjectCode(0, zc_Object_RecalcMCSSheduler()) AS Code
               ,NULL::Integer    AS UnitId
               ,NULL::Integer    AS UnitCode
               ,NULL::TVarChar   AS UnitName
               ,NULL::Integer    AS WeekId
               ,NULL::TVarChar   AS WeekName
               ,NULL::Integer    AS UserId
               ,NULL::Integer    AS UserCode
               ,NULL::TVarChar   AS UserName
               ,FALSE            AS IsErased
            ;
    ELSE
        RETURN QUERY
            SELECT
                Object_RecalcMCSSheduler.Id         AS Id
               ,Object_RecalcMCSSheduler.ObjectCode AS Code
               ,Object_Unit.Id                      AS UnitId
               ,Object_Unit.ObjectCode              AS UnitCode
               ,Object_Unit.ValueData               AS UnitName
               ,ObjectFloat_Week.ValueData::Integer AS WeekId
               ,tmpWeek.Name                        AS WeekName
               ,Object_User.Id                      AS UserId
               ,Object_User.ObjectCode              AS UserCode
               ,Object_User.ValueData               AS UserName
               ,Object_RecalcMCSSheduler.IsErased   AS IsErased
            FROM
                Object AS Object_RecalcMCSSheduler
                 LEFT JOIN ObjectLink AS ObjectLink_Unit
                                      ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                     AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                 LEFT JOIN Object AS Object_Unit
                                  ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                 LEFT JOIN ObjectFloat AS ObjectFloat_Week
                                       ON ObjectFloat_Week.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectFloat_Week.DescId = zc_ObjectFloat_RecalcMCSSheduler_Week()
                 LEFT JOIN gpSelect_Week(inSession) AS tmpWeek ON tmpWeek.ID = ObjectFloat_Week.ValueData::Integer

                 LEFT JOIN ObjectLink AS ObjectLink_User
                                      ON ObjectLink_User.ObjectId = Object_RecalcMCSSheduler.Id
                                     AND ObjectLink_User.DescId = zc_ObjectLink_RecalcMCSSheduler_User()
                 LEFT JOIN Object AS Object_User
                                  ON Object_User.Id = ObjectLink_User.ChildObjectId
            WHERE
                Object_RecalcMCSSheduler.Id = inId;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RecalcMCSSheduler(Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий. О.В.
 21.12.18                                                                       *
*/