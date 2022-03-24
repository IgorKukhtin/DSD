-- Function: gpSelect_LoginProtocol()

DROP FUNCTION IF EXISTS gpSelect_LoginProtocol (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoginProtocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UserId Integer, UserCode Integer, UserName TVarChar
             , UserRoleName TVarChar
             )
AS
$BODY$
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  WITH tmpUserRole AS (SELECT ObjectLink_UserRole_User.ChildObjectId                                        AS UserId
                            , string_agg(DISTINCT
                                         CASE WHEN ObjectRole.ObjectCode in (1) THEN 'Админ'
                                                WHEN ObjectRole.ObjectCode in (114) THEN 'Mаретинг'
                                                WHEN ObjectRole.ObjectCode in (2, 5, 7) THEN 'Mенеджер'
                                                WHEN ObjectRole.ObjectCode in (4) THEN 'Кассир'
                                                ELSE ObjectRole.valuedata END, ', ')::TVarChar              AS Name
                      FROM ObjectLink AS ObjectLink_UserRole_Role

                           INNER JOIN ObjectLink AS ObjectLink_UserRole_User 
                                                 ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                                AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User() 

                           INNER JOIN Object AS ObjectRole ON ObjectRole.Id = ObjectLink_UserRole_Role.ChildObjectId
                            
                      WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                        AND ObjectRole.ObjectCode in (1, 2, 4, 5, 7, 114)
                      GROUP BY ObjectLink_UserRole_User.ChildObjectId)
  
  
  SELECT LoginProtocol.OperDate
      ,  LoginProtocol.UserId
      , Object_User.ObjectCode
      , Object_User.ValueData
      , tmpUserRole.Name
  FROM LoginProtocol 

       LEFT JOIN Object AS Object_User ON Object_User.ID = LoginProtocol.UserId
       
       LEFT JOIN tmpUserRole ON tmpUserRole.UserId = LoginProtocol.UserId

  WHERE LoginProtocol.OperDate >= inStartDate 
    AND LoginProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
    AND LoginProtocol.ProtocolData ILIKE '%FieldValue = "Farmacy"%'
  ORDER BY LoginProtocol.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_LoginProtocol (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.03.22                                                       *
*/

-- тест
-- 

select * from gpSelect_LoginProtocol(inStartDate := ('24.03.2022')::TDateTime , inEndDate := ('24.03.2022')::TDateTime ,  inSession := '3');
