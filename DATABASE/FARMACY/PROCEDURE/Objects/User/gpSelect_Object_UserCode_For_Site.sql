-- Function: gpSelect_Object_UserCode_For_Site()

DROP FUNCTION IF EXISTS gpSelect_Object_UserCode_For_Site (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserCode_For_Site(
    IN inSession       TVarChar       -- сессия пользователя    
)
RETURNS TABLE (Id             Integer    -- Ключ пользователя
             , Code           Integer    -- Код
             , Name           TVarChar   -- ФИО
             , MemberName     TVarChar   -- ФИО физ.лица
             , UnitId         Integer    -- Ключ Аптеки
             , UnitName       TVarChar   -- Аптека
             , PositionName   TVarChar   -- должность
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpUserUnit AS (SELECT DefaultValue.UserKeyId  AS UserId
                                 , MAX(DefaultValue.DefaultValue::Integer)::Integer AS UnitId
                            FROM DefaultValue
                                 INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                            WHERE DefaultKeys.Key = 'zc_Object_Unit'
                              AND COALESCE(DefaultValue.DefaultValue, '') <> ''
                            GROUP BY DefaultValue.UserKeyId)                              
          , tmpUserAll AS (SELECT Object_User.Id                    AS Id
                                , Object_User.ObjectCode    
                                , Object_User.ValueData
                                , tmpUserUnit.UnitId
                           FROM Object AS Object_User 
                           
                                LEFT JOIN tmpUserUnit ON tmpUserUnit.UserId = Object_User.Id  
                                                                                                           
                           WHERE Object_User.DescId   = zc_Object_User()
                             AND Object_User.isErased = FALSE
                          )
          , tmpUser AS (SELECT Object_User.Id                    AS UserId
                             , Object_Member.Id                  AS MemberId
                             , Object_Member.ValueData           AS MemberName
                             , Object_User.ValueData             AS Name
                             , Object_User.ObjectCode            AS Code
                             , Object_Position.ObjectCode        AS PositionCode
                             , Object_Position.ValueData         AS PositionName
                             , Object_User.UnitId                AS UnitId
                        FROM tmpUserAll AS Object_User 
                                                                 
                             LEFT JOIN ObjectDate AS ObjectDate_Personal_In
                                                  ON ObjectDate_Personal_In.ObjectId  = Object_User.Id
                                                 AND ObjectDate_Personal_In.DescId    = zc_ObjectDate_Personal_In()
                     
                             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                
                             LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                  ON ObjectLink_Member_Position.ObjectId = Object_Member.Id
                                                 AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                             LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
             
                       )
        SELECT
             tmpUser.UserId AS Id
           , tmpUser.Code                   AS Code
           , tmpUser.Name       :: TVarChar AS Name
           , tmpUser.MemberName :: TVarChar AS MemberName
           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName
           , tmpUser.PositionName      AS PositionName
           
        FROM tmpUser
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpUser.UnitId
        WHERE COALESCE (tmpUser.UnitId, 0) <> 0
          AND tmpUser.PositionCode IN (1, 2)
        ORDER BY tmpUser.Code
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 21.02.22                                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_UserCode_For_Site (zfCalc_UserSite()); 