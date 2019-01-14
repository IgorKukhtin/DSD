-- Function: gpSelect_Object_JuridicalSettingsItem()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettingsItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalSettingsItem (
    IN inJuridicalSettingsId Integer, 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalSettingsId Integer
             , Bonus TFloat
             , PriceLimit_min TFloat
             , PriceLimit TFloat
             , isErased Boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalSettingsItem());

   RETURN QUERY 
   WITH
   tmpJuridicalSettingsItem AS (SELECT 
                                      Object_JuridicalSettingsItem.Id            AS Id
                                    , ObjectLink_JuridicalSettings.ChildObjectId AS JuridicalSettingsId
                                    , ObjectFloat_Bonus.ValueData                AS Bonus
                                    , ObjectFloat_PriceLimit.ValueData           AS PriceLimit
                                    , Object_JuridicalSettingsItem.isErased      AS isErased
                                    
                                FROM Object AS Object_JuridicalSettingsItem
                                    INNER JOIN ObjectLink AS ObjectLink_JuridicalSettings
                                                          ON ObjectLink_JuridicalSettings.ObjectId = Object_JuridicalSettingsItem.Id
                                                         AND ObjectLink_JuridicalSettings.DescId = zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings()
                                                         AND (ObjectLink_JuridicalSettings.ChildObjectId = inJuridicalSettingsId OR inJuridicalSettingsId = 0)
                         
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Bonus
                                                          ON ObjectFloat_Bonus.ObjectId = Object_JuridicalSettingsItem.Id
                                                         AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettingsItem_Bonus()
                         
                                    LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit
                                                          ON ObjectFloat_PriceLimit.ObjectId = Object_JuridicalSettingsItem.Id
                                                         AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettingsItem_PriceLimit()
                         
                                WHERE Object_JuridicalSettingsItem.DescId = zc_Object_JuridicalSettingsItem()
                                )
       SELECT DD.Id
            , DD.JuridicalSettingsId
            , DD.Bonus 
            , COALESCE ((SELECT max(FF.PriceLimit) FROM tmpJuridicalSettingsItem AS FF WHERE FF.PriceLimit < DD.PriceLimit AND FF.JuridicalSettingsId = DD.JuridicalSettingsId), 0) + 0.01  AS PriceLimit_min
            , DD.PriceLimit
       FROM tmpJuridicalSettingsItem AS DD
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.19         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalSettingsItem (0, '2')
