-- Function: gpSelect_Object_JuridicalSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettings(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettings(Boolean, TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalSettings(
    IN inIsShowErased   Boolean,       -- показать удаденные Да/Нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, JuridicalId Integer, JuridicalName TVarChar, 
               isPriceClose Boolean, isSite Boolean,
               Bonus TFloat, PriceLimit TFloat, ConditionalPercent TFloat,
               ContractId Integer, ContractName TVarChar, 
               MainJuridicalId Integer, MainJuridicalName TVarChar,
               ContractSettingsId Integer,  isErased boolean,
               StartDate TDateTime, EndDate TDateTime,
               InsertName TVarChar, InsertDate TDateTime,
               UpdateName TVarChar, UpdateDate TDateTime
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
     WITH 
     tmpContractSettings AS (SELECT Object_ContractSettings.Id
                                  , Object_ContractSettings.isErased
                                  , ObjectLink_Retail.ChildObjectId   AS RetailId
                                  , ObjectLink_Contract.ChildObjectId AS ContractId
                             FROM ObjectLink AS ObjectLink_Retail
                                INNER JOIN ObjectLink AS ObjectLink_Contract
                                                      ON ObjectLink_Contract.ObjectId = ObjectLink_Retail.ObjectId
                                                     AND ObjectLink_Contract.DescId = zc_ObjectLink_ContractSettings_Contract()
                                LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = ObjectLink_Retail.ObjectId
                             WHERE ObjectLink_Retail.DescId = zc_ObjectLink_ContractSettings_Retail()
                               AND ObjectLink_Retail.ChildObjectId = vbObjectId
                             ) 

       SELECT 
             JuridicalSettings.JuridicalSettingsId
           , Object_JuridicalSettings.ValueData AS Name 
           , Object_Juridical.Id
           , Object_Juridical.ValueData
           , COALESCE(JuridicalSettings.isPriceClose, TRUE)  AS isPriceClose
           , COALESCE(JuridicalSettings.isSite, FALSE)       AS isSite 
           , JuridicalSettings.Bonus
           , JuridicalSettings.PriceLimit :: TFloat AS PriceLimit
           , COALESCE(ObjectFloat_ConditionalPercent.ValueData, 0) :: TFloat AS ConditionalPercent
           , LastPriceList_View.ContractId AS ContractId
           , Contract.ValueData AS ContractName
           , ObjectLink_JuridicalRetail.ObjectId AS MainJuridicalId
           , Object_MainJuridical.ValueData AS MainJuridicalName 
           --, Contract.isErased
           , COALESCE (tmpContractSettings.Id, 0)                        AS ContractSettingsId
           , COALESCE (tmpContractSettings.isErased, False) ::Boolean    AS isErased

           , COALESCE (JuridicalSettings.StartDate, Null)   ::TDateTime  AS StartDate
           , COALESCE (JuridicalSettings.EndDate, Null)     ::TDateTime  AS EndDate

           , Object_User_Insert.ValueData   AS InsertName
           , LoadPriceList.Date_Insert      AS InsertDate
           , Object_User_Update.ValueData   AS UpdateName
           , LoadPriceList.Date_Update      AS UpdateDate

       FROM LastPriceList_View 
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalRetail 
                                ON ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()    
                               AND ObjectLink_JuridicalRetail.ChildObjectId = vbObjectId
            LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_JuridicalRetail.ObjectId
                               
            JOIN Object AS Object_Juridical ON Object_Juridical.Id = LastPriceList_View.JuridicalId

            LEFT JOIN Object AS Contract ON Contract.Id = LastPriceList_View.ContractId
                       --                 AND (Contract.isErased = False OR inIsShowErased = TRUE)
            LEFT JOIN tmpContractSettings ON tmpContractSettings.RetailId = ObjectLink_JuridicalRetail.ChildObjectId 
                                         AND tmpContractSettings.ContractId = Contract.Id
            --   
            LEFT JOIN LoadPriceList ON LoadPriceList.ContractId = LastPriceList_View.ContractId
                                   AND LoadPriceList.JuridicalId = LastPriceList_View.JuridicalId
            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = LoadPriceList.UserId_Insert
            LEFT JOIN Object AS Object_User_Update ON Object_User_Update.Id = LoadPriceList.UserId_Update  
            
            LEFT JOIN
                (SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId     AS JuridicalId
                      , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId AS MainJuridicalId
                      , COALESCE(ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId 
                      , COALESCE(ObjectBoolean_isPriceClose.ValueData, FALSE) AS isPriceClose 
                      , COALESCE(ObjectBoolean_Site.ValueData, FALSE)         AS isSite
                      , ObjectFloat_Bonus.ValueData AS Bonus 
                      , COALESCE(ObjectFloat_PriceLimit.ValueData,0) :: TFloat   AS PriceLimit  
                      , ObjectLink_JuridicalSettings_Retail.ObjectId AS JuridicalSettingsId

                      , ObjectDate_StartDate.ValueData AS StartDate
                      , ObjectDate_EndDate.ValueData   AS EndDate

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

                 LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit 
                                       ON ObjectFloat_PriceLimit.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                      AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettings_PriceLimit()
          
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                         ON ObjectBoolean_Site.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                        AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_JuridicalSettings_Site()

                 LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                                      ON ObjectDate_StartDate.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                     AND ObjectDate_StartDate.DescId = zc_ObjectDate_Contract_Start()
                 LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                                      ON ObjectDate_EndDate.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                     AND ObjectDate_EndDate.DescId = zc_ObjectDate_Contract_End()

               WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = vbObjectId) 

                 AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId
                                     AND JuridicalSettings.MainJuridicalId = ObjectLink_JuridicalRetail.ObjectId
                                     AND JuridicalSettings.ContractId = COALESCE(LastPriceList_View.ContractId, 0)

                LEFT JOIN Object AS Object_JuridicalSettings ON Object_JuridicalSettings.Id = JuridicalSettings.JuridicalSettingsId

                LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                      ON ObjectFloat_ConditionalPercent.ObjectId = LastPriceList_View.JuridicalId
                                     AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()

           WHERE (COALESCE (tmpContractSettings.isErased, False) = False OR inIsShowErased = TRUE)
--and Contract.Id =183257
;  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_JuridicalSettings(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.16         * add inIsShowErased, Insert, Update
 11.02.16         * add PriceLimit Ограничение "Цена до"
 17.02.15                         *
 21.01.15                         *
 13.10.14                         *

*/
-- тест 
-- SELECT * FROM gpSelect_Object_JuridicalSettings (True,'2')

