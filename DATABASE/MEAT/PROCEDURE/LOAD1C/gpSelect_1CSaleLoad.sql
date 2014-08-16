-- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inBranchId         integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TDateTime,  
               GoodsCode Integer, GoodsName TVarChar, OperCount TFloat, OperPrice TFloat,
               Tax TFloat, Suma TFloat, PDV TFloat, SumaPDV TFloat, 
               InvNalog TVarChar, BranchName TVarChar, DocType TVarChar, 
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
      Sale1C.GoodsCode   ,   
      Sale1C.GoodsName   ,   
      Sale1C.OperCount   ,
      Sale1C.OperPrice   ,
      Sale1C.Tax         ,
      Sale1C.Suma        ,
      Sale1C.PDV         ,
      Sale1C.SumaPDV     ,
      Sale1C.InvNalog    ,
      Object_Branch.ValueData AS BranchName,
      CASE Sale1C.VidDoc
        WHEN '1' THEN 'Расход'
        WHEN '4' THEN 'Возврат'
      END::TVarChar AS DocType, 
      Object_Goods.ObjectCode AS GoodsGoodsKindCode,
      (COALESCE (Object_Goods.ValueData, '') || ' ' || COALESCE (Object_GoodsKind.ValueData, '')) :: TVarChar AS GoodsGoodsKindName

      FROM Sale1C
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = zfGetBranchFromUnitId (Sale1C.UnitId)
   
           LEFT JOIN (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                           , Object_GoodsByGoodsKind1CLink.ObjectCode
                           , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                      FROM Object AS Object_GoodsByGoodsKind1CLink
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                               AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                      WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                        AND Object_GoodsByGoodsKind1CLink.ObjectCode <> 0
                     ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
                                                   AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoad (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.08.14                        * новая связь с филиалами
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
 24.04.14                                        * add Contract...
 11.04.14                         * 
 09.04.14                         * 
 17.02.14                         * 
 15.02.14                                        * all
 03.02.14                         * 
*/

-- тест
-- SELECT * FROM gpSelect_1CSaleLoad (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inSession:= zfCalc_UserAdmin())
