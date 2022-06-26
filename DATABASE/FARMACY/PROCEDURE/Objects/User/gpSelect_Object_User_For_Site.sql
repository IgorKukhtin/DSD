-- Function: gpSelect_Object_User_For_Site()

DROP FUNCTION IF EXISTS gpSelect_Object_User_For_Site (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_For_Site(
    IN inUnitId        Integer,       -- Аптека
    IN inSession       TVarChar       -- сессия пользователя    
)
RETURNS TABLE (Id              Integer    -- Ключ пользователя
             , Name            TVarChar   -- ФИО
             , MemberName      TVarChar   -- ФИО физ.лица
             , Name_Only       TVarChar   -- Только Имя
             , MemberNameUkr   TVarChar   -- ФИО физ.лица на Украинском языке
             , NameUkr_Only    TVarChar   -- Только Имя на Украинском языке
             , Foto            TVarChar   -- Фото
             , DateIn          TDateTime  -- Дата с которого числа работает
             , DateAction      TDateTime  -- Дата/ время последней активности
             , DateAction_1    TDateTime  -- Дата/ время последней активности
             , DateAction_2    TDateTime  -- Дата/ время последней активности
             , UnitId          Integer    -- Ключ Аптеки
             , UnitName        TVarChar   -- Аптека
             , PositionName    TVarChar   -- должность
             , PositionNameUkr TVarChar   -- должность на Украинском языке
             , isSite          Boolean    --
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
       WITH tmpUserAll AS (SELECT Object_User.Id                    AS Id
                                , Object_User.ValueData
                                , zfConvert_StringToNumber (lpGet_DefaultValue('zc_Object_Unit', Object_User.Id)) AS UnitId
                                , COALESCE (ObjectBoolean_Site.ValueData, FALSE)       AS isSite
                           FROM Object AS Object_User 
                                                                
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Site
                                                        ON ObjectBoolean_Site.ObjectId = Object_User.Id
                                                       AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_User_Site()
                                           
                           WHERE Object_User.DescId   = zc_Object_User()
                             AND Object_User.isErased = FALSE
                             AND COALESCE (ObjectBoolean_Site.ValueData, FALSE) = TRUE
                          )
          , tmpUser AS (SELECT Object_User.Id                    AS UserId
                             , Object_Member.Id                  AS MemberId
                             , Object_Member.ValueData           AS MemberName
                             , ObjectString_NameUkr.ValueData    AS MemberNameUkr
                             , Object_User.ValueData             AS Name
                             , ObjectString_Foto.ValueData       AS Foto
                             , Object_Education.ValueData        AS EducationName
                             , ObjectString_Education_NameUkr.ValueData  AS EducationNameUkr
                             , zfConvert_StringToNumber (lpGet_DefaultValue('zc_Object_Unit', Object_User.Id)) AS UnitId
                             , ObjectDate_Personal_In.ValueData AS DateIn
                             , Object_User.isSite
                        FROM tmpUserAll AS Object_User 
                                                                 
                             LEFT JOIN ObjectString AS ObjectString_Foto
                                                    ON ObjectString_Foto.ObjectId  = Object_User.Id
                                                   AND ObjectString_Foto.DescId    = zc_ObjectString_User_Foto()
                             LEFT JOIN ObjectDate AS ObjectDate_Personal_In
                                                  ON ObjectDate_Personal_In.ObjectId  = Object_User.Id
                                                 AND ObjectDate_Personal_In.DescId    = zc_ObjectDate_Personal_In()
                     
                             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                             LEFT JOIN ObjectString AS ObjectString_NameUkr
                                                    ON ObjectString_NameUkr.ObjectId = Object_Member.Id
                                                   AND ObjectString_NameUkr.DescId = zc_ObjectString_Member_NameUkr()
                                
                             LEFT JOIN ObjectLink AS ObjectLink_Member_Education
                                                  ON ObjectLink_Member_Education.ObjectId = Object_Member.Id
                                                 AND ObjectLink_Member_Education.DescId = zc_ObjectLink_Member_Education()
                             LEFT JOIN Object AS Object_Education ON Object_Education.Id = ObjectLink_Member_Education.ChildObjectId

                             LEFT JOIN ObjectString AS ObjectString_Education_NameUkr
                                                    ON ObjectString_Education_NameUkr.ObjectId = Object_Education.Id 
                                                   AND ObjectString_Education_NameUkr.DescId = zc_ObjectString_Education_NameUkr()
             
                        WHERE Object_User.UnitId = inUnitId OR COALESCE (inUnitId, 0) = 0
                       )
          , tmpCashSession AS (SELECT CashSession.UserId
                                    , MAX (CashSession.LastConnect) AS LastConnect
                               FROM CashSession
                               GROUP BY CashSession.UserId
                              )
          , tmpProtocol AS (SELECT tmpUser.UserId
                                 , MAX (MovementProtocol.OperDate) AS OperDate
                            FROM tmpUser
                                 INNER JOIN MovementProtocol ON MovementProtocol.UserId = tmpUser.UserId
                                                            -- AND MovementProtocol.OperDate >= CURRENT_DATE - INTERVAL '30 DAY'
                                                            AND MovementProtocol.OperDate = NULL
                            GROUP BY tmpUser.UserId
                           )
        SELECT
             tmpUser.UserId AS Id
           , tmpUser.Name       :: TVarChar AS Name
           , tmpUser.MemberName :: TVarChar AS MemberName
           , zfConvert_FIO_Name (tmpUser.MemberName) :: TVarChar AS Name_Only
           , tmpUser.MemberNameUkr :: TVarChar AS MemberNameUkr
           , zfConvert_FIO_Name (tmpUser.MemberNameUkr) :: TVarChar AS NameUkr_Only
           , tmpUser.Foto          
           , tmpUser.DateIn
           , CASE WHEN COALESCE (tmpProtocol.OperDate, zc_DateStart()) > COALESCE (tmpCashSession.LastConnect, zc_DateStart())
                       THEN tmpProtocol.OperDate
                  WHEN COALESCE (tmpCashSession.LastConnect, zc_DateStart()) > zc_DateStart()
                       THEN tmpCashSession.LastConnect
                  ELSE COALESCE (tmpUser.DateIn, zc_DateStart())
             END :: TDateTime AS DateAction
           , tmpProtocol.OperDate       :: TDateTime AS DateAction_1
           , tmpCashSession.LastConnect :: TDateTime AS DateAction_2
           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName
           --, Object_Position.ValueData AS PositionName
           , tmpUser.EducationName     AS PositionName
           , tmpUser.EducationNameUkr  AS PositionNameUkr
           , tmpUser.isSite             :: Boolean
           
        FROM tmpUser
             --LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpUser.MemberId
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpUser.UnitId
             --LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
             LEFT JOIN tmpCashSession ON tmpCashSession.UserId = tmpUser.UserId
             LEFT JOIN tmpProtocol    ON tmpProtocol.UserId    = tmpUser.UserId
        WHERE COALESCE (tmpUser.UnitId, 0) <> 0
          AND tmpUser.isSite = TRUE
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 26.05.20                                                                       *
 06.11.17         *
 08.09.17                                        *
*/

-- тест
-- 

SELECT * FROM gpSelect_Object_User_For_Site (inUnitId:= 375626, inSession:= '3'); -- Аптека_1 пр_Героев_40 WHERE DateAction >= '08.09.2017'
