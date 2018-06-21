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
    
    IF (vbUserId <> 3) AND EXISTS(SELECT DefaultValue.DefaultValue
                              FROM gpSelect_Object_RoleUser (inSession) as Object_RoleUser
                                   INNER JOIN DefaultValue ON DefaultValue.UserKeyId = Object_RoleUser.RoleId
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                              WHERE DefaultKeys.Key = 'zc_Object_Retail' AND  Object_RoleUser.ID = vbUserId) 
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
-- SELECT * FROM gpGet_CheckingUser_Unit(0, '3')
