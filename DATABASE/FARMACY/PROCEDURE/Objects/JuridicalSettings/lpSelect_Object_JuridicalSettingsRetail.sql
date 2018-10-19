-- Function: gpSelect_Object_PriceGroupSettings()

DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsPriceListRetail(Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsRetail(Integer);
                        
CREATE OR REPLACE FUNCTION lpSelect_Object_JuridicalSettingsRetail(
    IN inRetailId   Integer       -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, MainJuridicalId Integer, ContractId Integer
             , isPriceClose boolean
             , isPriceCloseOrder boolean
             , isSite Boolean
             , Bonus TFloat, PriceLimit TFloat
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceGroupSettings());

   RETURN QUERY 
          SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId              AS JuridicalId
               , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId          AS MainJuridicalId
               , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId
               , COALESCE (ObjectBoolean_isPriceClose.ValueData, FALSE)            AS isPriceClose 
               , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)       AS isPriceCloseOrder
               , COALESCE (ObjectBoolean_Site.ValueData, FALSE)                    AS isSite
               , ObjectFloat_Bonus.ValueData                                       AS Bonus
               , COALESCE (ObjectFloat_PriceLimit.ValueData,0) :: TFloat           AS PriceLimit
            FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical 
                                 ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()                      
                                AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_MainJuridical 
                                 ON ObjectLink_JuridicalSettings_MainJuridical.DescId = zc_ObjectLink_JuridicalSettings_MainJuridical()                      
                                AND ObjectLink_JuridicalSettings_MainJuridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 LEFT JOIN ObjectLink AS ObjectLink_JuridicalSettings_Contract 
                                      ON ObjectLink_JuridicalSettings_Contract.DescId = zc_ObjectLink_JuridicalSettings_Contract()                      
                                     AND ObjectLink_JuridicalSettings_Contract.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceClose
                                         ON ObjectBoolean_isPriceClose.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                        AND ObjectBoolean_isPriceClose.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceClose()

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceCloseOrder
                                         ON ObjectBoolean_isPriceCloseOrder.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                        AND ObjectBoolean_isPriceCloseOrder.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder()

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                         ON ObjectBoolean_Site.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                        AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_JuridicalSettings_Site()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Bonus 
                                       ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

                 LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit 
                                       ON ObjectFloat_PriceLimit.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettings_PriceLimit()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = inRetailId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_JuridicalSettingsRetail(Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.18         * isPriceCloseOrder
 17.02.15                         *
 21.01.15                         *
 13.10.14                         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (4) order by 1, 3
