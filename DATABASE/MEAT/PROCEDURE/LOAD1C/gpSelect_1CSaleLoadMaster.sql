-- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoadMaster (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoadMaster(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inBranchId         integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TDateTime, ClientCode Integer, ClientName TVarChar, 
               ClientINN TVarChar, ClientOKPO TVarChar,
               /*InvNalog TVarChar,*/
               BranchName TVarChar, DocType TVarChar, 
               DeliveryPointCode Integer, DeliveryPointName TVarChar,
               ContractId Integer, ContractNumber TVarChar, EndDate TDateTime
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , Synchronize Boolean, PaidKindName TVarChar
             , ItemName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_1CSaleLoad());

   -- Результат
   RETURN QUERY 
     WITH tmpPartner1CLink AS (SELECT Object_Partner1CLink.Id AS ObjectId
                                    , Object_Partner1CLink.ObjectCode
                                    , ObjectLink_Partner1CLink_Branch.ChildObjectId   AS BranchId_Link
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
                                    LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId

                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                               WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                                 AND Object_Partner1CLink.ObjectCode <> 0
                                 AND (ObjectLink_Partner1CLink_Contract.ChildObjectId <> 0 OR Object_To.DescId <> zc_Object_Partner()) -- проверка Договор только для контрагента
                                 AND ObjectLink_Partner1CLink_Partner.ChildObjectId <> 0 -- еще проверка что есть объект
                              )
        , tmpGoodsByGoodsKind1CLink AS (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                                             , Object_GoodsByGoodsKind1CLink.ObjectCode
                                             , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId_Link
                                        FROM Object AS Object_GoodsByGoodsKind1CLink
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                                  ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                                 AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                                                  ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                                 AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
                                        WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                                          AND Object_GoodsByGoodsKind1CLink.ObjectCode <> 0
                                          AND ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId <> 0  -- еще проверка что есть объект
                                       )
   SELECT DISTINCT
      Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
      Sale1C.ClientName  ,   
      Sale1C.ClientINN   ,
      Sale1C.ClientOKPO  ,
      -- Sale1C.InvNalog    ,
      Object_Branch.ValueData AS BranchName,
      CASE Sale1C.VidDoc
        WHEN '1' THEN 'Расход'
        WHEN '2' THEN 'Расход'
        WHEN '3' THEN 'Возврат'
        WHEN '4' THEN 'Возврат'
      END::TVarChar AS DocType, 
      Object_Partner.ObjectCode,
      Object_Partner.ValueData,
      Object_Contract_View.ContractId, 
      Object_Contract_View.InvNumber AS ContactNumber           
            , Object_Contract_View.EndDate
            , Object_Contract_View.ContractTagName
            , Object_Contract_View.ContractStateKindCode 
            , (Count (tmpGoodsByGoodsKind1CLink.ObjectId) <> Count (*)) AS Synchronize      
      , Object_PaidKind.ValueData AS PaidKindName
      , ObjectDesc.ItemName
      
      FROM Sale1C
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Sale1C.PaidKindId
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Sale1C.BranchId
           LEFT JOIN tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                     AND tmpPartner1CLink.BranchId_Link = Sale1C.BranchId_Link

           LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner1CLink.ContractId
                                         AND Object_Contract_View.JuridicalId = tmpPartner1CLink.JuridicalId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpPartner1CLink.PartnerId
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

           LEFT JOIN tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
                                              AND tmpGoodsByGoodsKind1CLink.BranchId_Link = Sale1C.BranchId_Link


   WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND Sale1C.BranchId = inBranchId
   GROUP BY       Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
      Sale1C.ClientName  ,   
      Sale1C.ClientINN   ,
      Sale1C.ClientOKPO  ,
      -- Sale1C.InvNalog    ,
      Object_Branch.ValueData,
      CASE Sale1C.VidDoc
        WHEN '1' THEN 'Расход'
        WHEN '4' THEN 'Возврат'
      END::TVarChar, 
      Object_Partner.ObjectCode,
      Object_Partner.ValueData,
      Object_Contract_View.ContractId, 
      Object_Contract_View.InvNumber
            , Object_Contract_View.EndDate
            , Object_Contract_View.ContractTagName
            , Object_Contract_View.ContractStateKindCode 
      , ObjectDesc.ItemName
      , Object_PaidKind.ValueData
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoadMaster (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.09.14                                        * add оптимизируем
 26.08.14                                        * add еще проверка что есть объект
 14.08.14                        * новая связь с филиалами
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
*/

-- тест
-- SELECT * FROM gpSelect_1CSaleLoadMaster ('01.11.2014'::TDateTime, '30.11.2014'::TDateTime, 8379, inSession:= zfCalc_UserAdmin())
