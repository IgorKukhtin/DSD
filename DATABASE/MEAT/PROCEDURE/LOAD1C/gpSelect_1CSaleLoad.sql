-- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TDateTime, ClientCode Integer, ClientName TVarChar, 
               GoodsCode Integer, GoodsName TVarChar, OperCount TFloat, OperPrice TFloat,
               Tax TFloat, Doc1Date TDateTime, Doc1Number TVarChar, Doc2Date TDateTime, Doc2Number TVarChar,
               Suma TFloat, PDV TFloat, SumaPDV TFloat, ClientINN TVarChar, ClientOKPO TVarChar,
               InvNalog TVarChar, BillId Integer, EkspCode Integer, ExpName TVarChar,
               DeliveryPointCode Integer, DeliveryPointName TVarChar,
               GoodsGoodsKindCode Integer, GoodsGoodsKindName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_1CSaleLoad());

   -- Результат
   RETURN QUERY 
   SELECT   
      Sale1C.Id          ,
      Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
      Sale1C.ClientName  ,   
      Sale1C.GoodsCode   ,   
      Sale1C.GoodsName   ,   
      Sale1C.OperCount   ,
      Sale1C.OperPrice   ,
      Sale1C.Tax         ,
      Sale1C.Doc1Date    ,
      Sale1C.Doc1Number  ,
      Sale1C.Doc2Date    ,
      Sale1C.Doc2Number  ,
      Sale1C.Suma        ,
      Sale1C.PDV         ,
      Sale1C.SumaPDV     ,
      Sale1C.ClientINN   ,
      Sale1C.ClientOKPO  ,
      Sale1C.InvNalog    ,
      Sale1C.BillId      ,
      Sale1C.EkspCode    ,
      Sale1C.ExpName     ,
      Object_Partner.ObjectCode,
      Object_Partner.ValueData,
      Object_Goods.ObjectCode AS GoodsGoodsKindCode,
      (COALESCE (Object_Goods.ValueData, '') || ' ' || COALESCE (Object_GoodsKind.ValueData, '')) :: TVarChar AS GoodsGoodsKindName
      

      FROM Sale1C
           LEFT JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                           , Object_Partner1CLink.ObjectCode
                           , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                      FROM Object AS Object_Partner1CLink
                           LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                               AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                      WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                     ) AS tmpPartner1CLink ON tmpPartner1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
                                          AND tmpPartner1CLink.ObjectCode = Sale1C.ClientCode

           LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.ObjectId
                               AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId

           LEFT JOIN (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                           , Object_GoodsByGoodsKind1CLink.ObjectCode
                           , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                      FROM Object AS Object_GoodsByGoodsKind1CLink
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                               AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                      WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                     ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
                                                   AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoad (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.02.14                                        * all
 03.02.14                         * 
*/

-- тест
-- SELECT * FROM gpSelect_1CSaleLoad (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inSession:= zfCalc_UserAdmin())
