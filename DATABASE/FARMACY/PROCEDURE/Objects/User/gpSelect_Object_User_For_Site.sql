-- Function: gpSelect_Object_User_For_Site()

DROP FUNCTION IF EXISTS gpSelect_Object_User_For_Site (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_For_Site(
    IN inUnitId        Integer,       -- Аптека
    IN inSession       TVarChar       -- сессия пользователя    
)
RETURNS TABLE (Id             Integer    -- Ключ пользователя
             , Name           TVarChar   -- ФИО
             , Foto           TVarChar   -- Фото
             , DateIn         TDateTime  -- Дата с которого числа работает
             , DateAction     TDateTime  -- Дата/ время последней активности
             , DateAction_1   TDateTime  -- Дата/ время последней активности
             , DateAction_2   TDateTime  -- Дата/ время последней активности
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
       WITH tmpUser AS (SELECT Object_User.Id AS UserId
                             -- , COALESCE (Object_Member.ValueData, Object_User.ValueData) AS Name
                             , Object_User.ValueData AS Name
                             , ObjectString_Foto.ValueData AS Foto
                             , Object_Member.Id AS MemberId
                             , zfConvert_StringToNumber (DefaultValue.DefaultValue) AS UnitId
                             , ObjectDate_Personal_In.ValueData AS DateIn
                        FROM DefaultKeys
                             INNER JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                                    AND (DefaultValue.DefaultValue = inUnitId :: TVarChar
                                                      OR COALESCE (inUnitId, 0) = 0)
                             INNER JOIN Object AS Object_User ON Object_User.Id       = DefaultValue.UserKeyId
                                                             AND Object_User.DescId   = zc_Object_User()
                                                             AND Object_User.isErased = FALSE
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
                
                        WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit')
                       )
          , tmpPersonal AS (SELECT View_Personal.MemberId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 -- , View_Personal.DateIn
                                   --  № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY View_Personal.MemberId ORDER BY View_Personal.PersonalId ASC) AS Ord
                            FROM Object_Personal_View AS View_Personal
                            WHERE View_Personal.isErased = FALSE
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
           , tmpUser.Name :: TVarChar AS Name
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
           , Object_Position.ValueData AS PositionName
           
        FROM tmpUser
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpUser.MemberId

             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpUser.UnitId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

             LEFT JOIN tmpCashSession ON tmpCashSession.UserId = tmpUser.UserId
             LEFT JOIN tmpProtocol    ON tmpProtocol.UserId    = tmpUser.UserId
        WHERE tmpUser.UnitId > 0
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 08.09.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_User_For_Site (inUnitId:= 375626, inSession:= '3'); -- Аптека_1 пр_Героев_40 WHERE DateAction >= '08.09.2017'
