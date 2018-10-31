CREATE OR REPLACE FUNCTION gpGet_User_JuridicalId(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbRetailId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbJuridicalId := 0;
    
    IF (vbUserId <> 3) AND EXISTS(SELECT Object.Id FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                                            LEFT JOIN Object ON Object.Id = Object_RoleUser.RoleId
                                                            AND Object.DescId = zc_Object_Role()
                                  WHERE Object_RoleUser.ID = vbUserId AND Object.ValueData = 'Франчайзи') 
    THEN
      IF EXISTS(SELECT ObjectLink_Unit_Juridical.ChildObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical())
      THEN
         SELECT ObjectLink_Unit_Juridical.ChildObjectId AS UnitId
         INTO vbJuridicalId
         FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
         WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical() LIMIT 1;
      ELSE
         vbJuridicalId := -1;
      END IF;  
    ELSE
      vbJuridicalId := 0;
    END IF;

    RETURN QUERY 
      SELECT vbJuridicalId;                                                     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_User_JuridicalId(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.07.18                         *

*/

-- тест
-- SELECT * FROM gpGet_User_JuridicalId('5122350');
