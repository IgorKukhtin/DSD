-- Function: gpSelectMobile_Object_Contract (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Contract (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Contract (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer   -- Код
             , ValueData        TVarChar  -- Название
             , ContractTagName  TVarChar  -- Признак договора
             , InfoMoneyName    TVarChar  -- УП статья
             , Comment          TVarChar  -- Примечание
             , PaidKindId       Integer   -- Форма оплаты
             , StartDate        TDateTime -- Дата с которой действует договор
             , EndDate          TDateTime -- Дата до которой действует договор
             , ChangePercent    TFloat    -- (-)% Скидки (+)% Наценки - для Скидки - отрицателеное значение, для Наценки - положительное
             , DelayDayCalendar TFloat    -- Отсрочка в календарных днях
             , DelayDayBank     TFloat    -- Отсрочка в банковских днях 
             , isErased         Boolean   -- Удаленный ли элемент
             , isSync           Boolean   -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           CREATE TEMP TABLE tmpContract ON COMMIT DROP
           AS (SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId                                                                                                                         
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade                                                                                                                                      
                    JOIN ObjectLink AS ObjectLink_Partner_Juridical                                                                                                                                        
                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId                                                                                   
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()                                                                                             
                    JOIN ObjectLink AS ObjectLink_Contract_Juridical                                                                                                                                    
                                    ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId             
                                   AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()                                                                                        
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()                                                                                                    
              );
            
           IF inSyncDateIn > zc_DateZero()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS ContractId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol                                                                                                                                                                      
                                            JOIN Object AS Object_Contract                                                                                                                                                         
                                                        ON Object_Contract.Id = ObjectProtocol.ObjectId
                                                       AND Object_Contract.DescId = zc_Object_Contract()
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId                                                                                                                                                         
                                      )                                                                                                                                                                                          
                  SELECT Object_Contract.Id                                                                                                                                                                       
                       , Object_Contract.ObjectCode                                                                                                                                                             
                       , Object_Contract.ValueData                                                                                                                                                              
                       , CAST('' AS TVarChar) AS ContractTagName                                                                                                                                                
                       , CAST('' AS TVarChar) AS InfoMoneyName                                                                                                                                                  
                       , CAST('' AS TVarChar) AS Comment                                                                                                                                                        
                       , CAST(0  AS Integer) AS PaidKindId                                                                                                                                                      
                       , CAST(CURRENT_DATE AS TDateTime) AS StartDate                                                                                                                                           
                       , CAST(CURRENT_DATE AS TDateTime) AS EndDate                                                                                                                                             
                       , CAST(0.0 AS TFloat) AS ChangePercent                                                                                                                                                   
                       , CAST(0.0 AS TFloat) AS DelayDayCalendar                                                                                                                                                
                       , CAST(0.0 AS TFloat) AS DelayDayBank                                                                                                                                                    
                       , Object_Contract.isErased                                                                                                                                                               
                       , EXISTS(SELECT 1 FROM tmpContract WHERE tmpContract.ContractId = Object_Contract.Id) AS isSync
                  FROM Object AS Object_Contract                                                                                                                                                             
                       JOIN tmpProtocol ON tmpProtocol.ContractId = Object_Contract.Id
                  WHERE Object_Contract.DescId = zc_Object_Contract();
           ELSE
                RETURN QUERY
                  SELECT Object_Contract.Id                                                                                                                                                                       
                       , Object_Contract.ObjectCode                                                                                                                                                             
                       , Object_Contract.ValueData                                                                                                                                                              
                       , CAST('' AS TVarChar) AS ContractTagName                                                                                                                                                
                       , CAST('' AS TVarChar) AS InfoMoneyName                                                                                                                                                  
                       , CAST('' AS TVarChar) AS Comment                                                                                                                                                        
                       , CAST(0  AS Integer) AS PaidKindId                                                                                                                                                      
                       , CAST(CURRENT_DATE AS TDateTime) AS StartDate                                                                                                                                           
                       , CAST(CURRENT_DATE AS TDateTime) AS EndDate                                                                                                                                             
                       , CAST(0.0 AS TFloat) AS ChangePercent                                                                                                                                                   
                       , CAST(0.0 AS TFloat) AS DelayDayCalendar                                                                                                                                                
                       , CAST(0.0 AS TFloat) AS DelayDayBank                                                                                                                                                    
                       , Object_Contract.isErased                                                                                                                                                               
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_Contract                                                                                                                                                             
                  WHERE Object_Contract.DescId = zc_Object_Contract()
                    AND EXISTS(SELECT 1 FROM tmpContract WHERE tmpContract.ContractId = Object_Contract.Id);
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
-- SELECT * FROM gpSelectMobile_Object_Contract(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
