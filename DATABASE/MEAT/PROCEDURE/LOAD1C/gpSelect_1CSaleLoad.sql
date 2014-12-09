 -- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inBranchId         integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TDateTime, ClientCode Integer,
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
     WITH tmpSale1C AS (SELECT *
                        FROM Sale1C
                        WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND Sale1C.BranchId = inBranchId
                       )
        , tmpGoodsByGoodsKind1CLink AS (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                                             , Object_GoodsByGoodsKind1CLink.ObjectCode
                                             , ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId
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
   SELECT   
      tmpSale1C.Id          ,
      tmpSale1C.UnitId      ,
      tmpSale1C.VidDoc      ,
      tmpSale1C.InvNumber   ,
      tmpSale1C.OperDate    ,
      tmpSale1C.ClientCode  ,   
      tmpSale1C.GoodsCode   ,   
      tmpSale1C.GoodsName   ,   
      tmpSale1C.OperCount   ,
      tmpSale1C.OperPrice   ,
      tmpSale1C.Tax         ,
      tmpSale1C.Suma        ,
      tmpSale1C.PDV         ,
      tmpSale1C.SumaPDV     ,
      tmpSale1C.InvNalog    ,
      Object_Branch.ValueData AS BranchName,
      CASE tmpSale1C.VidDoc
        WHEN '1' THEN 'Расход'
        WHEN '4' THEN 'Возврат'
      END::TVarChar AS DocType, 
      Object_Goods.ObjectCode AS GoodsGoodsKindCode,
      (COALESCE (Object_Goods.ValueData, '') || ' ' || COALESCE (Object_GoodsKind.ValueData, '')) :: TVarChar AS GoodsGoodsKindName

      FROM tmpSale1C
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpSale1C.BranchId
   
           LEFT JOIN tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = tmpSale1C.GoodsCode
                                              AND tmpGoodsByGoodsKind1CLink.BranchId_Link = tmpSale1C.BranchId_Link

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsByGoodsKind1CLink.GoodsId

           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()

           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId
     
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoad (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.09.14                                        * add оптимизируем
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
-- SELECT * FROM gpSelect_1CSaleLoad ('01.11.2014'::TDateTime, '30.11.2014'::TDateTime, 8379, inSession:= zfCalc_UserAdmin())
