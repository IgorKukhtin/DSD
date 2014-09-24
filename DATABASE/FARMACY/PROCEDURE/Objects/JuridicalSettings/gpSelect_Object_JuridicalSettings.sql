-- Function: gpSelect_Object_JuridicalSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettings(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, JuridicalId Integer, JuridicalName TVarChar, Bonus TFloat, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
       SELECT 
             JuridicalSettings.JuridicalSettingsId
           , Object_Juridical.Id
           , Object_Juridical.ValueData
           , JuridicalSettings.Bonus
           , Object_Juridical.isErased
       FROM Object AS Object_Juridical 
           LEFT JOIN
                (SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId AS JuridicalId
                      , ObjectFloat_Bonus.ValueData AS Bonus 
                      , ObjectLink_JuridicalSettings_Retail.ObjectId AS JuridicalSettingsId
                 FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical 
                                 ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()                      
                                AND ObjectLink_JuridicalSettings_Retail.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId

                 JOIN ObjectFloat AS ObjectFloat_Bonus 
                                  ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                 AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = vbObjectId) 

                 AS JuridicalSettings ON JuridicalSettings.JuridicalId = Object_Juridical.Id
       WHERE Object_Juridical.descid = zc_object_juridical();  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_JuridicalSettings(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalSettings ('2')