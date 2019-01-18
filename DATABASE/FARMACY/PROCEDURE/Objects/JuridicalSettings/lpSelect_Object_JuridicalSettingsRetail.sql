-- Function: gpSelect_Object_PriceGroupSettings()

--DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsPriceListRetail(Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_JuridicalSettingsRetail(Integer);
                        
CREATE OR REPLACE FUNCTION lpSelect_Object_JuridicalSettingsRetail(
    IN inRetailId   Integer       -- сессия пользователя
)
RETURNS TABLE (JuridicalSettingsId Integer
             , JuridicalId Integer, MainJuridicalId Integer, ContractId Integer
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
   WITH
     tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                       , tmp.Bonus
                                       , tmp.PriceLimit
                                  FROM (SELECT ObjectLink_JuridicalSettings.ChildObjectId AS JuridicalSettingsId
                                             , ObjectFloat_Bonus.ValueData                AS Bonus
                                             , ObjectFloat_PriceLimit.ValueData           AS PriceLimit
                                             , ROW_NUMBER() OVER (PARTITION BY ObjectLink_JuridicalSettings.ChildObjectId ORDER BY ObjectFloat_PriceLimit.ValueData) AS Ord
                                             
                                        FROM Object AS Object_JuridicalSettingsItem
                                             INNER JOIN ObjectLink AS ObjectLink_JuridicalSettings
                                                                   ON ObjectLink_JuridicalSettings.ObjectId = Object_JuridicalSettingsItem.Id
                                                                  AND ObjectLink_JuridicalSettings.DescId = zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings()
                                  
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Bonus
                                                                   ON ObjectFloat_Bonus.ObjectId = Object_JuridicalSettingsItem.Id
                                                                  AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettingsItem_Bonus()
                                  
                                             LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit
                                                                   ON ObjectFloat_PriceLimit.ObjectId = Object_JuridicalSettingsItem.Id
                                                                  AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettingsItem_PriceLimit()
                                  
                                        WHERE Object_JuridicalSettingsItem.DescId = zc_Object_JuridicalSettingsItem()
                                          AND Object_JuridicalSettingsItem.isErased = FALSE
                                         ) AS tmp
                                  WHERE tmp.Ord = 1 
                                  )

          SELECT ObjectLink_JuridicalSettings_Retail.ObjectId                      AS JuridicalSettingsId
               , ObjectLink_JuridicalSettings_Juridical.ChildObjectId              AS JuridicalId
               , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId          AS MainJuridicalId
               , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId
               , COALESCE (ObjectBoolean_isPriceClose.ValueData, FALSE)            AS isPriceClose 
               , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)       AS isPriceCloseOrder
               , COALESCE (ObjectBoolean_Site.ValueData, FALSE)                    AS isSite
               , tmpJuridicalSettingsItem.Bonus
               , tmpJuridicalSettingsItem.PriceLimit
               --, ObjectFloat_Bonus.ValueData                                       AS Bonus
               --, COALESCE (ObjectFloat_PriceLimit.ValueData,0) :: TFloat           AS PriceLimit
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

                 LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = ObjectLink_JuridicalSettings_Retail.ObjectId

/*                 LEFT JOIN ObjectFloat AS ObjectFloat_Bonus 
                                       ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

                 LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit 
                                       ON ObjectFloat_PriceLimit.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettings_PriceLimit()
*/
               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = inRetailId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpSelect_Object_JuridicalSettingsRetail(Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.19         * add JuridicalSettingsId
 19.10.18         * isPriceCloseOrder
 17.02.15                         *
 21.01.15                         *
 13.10.14                         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (4) order by 1, 3
