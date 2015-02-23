-- Function: gpSelect_Object_JuridicalSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettings(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, JuridicalId Integer, JuridicalName TVarChar, 
               isPriceClose Boolean, Bonus TFloat, 
               ContractId Integer, ContractName TVarChar, 
               MainJuridicalId Integer, MainJuridicalName TVarChar, isErased boolean) AS
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
           , COALESCE(JuridicalSettings.isPriceClose, FALSE)
           , JuridicalSettings.Bonus
           , LastPriceList_View.ContractId AS ContractId
           , Contract.ValueData AS ContractName
           , ObjectLink_JuridicalRetail.ObjectId AS MainJuridicalId
           , Object_MainJuridical.ValueData AS MainJuridicalName 
           , Object_Juridical.isErased
       FROM LastPriceList_View 
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalRetail 
                                ON ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()    
                               AND ObjectLink_JuridicalRetail.ChildObjectId = vbObjectId
            LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_JuridicalRetail.ObjectId
                               
           JOIN Object AS Object_Juridical ON Object_Juridical.Id = LastPriceList_View.JuridicalId
           LEFT JOIN Object AS Contract ON Contract.Id = LastPriceList_View.ContractId
                               
           LEFT JOIN
                (SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId     AS JuridicalId
                      , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId AS MainJuridicalId
                      , COALESCE(ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId 
                      , COALESCE(ObjectBoolean_isPriceClose.ValueData, false) AS isPriceClose 
                      , ObjectFloat_Bonus.ValueData AS Bonus 
                      , ObjectLink_JuridicalSettings_Retail.ObjectId AS JuridicalSettingsId
                 FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical 
                                 ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()                      
                                AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 JOIN ObjectLink AS ObjectLink_JuridicalSettings_MainJuridical 
                                 ON ObjectLink_JuridicalSettings_MainJuridical.DescId = zc_ObjectLink_JuridicalSettings_MainJuridical()                      
                                AND ObjectLink_JuridicalSettings_MainJuridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId 

                 LEFT JOIN ObjectLink AS ObjectLink_JuridicalSettings_Contract 
                                      ON ObjectLink_JuridicalSettings_Contract.DescId = zc_ObjectLink_JuridicalSettings_Contract()                      
                                     AND ObjectLink_JuridicalSettings_Contract.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId 

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceClose
                                  ON ObjectBoolean_isPriceClose.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                 AND ObjectBoolean_isPriceClose.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceClose()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Bonus 
                                       ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = vbObjectId) 

                 AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId
                                     AND JuridicalSettings.MainJuridicalId = ObjectLink_JuridicalRetail.ObjectId
                                     AND JuridicalSettings.ContractId = COALESCE(LastPriceList_View.ContractId, 0);  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_JuridicalSettings(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.15                         *
 21.01.15                         *
 13.10.14                         *

*/
-- тест SELECT * FROM gpSelect_Object_JuridicalSettings ('2')