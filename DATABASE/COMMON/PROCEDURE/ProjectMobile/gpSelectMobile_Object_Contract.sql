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
            
           IF inSyncDateIn > zc_DateStart()
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
                       , Object_ContractTag.ValueData               AS ContractTagName
                       , Object_InfoMoney.ValueData                 AS InfoMoneyName
                       , ObjectString_Contract_Comment.ValueData    AS Comment
                       , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
                       , ObjectDate_Contract_Start.ValueData        AS StartDate
                       , ObjectDate_Contract_End.ValueData          AS EndDate                                                                                                                                             
                       , CAST(0.0 AS TFloat) AS ChangePercent                                                                                                                                                   
                       , CAST(0.0 AS TFloat) AS DelayDayCalendar                                                                                                                                                
                       , CAST(0.0 AS TFloat) AS DelayDayBank                                                                                                                                                    
                       , Object_Contract.isErased                                                                                                                                                               
                       , EXISTS(SELECT 1 FROM tmpContract WHERE tmpContract.ContractId = Object_Contract.Id) AS isSync
                  FROM Object AS Object_Contract                                                                                                                                                             
                       JOIN tmpProtocol ON tmpProtocol.ContractId = Object_Contract.Id
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
                       LEFT JOIN ObjectString AS ObjectString_Contract_Comment
                                              ON ObjectString_Contract_Comment.ObjectId = Object_Contract.Id
                                             AND ObjectString_Contract_Comment.DescId = zc_ObjectString_Contract_Comment()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_Start
                                            ON ObjectDate_Contract_Start.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_Start.DescId = zc_ObjectDate_Contract_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_End
                                            ON ObjectDate_Contract_End.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_End.DescId = zc_ObjectDate_Contract_End()
                  WHERE Object_Contract.DescId = zc_Object_Contract();
           ELSE
                RETURN QUERY
                  SELECT Object_Contract.Id                                                                                                                                                                       
                       , Object_Contract.ObjectCode                                                                                                                                                             
                       , Object_Contract.ValueData                                                                                                                                                              
                       , Object_ContractTag.ValueData               AS ContractTagName
                       , Object_InfoMoney.ValueData                 AS InfoMoneyName
                       , ObjectString_Contract_Comment.ValueData    AS Comment
                       , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId                                                                                                                                                      
                       , ObjectDate_Contract_Start.ValueData        AS StartDate
                       , ObjectDate_Contract_End.ValueData          AS EndDate                                                                                                                                             
                       , CAST(0.0 AS TFloat) AS ChangePercent                                                                                                                                                   
                       , CAST(0.0 AS TFloat) AS DelayDayCalendar                                                                                                                                                
                       , CAST(0.0 AS TFloat) AS DelayDayBank                                                                                                                                                    
                       , Object_Contract.isErased                                                                                                                                                               
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_Contract                                                                                                                                                             
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
                       LEFT JOIN ObjectString AS ObjectString_Contract_Comment
                                              ON ObjectString_Contract_Comment.ObjectId = Object_Contract.Id
                                             AND ObjectString_Contract_Comment.DescId = zc_ObjectString_Contract_Comment()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_Start
                                            ON ObjectDate_Contract_Start.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_Start.DescId = zc_ObjectDate_Contract_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_End
                                            ON ObjectDate_Contract_End.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_End.DescId = zc_ObjectDate_Contract_End()
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
-- SELECT * FROM gpSelectMobile_Object_Contract(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
