-- Function: gpSelectMobile_Object_PriceList (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceList (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceList (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- Код
             , ValueData    TVarChar -- Название
             , PriceWithVAT Boolean  -- Цена с НДС (да/нет)
             , VATPercent   TFloat   -- % НДС
             , isErased     Boolean  -- Удаленный ли элемент
             , isSync       Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- !!! ВРЕМЕННО будем выгружать все
      inSyncDateIn:= zc_DateStart();

      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListId, MAX(ObjectProtocol.OperDate) AS MaxOperDate        
                                  FROM ObjectProtocol                                                                               
                                       JOIN Object AS Object_PriceList                                                              
                                                   ON Object_PriceList.Id = ObjectProtocol.ObjectId                                 
                                                  AND Object_PriceList.DescId = zc_Object_PriceList()                               
                                  WHERE inSyncDateIn > zc_DateStart()
                                    AND ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId                                                                  
                                 )
                  -- определяем список контрагентов+юр.лиц, что доступны торговому агенту
                , tmpPartner AS (SELECT OP.Id
                                      , OP.JuridicalId
                                 FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP
                                )
                , tmpPriceList AS (SELECT DISTINCT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                                                        --, ObjectLink_Contract_PriceList.ChildObjectId
                                                          , ObjectLink_Juridical_PriceList.ChildObjectId
                                                          , zc_PriceList_Basis()) AS PriceListId
                                                 , COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                                                          , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                                          , zc_PriceList_Basis() /*zc_PriceList_BasisPrior()*/) AS PriceListPriorId
                                   FROM tmpPartner AS OP
                                        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                                             ON ObjectLink_Partner_PriceList.ObjectId = OP.Id
                                                            AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                        LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                                             ON ObjectLink_Partner_PriceListPrior.ObjectId = OP.Id
                                                            AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                             ON ObjectLink_Contract_Juridical.ChildObjectId = OP.JuridicalId
                                                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                      /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                             ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                            AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()*/
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                             ON ObjectLink_Juridical_PriceList.ObjectId = OP.JuridicalId
                                                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                                             ON ObjectLink_Juridical_PriceListPrior.ObjectId = OP.JuridicalId
                                                            AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
                                  UNION                                    
                                   SELECT OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                        , OL_ContractPriceList_PriceList.ChildObjectId AS PriceListPriorId
                                   FROM tmpPartner
                                        JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ChildObjectId = tmpPartner.JuridicalId
                                                       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                                        -- убрали Удаленные
                                        JOIN Object AS Object_Contract
                                                    ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                   AND Object_Contract.isErased = FALSE
                                        INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                              ON OL_ContractPriceList_Contract.ChildObjectId = Object_Contract.Id
                                                             AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                        INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                     AND Object_ContractPriceList.isErased = FALSE
                                        INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                              ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                             AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                        INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                              ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                             AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                        INNER JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                              ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                             AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                                             AND OL_ContractPriceList_PriceList.ChildObjectId > 0
                                   WHERE CURRENT_DATE + INTERVAL '1 DAY' BETWEEN ObjectDate_StartDate.ValueData AND ObjectDate_EndDate.ValueData
                                  ) 
                , tmpFilter AS (SELECT tmpProtocol.PriceListId FROM tmpProtocol
                                UNION
                                SELECT DISTINCT tmpPriceList.PriceListId FROM tmpPriceList WHERE inSyncDateIn <= zc_DateStart()
                                UNION
                                SELECT DISTINCT tmpPriceList.PriceListPriorId AS PriceListId FROM tmpPriceList WHERE inSyncDateIn <= zc_DateStart()
                               )
             SELECT Object_PriceList.Id                                                                                             
                  , Object_PriceList.ObjectCode                                                                                     
                  , Object_PriceList.ValueData                                                                                      
                  , ObjectBoolean_PriceList_PriceWithVAT.ValueData AS PriceWithVAT                                                  
                  , ObjectFloat_PriceList_VATPercent.ValueData AS VATPercent                                                        
                  , Object_PriceList.isErased                                                                                       
                  , EXISTS(SELECT 1 FROM tmpPriceList WHERE Object_PriceList.Id IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId))
                    AND (Object_PriceList.isErased = FALSE) AS isSync
             FROM Object AS Object_PriceList                                                                                        
                  JOIN tmpFilter ON tmpFilter.PriceListId = Object_PriceList.Id
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT                                                   
                                          ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id                    
                                         AND ObjectBoolean_PriceList_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                  LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent                                                         
                                        ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id                          
                                       AND ObjectFloat_PriceList_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()          
             WHERE Object_PriceList.DescId = zc_Object_PriceList()
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
             ;

      END IF; 

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_PriceList(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
