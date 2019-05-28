CREATE OR REPLACE FUNCTION gpGet_User_AreaId(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (AreaId Integer) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbAreaId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbRetailId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbAreaId := 0;
    
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
         SELECT ObjectLink_Unit_Area.ChildObjectId AS UnitId
         INTO vbAreaId
         FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId

                           INNER JOIN ObjectLink AS ObjectLink_Unit_Area
                                                 ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                AND ObjectLink_Unit_Area.ChildObjectId IS NOT NULL
         WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical() LIMIT 1;
      ELSE
         vbAreaId := -1;
      END IF;  
    ELSE
      vbAreaId := 0;
    END IF;

    RETURN QUERY 
      SELECT vbAreaId;                                                     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_User_AreaId(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 31.10.18                         *

*/

-- тест
-- SELECT * FROM gpGet_User_AreaId('4192941');
