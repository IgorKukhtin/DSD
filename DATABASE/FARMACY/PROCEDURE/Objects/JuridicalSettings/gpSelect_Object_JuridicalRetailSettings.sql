-- Function: gpSelect_Object_JuridicalRetailSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalRetailSettings(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalRetailSettings(
    IN inMainJuridicalId Integer,       -- Юр. лицо
    IN inRetailId        Integer,       -- Сеть
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (MainJuridicalId Integer,
              JuridicalId Integer,
              ContractId Integer,
              AreaId Integer
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalSettings());
   vbUserId:= inSession;

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

   , tmpMainJuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalRetail.ObjectId      AS MainJuridicalId
                                   , ObjectLink_Unit_Area.ChildObjectId                AS AreaId
                              FROM ObjectLink AS ObjectLink_JuridicalRetail
                                   LEFT JOIN ObjectLink AS OL_Unit_Juridical
                                                        ON OL_Unit_Juridical.ChildObjectId = ObjectLink_JuridicalRetail.ObjectId
                                                       AND OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                        ON ObjectLink_Unit_Area.ObjectId = OL_Unit_Juridical.ObjectId
                                                       AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                      AND  ObjectLink_Unit_Area.ChildObjectId  <> 0
                              WHERE ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()
                                AND ObjectLink_JuridicalRetail.ChildObjectId = inRetailId
                              )

       SELECT DISTINCT
             tmpMainJuridicalArea.MainJuridicalId               AS MainJuridicalId
           , LastPriceList_View.JuridicalId                     AS JuridicalId
           , LastPriceList_View.ContractId                      AS ContractId
           , LastPriceList_View.AreaId                          AS AreaId
       FROM LoadPriceList AS LastPriceList_View
            JOIN tmpMainJuridicalArea ON (LastPriceList_View.AreaId = COALESCE (tmpMainJuridicalArea.AreaId, 0)
                                       OR COALESCE (LastPriceList_View.AreaId, 0)  = 0
                                          )


            LEFT JOIN tmpContractSettings ON tmpContractSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                         AND tmpContractSettings.ContractId = LastPriceList_View.ContractId
                                         AND (COALESCE (tmpContractSettings.AreaId, 0) = COALESCE (LastPriceList_View.AreaId, 0))

            LEFT JOIN
                (SELECT ObjectLink_JuridicalSettings_Juridical.ChildObjectId                AS JuridicalId
                      , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId            AS MainJuridicalId
                      , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0)   AS ContractId
                      , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)         AS isPriceCloseOrder
                      , ObjectLink_JuridicalSettings_Retail.ObjectId                        AS JuridicalSettingsId
                      , ObjectLink_JuridicalSettings_Retail.ChildObjectId                   AS RetailId
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

                      LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceCloseOrder
                                              ON ObjectBoolean_isPriceCloseOrder.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                             AND ObjectBoolean_isPriceCloseOrder.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder()

                 WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                 AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = inRetailId) AS JuridicalSettings
                                                                                     ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId
                                                                                    AND JuridicalSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                                                                    AND JuridicalSettings.ContractId = COALESCE (LastPriceList_View.ContractId, 0)

       WHERE COALESCE (tmpContractSettings.isErased, False) = False
         AND COALESCE (JuridicalSettings.isPriceCloseOrder, TRUE) = False
         AND (tmpMainJuridicalArea.MainJuridicalId = inMainJuridicalId OR  inMainJuridicalId = 0)
;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.05.20                                                       *
*/
-- тест
-- select * from gpSelect_Object_JuridicalRetailSettings(inMainJuridicalId := 3457711, inRetailId := 4,  inSession := '3')
