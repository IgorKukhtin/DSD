-- Function: lpCheckingUser_Retail()

DROP FUNCTION IF EXISTS lpCheckingUser_Retail(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION lpCheckingUser_Retail(
    IN inUnitId      Integer,       -- Подразделение
    IN inRetailId    Integer  ,  -- ссылка на торг.сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID	 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    IF (vbUserId <> 3) AND EXISTS(SELECT Object.Id FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                                            LEFT JOIN Object ON Object.Id = Object_RoleUser.RoleId
                                                            AND Object.DescId = zc_Object_Role()
                                  WHERE Object_RoleUser.ID = vbUserId AND Object.ValueData = 'Франчайзи') 
    THEN
      IF COALESCE (inUnitId, 0) = 0 AND COALESCE (inRetailId, 0) = 0
      THEN
        RAISE EXCEPTION 'Не заполнено подразделение или торговая сеть.'; 
      END IF;
        
      IF COALESCE (inUnitId, 0) <> 0 AND NOT EXISTS(SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
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
        IF EXISTS(SELECT ID FROM Object WHERE Object.ID = inUnitId)
        THEN
          RAISE EXCEPTION 'Подразделение <%> запрещено к использованию.', (SELECT ValueData FROM Object WHERE Object.ID = inUnitId);  
        ELSE
          RAISE EXCEPTION 'Подразделение <%> запрещено к использованию.', inUnitId;  
        END IF;
      END IF;

      IF COALESCE (inRetailId, 0) <> 0 AND COALESCE (inRetailId, 0) <> vbObjectId
      THEN
        IF EXISTS(SELECT ID FROM Object WHERE Object.ID = inRetailId)
        THEN
          RAISE EXCEPTION 'Торговая сеть <%> запрещено к использованию.', (SELECT ValueData FROM Object WHERE Object.ID = inRetailId);  
        ELSE
          RAISE EXCEPTION 'Торговая сеть <%> запрещено к использованию.', inRetailId;  
        END IF;
      END IF;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckingUser_Retail(integer, integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.06.18                         *

*/

-- тест
-- SELECT * FROM lpCheckingUser_Retail(0, 0, '183242')