-- Function: gpSelect_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsPriceListRetail(Integer);
                        
CREATE OR REPLACE FUNCTION lpSelect_Object_JuridicalSettingsPriceListRetail(
    IN inRetailId   Integer       -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, ContractId Integer, isPriceClose boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());

   RETURN QUERY 
          SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId AS JuridicalId
               , COALESCE(ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId 
               , COALESCE(ObjectBoolean_isPriceClose.ValueData, false) AS isPriceClose 
                 FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical 
                                 ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()                      
                                AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 LEFT JOIN ObjectLink AS ObjectLink_JuridicalSettings_Contract 
                                      ON ObjectLink_JuridicalSettings_Contract.DescId = zc_ObjectLink_JuridicalSettings_Contract()                      
                                     AND ObjectLink_JuridicalSettings_Contract.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 LEFt JOIN ObjectBoolean AS ObjectBoolean_isPriceClose
                                  ON ObjectBoolean_isPriceClose.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                 AND ObjectBoolean_isPriceClose.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceClose()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = inRetailId
                 AND ObjectBoolean_isPriceClose.ValueData = true ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_JuridicalSettingsPriceListRetail(Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval ('240')