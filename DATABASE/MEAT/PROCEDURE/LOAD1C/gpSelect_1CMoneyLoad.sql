-- Function: gpSelect_1CMoneyLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CMoneyLoad (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CMoneyLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inBranchId         integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, InvNumber TVarChar,
               OperDate TDateTime, ClientCode Integer, ClientName TVarChar,       
               SummaIn  TFloat, SummaOut TFloat,   
               BranchName TVarChar, ClientFindCode Integer, ClientFindName TVarChar,
               ContractId Integer, ContactNumber TVarChar, ContractTagName TVarChar, 
               ContractStateKindCode Integer
             , ItemName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_1CMoneyLoad());

   -- Результат
   RETURN QUERY 
   SELECT DISTINCT
      Money1C.Id          ,
      Money1C.UnitId      ,
      Money1C.InvNumber   ,
      Money1C.OperDate    ,
      Money1C.ClientCode  ,   
      Money1C.ClientName  ,   
      Money1C.SummaIn     ,   
      Money1C.SummaOut    ,   
      Object_Branch.ValueData AS BranchName,
      Object_Partner.ObjectCode,
      Object_Partner.ValueData,
      Object_Contract_View.ContractId, 
      Object_Contract_View.InvNumber AS ContactNumber, 
--      Object_Contract_View.EndDate,
      Object_Contract_View.ContractTagName,
      Object_Contract_View.ContractStateKindCode 
    , ObjectDesc.ItemName
      FROM Money1C
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = zfGetBranchFromUnitId (Money1C.UnitId)
           LEFT JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                           , Object_Partner1CLink.ObjectCode
                           , ObjectLink_Partner1CLink_Branch.ChildObjectId   AS BranchId
                           , ObjectLink_Partner1CLink_Contract.ChildObjectId AS ContractId
                           , ObjectLink_Partner1CLink_Partner.ChildObjectId  AS PartnerId
                           , ObjectLink_Partner_Juridical.ChildObjectId      AS JuridicalId
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

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                      WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                        AND ObjectLink_Partner1CLink_Branch.ChildObjectId = (SELECT Object_BranchLink_View.Id FROM Object_BranchLink_View WHERE Object_BranchLink_View.BranchId = inBranchId AND COALESCE (Object_BranchLink_View.PaidKindId, 0) <> zc_Enum_PaidKind_FirstForm()) -- оптимизируем
                        AND Object_Partner1CLink.ObjectCode <> 0
                        AND ObjectLink_Partner1CLink_Partner.ChildObjectId <> 0 -- еще проверка что есть объект
                     ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Money1C.ClientCode
                                          -- AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Money1C.UnitId), zc_Enum_PaidKind_SecondForm())

           LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner1CLink.ContractId
                                         AND Object_Contract_View.JuridicalId = tmpPartner1CLink.JuridicalId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpPartner1CLink.PartnerId
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

   WHERE Money1C.OperDate BETWEEN inStartDate AND inEndDate 
     AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CMoneyLoad (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.09.14                                        * add оптимизируем
 08.09.14                                        * add ItemName
 01.09.14                        *  
*/

-- тест
-- SELECT * FROM gpSelect_1CMoneyLoad (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inBranchId:= 8377 , inSession:= zfCalc_UserAdmin())
