-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpCheckLoadMoneyFrom1C (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoadMoneyFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inBranchId            Integer    , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMoneyCount Integer;
   DECLARE vbCount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadMoneyFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- Определяем итого записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbMoneyCount 
       FROM Money1C 
      WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate
        AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);

     -- Определяем итого связанных записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbCount
      FROM Money1C
           JOIN (SELECT Object_Partner1CLink.ObjectCode
                      , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                 FROM Object AS Object_Partner1CLink
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                           ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                           ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                           ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId
                                                    AND Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                 WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                   AND Object_Partner1CLink.ObjectCode <> 0
                   AND (Object_Contract_View.ContractId <> 0 OR Object_To.DescId <> zc_Object_Partner()) -- проверка Договор только для контрагента
                   AND ObjectLink_Partner1CLink_Partner.ChildObjectId <> 0 -- еще проверка что есть объект
                ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Money1C.ClientCode
                                     AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Money1C.UnitId), zc_Enum_PaidKind_SecondForm())
     WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);


     -- Проверка
     IF vbMoneyCount <> vbCount THEN 
        RAISE EXCEPTION 'Ошибка. Не все записи засинхронизированы. Перенос не возможен.'; --  <%> <%> <%>, inBranchId, vbMoneyCount, vbCount; 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.09.14                                        * add проверка Договор только для контрагента
 26.08.14                                        * add еще проверка что есть объект
 14.08.14                        * новая связь с филиалами
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
*/

-- тест
-- SELECT * FROM gpCheckLoadMoneyFrom1C ('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, 8379, zfCalc_UserAdmin())
