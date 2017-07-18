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
           CREATE TEMP TABLE tmpPriceList ON COMMIT DROP
           AS (SELECT DISTINCT COALESCE(ObjectLink_Partner_PriceList.ChildObjectId
                                      , ObjectLink_Contract_PriceList.ChildObjectId
                                      , ObjectLink_Juridical_PriceList.ChildObjectId
                                      , zc_PriceList_Basis()) AS PriceListId
                             , COALESCE(ObjectLink_Partner_PriceListPrior.ChildObjectId
                                      , ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                      , zc_PriceList_BasisPrior()) AS PriceListPriorId
               FROM lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                         ON ObjectLink_Partner_PriceList.ObjectId = OP.Id
                                        AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                         ON ObjectLink_Partner_PriceListPrior.ObjectId = OP.Id
                                        AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = OP.JuridicalId
                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                    LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                         ON ObjectLink_Contract_PriceList.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                        AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = OP.JuridicalId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                         ON ObjectLink_Juridical_PriceListPrior.ObjectId = OP.JuridicalId
                                        AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
              );
                
           -- Убрал, есть ошибка у одного торгового - пусть выгружется ВСЕ
           IF 1 = 0 -- inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListId, MAX(ObjectProtocol.OperDate) AS MaxOperDate        
                                       FROM ObjectProtocol                                                                               
                                            JOIN Object AS Object_PriceList                                                              
                                                        ON Object_PriceList.Id = ObjectProtocol.ObjectId                                 
                                                       AND Object_PriceList.DescId = zc_Object_PriceList()                               
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId                                                                  
                                      )
                  SELECT Object_PriceList.Id                                                                                             
                       , Object_PriceList.ObjectCode                                                                                     
                       , Object_PriceList.ValueData                                                                                      
                       , ObjectBoolean_PriceList_PriceWithVAT.ValueData AS PriceWithVAT                                                  
                       , ObjectFloat_PriceList_VATPercent.ValueData AS VATPercent                                                        
                       , Object_PriceList.isErased                                                                                       
                       , EXISTS(SELECT 1 FROM tmpPriceList WHERE Object_PriceList.Id IN (tmpPriceList.PriceListId, tmpPriceList.PriceListPriorId)) AS isSync
                  FROM Object AS Object_PriceList                                                                                        
                       JOIN tmpProtocol ON tmpProtocol.PriceListId = Object_PriceList.Id
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT                                                   
                                               ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id                    
                                              AND ObjectBoolean_PriceList_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                       LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent                                                         
                                             ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id                          
                                            AND ObjectFloat_PriceList_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()          
                  WHERE Object_PriceList.DescId = zc_Object_PriceList();
           ELSE
                RETURN QUERY
                  SELECT Object_PriceList.Id                                                                                             
                       , Object_PriceList.ObjectCode                                                                                     
                       , Object_PriceList.ValueData                                                                                      
                       , ObjectBoolean_PriceList_PriceWithVAT.ValueData AS PriceWithVAT                                                  
                       , ObjectFloat_PriceList_VATPercent.ValueData AS VATPercent                                                        
                       , Object_PriceList.isErased                                                                                       
                       , TRUE AS isSync
                  FROM Object AS Object_PriceList                                                                                        
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT                                                   
                                               ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id                    
                                              AND ObjectBoolean_PriceList_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                       LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent                                                         
                                             ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id                          
                                            AND ObjectFloat_PriceList_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()          
                  WHERE Object_PriceList.DescId = zc_Object_PriceList()
                    AND Object_PriceList.isErased = FALSE
                    AND Object_PriceList.Id IN (SELECT tmpPriceList.PriceListId FROM tmpPriceList UNION SELECT tmpPriceList.PriceListPriorId FROM tmpPriceList)
                 ;
                    
           END IF;

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
