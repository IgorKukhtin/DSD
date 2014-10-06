-- Function: gpSelect_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsRetail(Integer);
                        
CREATE OR REPLACE FUNCTION lpSelect_Object_JuridicalSettingsRetail(
    IN inRetailId   Integer       -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, Bonus TFloat) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());

   RETURN QUERY 
          SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId AS JuridicalId
               , ObjectFloat_Bonus.ValueData AS Bonus 
                 FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical 
                                 ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()                      
                                AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 JOIN ObjectFloat AS ObjectFloat_Bonus 
                                  ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                 AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = inRetailId
                 ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_JuridicalSettingsRetail(Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.10.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval ('240')