-- Function: gpSelect_Object_JuridicalSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalSettings(Boolean, TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalSettings(
    IN inIsShowErased   Boolean,       -- показать удаденные Да/Нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               RetailId Integer, RetailName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, 
               isBonusVirtual Boolean,
               isPriceClose Boolean, isPriceCloseOrder Boolean,
               isSite Boolean,  isBonusClose Boolean, 
               Bonus TFloat, PriceLimit TFloat, ConditionalPercent TFloat,
               ContractId Integer, ContractName TVarChar, 
               MainJuridicalId Integer, MainJuridicalName TVarChar,
               AreaId Integer, AreaName TVarChar,
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
     tmpContractSettings AS (SELECT Object_ContractSettings.Id               AS Id
                                  , Object_ContractSettings.isErased         AS isErased
                                  , ObjectLink_MainJuridical.ChildObjectId   AS MainJuridicalId
                                  , ObjectLink_Contract.ChildObjectId        AS ContractId
                                  , ObjectLink_Area.ChildObjectId            AS AreaId
                             FROM ObjectLink AS ObjectLink_MainJuridical
                                INNER JOIN ObjectLink AS ObjectLink_Contract
                                                      ON ObjectLink_Contract.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                     AND ObjectLink_Contract.DescId = zc_ObjectLink_ContractSettings_Contract()
                                LEFT JOIN ObjectLink AS ObjectLink_Area
                                                     ON ObjectLink_Area.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                    AND ObjectLink_Area.DescId = zc_ObjectLink_ContractSettings_Area()

                                LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = ObjectLink_MainJuridical.ObjectId
                             WHERE ObjectLink_MainJuridical.DescId = zc_ObjectLink_ContractSettings_MainJuridical()
                             ) 

   , tmpMainJuridicalAreaAll AS (SELECT ObjectLink_JuridicalRetail.ObjectId      AS MainJuridicalId
                                      , ObjectLink_Unit_Area.ChildObjectId       AS AreaId
                                      , ROW_NUMBER() OVER (PARTITION BY ObjectLink_JuridicalRetail.ObjectId ORDER BY ObjectLink_Unit_Area.ChildObjectId) AS Ord
                                 FROM ObjectLink AS ObjectLink_JuridicalRetail 
                                      LEFT JOIN ObjectLink AS OL_Unit_Juridical 
                                                           ON OL_Unit_Juridical.ChildObjectId = ObjectLink_JuridicalRetail.ObjectId
                                                          AND OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                           ON ObjectLink_Unit_Area.ObjectId = OL_Unit_Juridical.ObjectId
                                                          AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                          AND  ObjectLink_Unit_Area.ChildObjectId  <> 0 
                                 WHERE ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()  
                                   AND ObjectLink_JuridicalRetail.ChildObjectId = vbObjectId
                                 )
   , tmpMainJuridicalArea AS (SELECT DISTINCT tmpMainJuridicalAreaAll.MainJuridicalId      AS MainJuridicalId
                                   , tmpMainJuridicalAreaAll.AreaId                        AS AreaId
                              FROM tmpMainJuridicalAreaAll
                              WHERE COALESCE (tmpMainJuridicalAreaAll.AreaId, 0) <> 0
                                 OR COALESCE (tmpMainJuridicalAreaAll.AreaId, 0) = 0 AND tmpMainJuridicalAreaAll.Ord = 1
                              UNION ALL
                              SELECT DISTINCT tmpMainJuridicalAreaAll.MainJuridicalId      AS MainJuridicalId
                                   , 0                                                     AS AreaId
                              FROM tmpMainJuridicalAreaAll
                              WHERE COALESCE (tmpMainJuridicalAreaAll.AreaId, 0) <> 0 AND tmpMainJuridicalAreaAll.Ord = 1
                              )

   , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
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

       SELECT 
             JuridicalSettings.JuridicalSettingsId              AS Id
           , Object_JuridicalSettings.ObjectCode                AS Code
           , Object_JuridicalSettings.ValueData                 AS Name 
           , Object_Retail.Id                                   AS RetailId
           , Object_Retail.ValueData                            AS RetailName
           , Object_Juridical.Id                                AS JuridicalId
           , Object_Juridical.ValueData                         AS JuridicalName
           , COALESCE (JuridicalSettings.isBonusVirtual, FALSE) AS isBonusVirtual
           , COALESCE (JuridicalSettings.isPriceClose, TRUE)    AS isPriceClose
           , COALESCE (JuridicalSettings.isPriceCloseOrder, TRUE)  AS isPriceCloseOrder
           , COALESCE (JuridicalSettings.isSite, FALSE)         AS isSite 
           , COALESCE (JuridicalSettings.isBonusClose, FALSE)   AS isBonusClose 
           , JuridicalSettings.Bonus
           , JuridicalSettings.PriceLimit             :: TFloat AS PriceLimit
           , COALESCE(ObjectFloat_ConditionalPercent.ValueData, 0) :: TFloat AS ConditionalPercent
           , LastPriceList_View.ContractId                      AS ContractId
           , Contract.ValueData                                 AS ContractName
           , Object_MainJuridical.Id                            AS MainJuridicalId
           , Object_MainJuridical.ValueData                     AS MainJuridicalName 
           , Object_Area.Id                                     AS AreaId
           , Object_Area.ValueData                              AS AreaName
           --, Contract.isErased
           , COALESCE (tmpContractSettings.Id, 0)                        AS ContractSettingsId
           , COALESCE (tmpContractSettings.isErased, False) ::Boolean    AS isErased

           , COALESCE (JuridicalSettings.StartDate, Null)   ::TDateTime  AS StartDate
           , COALESCE (JuridicalSettings.EndDate, Null)     ::TDateTime  AS EndDate

           , Object_User_Insert.ValueData                       AS InsertName
           , LoadPriceList.Date_Insert                          AS InsertDate
           , Object_User_Update.ValueData                       AS UpdateName
           , LoadPriceList.Date_Update                          AS UpdateDate

       FROM LastPriceList_View 
            JOIN tmpMainJuridicalArea ON (COALESCE (LastPriceList_View.AreaId, 0) = COALESCE (tmpMainJuridicalArea.AreaId, 0)
                                         )
            LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = tmpMainJuridicalArea.MainJuridicalId
                               
            JOIN Object AS Object_Juridical ON Object_Juridical.Id = LastPriceList_View.JuridicalId

            LEFT JOIN Object AS Contract ON Contract.Id = LastPriceList_View.ContractId

            LEFT JOIN Object AS Object_Area ON Object_Area.Id = LastPriceList_View.AreaId
          --  LEFT JOIN tmpArea  AS Object_Area ON Object_Area.JuridicalId = ObjectLink_JuridicalRetail.ObjectId

            LEFT JOIN tmpContractSettings ON tmpContractSettings.MainJuridicalId = Object_MainJuridical.Id
                                         AND (COALESCE (tmpContractSettings.ContractId, 0) = COALESCE (Contract.Id, 0))
                                         AND (COALESCE (tmpContractSettings.AreaId, 0) = COALESCE (Object_Area.Id, 0))
            --   
            LEFT JOIN LoadPriceList ON LoadPriceList.ContractId           = LastPriceList_View.ContractId
                                   AND LoadPriceList.JuridicalId          = LastPriceList_View.JuridicalId
                                   AND COALESCE (LoadPriceList.AreaId, 0) = LastPriceList_View.AreaId
            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = LoadPriceList.UserId_Insert
            LEFT JOIN Object AS Object_User_Update ON Object_User_Update.Id = LoadPriceList.UserId_Update  
            
            LEFT JOIN
                (SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId      AS JuridicalId
                      , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId  AS MainJuridicalId
                      , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0) AS ContractId 
                      , COALESCE (ObjectBoolean_isBonusVirtual.ValueData, FALSE)  AS isBonusVirtual
                      , COALESCE (ObjectBoolean_isPriceClose.ValueData, FALSE)    AS isPriceClose 
                      , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)  AS isPriceCloseOrder
                      , COALESCE (ObjectBoolean_Site.ValueData, FALSE)            AS isSite
                      , COALESCE (ObjectBoolean_isBonusClose.ValueData, FALSE)    AS isBonusClose
                      --, ObjectFloat_Bonus.ValueData                               AS Bonus 
                      --, COALESCE (ObjectFloat_PriceLimit.ValueData,0) :: TFloat   AS PriceLimit  
                      , tmpJuridicalSettingsItem.Bonus
                      , tmpJuridicalSettingsItem.PriceLimit
                      , ObjectLink_JuridicalSettings_Retail.ObjectId              AS JuridicalSettingsId
                      , ObjectLink_JuridicalSettings_Retail.ChildObjectId         AS RetailId

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

                      LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceCloseOrder
                                              ON ObjectBoolean_isPriceCloseOrder.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                             AND ObjectBoolean_isPriceCloseOrder.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder()

                      LEFT JOIN ObjectBoolean AS ObjectBoolean_isBonusClose
                                              ON ObjectBoolean_isBonusClose.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                             AND ObjectBoolean_isBonusClose.DescId = zc_ObjectBoolean_JuridicalSettings_isBonusClose()

                      /*LEFT JOIN ObjectFloat AS ObjectFloat_Bonus 
                                            ON ObjectFloat_Bonus.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                           AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()
     
                      LEFT JOIN ObjectFloat AS ObjectFloat_PriceLimit 
                                            ON ObjectFloat_PriceLimit.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                           AND ObjectFloat_PriceLimit.DescId = zc_ObjectFloat_JuridicalSettings_PriceLimit()
                      */
               
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_isBonusVirtual
                                              ON ObjectBoolean_isBonusVirtual.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                             AND ObjectBoolean_isBonusVirtual.DescId = zc_ObjectBoolean_JuridicalSettings_BonusVirtual()
     
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                              ON ObjectBoolean_Site.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                             AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_JuridicalSettings_Site()
     
                      LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                                           ON ObjectDate_StartDate.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                          AND ObjectDate_StartDate.DescId = zc_ObjectDate_Contract_Start()
                      LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                                           ON ObjectDate_EndDate.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                          AND ObjectDate_EndDate.DescId = zc_ObjectDate_Contract_End()

                      LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                                        AND COALESCE (ObjectBoolean_isBonusClose.ValueData, FALSE) = FALSE

                 WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = vbObjectId) 

                 AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId
                                     AND JuridicalSettings.MainJuridicalId = Object_MainJuridical.Id --ObjectLink_JuridicalRetail.ObjectId
                                     AND JuridicalSettings.ContractId = COALESCE (LastPriceList_View.ContractId, 0)

            LEFT JOIN Object AS Object_JuridicalSettings ON Object_JuridicalSettings.Id = JuridicalSettings.JuridicalSettingsId
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = JuridicalSettings.RetailId

            LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                  ON ObjectFloat_ConditionalPercent.ObjectId = LastPriceList_View.JuridicalId
                                 AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()

       WHERE (COALESCE (tmpContractSettings.isErased, False) = False OR inIsShowErased = TRUE)
       ORDER BY Object_MainJuridical.ValueData 
;  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.19         * isBonusClose
 14.01.19         *
 18.10.18         * isPriceCloseOrder
 10.05.18         *
 21.03.18         *
 15.02.18         *
 17.10.17         * add Area
 09.11.16         * add inIsShowErased, Insert, Update
 11.02.16         * add PriceLimit Ограничение "Цена до"
 17.02.15                         *
 21.01.15                         *
 13.10.14                         *

*/
-- тест 
-- SELECT * FROM gpSelect_Object_JuridicalSettings22 (True,'2')
-- select * from gpSelect_Object_JuridicalSettings(inIsShowErased := 'False' ,  inSession := '3')

select * from gpSelect_Object_JuridicalSettings(inIsShowErased := 'False' ,  inSession := '3');