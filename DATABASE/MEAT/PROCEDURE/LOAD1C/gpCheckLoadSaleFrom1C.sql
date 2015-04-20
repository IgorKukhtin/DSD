-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpCheckLoadSaleFrom1C (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inBranchId            Integer    , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId_Link Integer;
   DECLARE vbSaleCount Integer;
   DECLARE vbCount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- Определяем итого записей (для проверка что все для переноса установлено)
     SELECT COUNT(*), MAX (BranchId_Link)
            INTO vbSaleCount, vbBranchId_Link
     FROM Sale1C
               LEFT JOIN (SELECT Object_Partner1CLink.Id          AS Partner1CLinkId
                          , Object_Partner1CLink.ObjectCode  AS ClientCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId                 AS BranchId
                          , COALESCE (ObjectLink_Partner1CLink_Contract.ChildObjectId, 0) AS ContractId
                     FROM Object AS Object_Partner1CLink
                          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                               AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                               ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                              AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ClientCode = Sale1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))

               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.Partner1CLinkId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
       AND Sale1C.BranchId = inBranchId
       AND COALESCE (ObjectLink_Partner1CLink_Partner.ChildObjectId, 0) <> zc_Enum_InfoMoney_40801() -- Внутренний оборот
    ;


     CREATE TEMP TABLE _tmpResult (Value Integer) ON COMMIT DROP;
     -- Определяем итого связанных записей (для проверка что все для переноса установлено)
     WITH tmpSale1C AS (SELECT ClientCode, GoodsCode
                        FROM Sale1C
                        WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND Sale1C.BranchId = inBranchId
                       )
        , tmpPartner1CLink AS (SELECT Object_Partner1CLink.ObjectCode
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
                                 AND ObjectLink_Partner1CLink_Branch.ChildObjectId = vbBranchId_Link
                                 AND COALESCE (ObjectLink_Partner1CLink_Partner.ChildObjectId, 0) <> zc_Enum_InfoMoney_40801() -- Внутренний оборот
                              )
        , tmpGoodsByGoodsKind1CLink AS (SELECT Object_GoodsByGoodsKind1CLink.ObjectCode
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
                                          AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = vbBranchId_Link
                                       )
     INSERT INTO _tmpResult (Value)
        SELECT COUNT(*)
        FROM tmpSale1C
             INNER JOIN tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = tmpSale1C.ClientCode
             INNER JOIN tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = tmpSale1C.GoodsCode
       ;


     -- Определяем итого связанных записей (для проверка что все для переноса установлено)
     vbCount:= (SELECT Value FROM _tmpResult);

     -- Проверка
     IF COALESCE (vbSaleCount, 0) <> COALESCE (vbCount, 0)
     THEN 
        RAISE EXCEPTION 'Ошибка.Не все записи засинхронизированы. Перенос не возможен.'; --  <%> <%> <%>, inBranchId, vbSaleCount, vbCount; 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.09.14                                        * add проверка Договор только для контрагента
 26.08.14                                        * add еще проверка что есть объект
 14.08.14                        * новая связь с филиалами
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
*/

-- тест
-- SELECT * FROM gpCheckLoadSaleFrom1C ('01.11.2014'::TDateTime, '30.11.2014'::TDateTime, 8379, zfCalc_UserAdmin())
