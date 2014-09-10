 -- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inBranchId         integer   ,
    IN inSession          TVarChar    -- ������ ������������
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
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_1CSaleLoad());

   -- ���������
   RETURN QUERY 
   SELECT   
      Sale1C.Id          ,
      Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
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
        WHEN '1' THEN '������'
        WHEN '4' THEN '�������'
      END::TVarChar AS DocType, 
      Object_Goods.ObjectCode AS GoodsGoodsKindCode,
      (COALESCE (Object_Goods.ValueData, '') || ' ' || COALESCE (Object_GoodsKind.ValueData, '')) :: TVarChar AS GoodsGoodsKindName

      FROM Sale1C
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = zfGetBranchFromUnitId (Sale1C.UnitId)
   
           LEFT JOIN (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                           , Object_GoodsByGoodsKind1CLink.ObjectCode
                           , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                           , ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId
                      FROM Object AS Object_GoodsByGoodsKind1CLink
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                               AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                                ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                               AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
                      WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                        AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = (SELECT Object_BranchLink_View.Id FROM Object_BranchLink_View WHERE Object_BranchLink_View.BranchId = inBranchId AND COALESCE (Object_BranchLink_View.PaidKindId, 0) <> zc_Enum_PaidKind_FirstForm()) -- ������������
                        AND Object_GoodsByGoodsKind1CLink.ObjectCode <> 0
                        AND ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId <> 0 -- ��� �������� ��� ���� ������
                     ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
                                                   -- AND tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsByGoodsKind1CLink.GoodsId

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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.09.14                                        * add ������������
 14.08.14                        * ����� ����� � ���������
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
 24.04.14                                        * add Contract...
 11.04.14                         * 
 09.04.14                         * 
 17.02.14                         * 
 15.02.14                                        * all
 03.02.14                         * 
*/

-- ����
-- SELECT * FROM gpSelect_1CSaleLoad (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inSession:= zfCalc_UserAdmin())
