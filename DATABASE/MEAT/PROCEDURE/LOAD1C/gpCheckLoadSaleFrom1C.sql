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
   DECLARE vbSaleCount Integer;
   DECLARE vbCount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- Определяем итого записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbSaleCount 
       FROM Sale1C 
      WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
        AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);

     -- Определяем итого связанных записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbCount
      FROM Sale1C
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
                 WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                   AND Object_Partner1CLink.ObjectCode <> 0
                   AND (ObjectLink_Partner1CLink_Contract.ChildObjectId <> 0 OR Object_To.DescId <> zc_Object_Partner()) -- проверка Договор только для контрагента
                   AND ObjectLink_Partner1CLink_Partner.ChildObjectId <> 0 -- еще проверка что есть объект
                ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                     AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind (zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))

           JOIN (SELECT Object_GoodsByGoodsKind1CLink.ObjectCode
                      , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
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
                ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
                                              AND tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))

     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);


     -- Проверка
     IF vbSaleCount <> vbCount THEN 
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
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
