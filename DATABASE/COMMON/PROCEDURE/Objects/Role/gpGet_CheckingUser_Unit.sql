-- Function: gpGet_CheckingUser_Unit()

DROP FUNCTION IF EXISTS gpGet_CheckingUser_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CheckingUser_Unit(
    IN inUnitId      Integer,       -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_DirectorPartner())
       AND inUnitId <> zc_DirectorPartner_UnitID()
    THEN
        RAISE EXCEPTION 'Необходимо выбрать подразделение <%> <%>.', zc_DirectorPartner_UnitID(), (SELECT ValueData FROM Object WHERE Object.Id = zc_DirectorPartner_UnitID());
    ELSEIF (vbUserId <> 3) AND EXISTS(SELECT Object.Id FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                                            LEFT JOIN Object ON Object.Id = Object_RoleUser.RoleId
                                                            AND Object.DescId = zc_Object_Role()
                                  WHERE Object_RoleUser.ID = vbUserId AND Object.ValueData = 'Франчайзи') 
    THEN
      IF NOT EXISTS(SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                     INNER JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId
                                      AND Object_Unit.IsErased = FALSE  
                 WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   AND ObjectLink_Unit_Juridical.ObjectId = inUnitId)
      THEN
        IF inUnitId = 0
        THEN
          RAISE EXCEPTION 'Не заполнено подразделение.'; 
        ELSE
          IF EXISTS(SELECT ID FROM Object WHERE Object.ID = inUnitId)
          THEN
            RAISE EXCEPTION 'Подразделение <%> запрещено к использованию.', (SELECT ValueData FROM Object WHERE Object.ID = inUnitId);  
          ELSE
            RAISE EXCEPTION 'Подразделение <%> запрещено к использованию.', inUnitId;  
          END IF;
        END IF;
      ELSE
        RETURN QUERY 
          SELECT inUnitId;                                                     
      END IF;  
    ELSE
      RETURN QUERY 
        SELECT inUnitId;                                                     
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_CheckingUser_Unit(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.06.18                         *

*/

-- тест
-- SELECT * FROM gpGet_CheckingUser_Unit(0, '183242')
