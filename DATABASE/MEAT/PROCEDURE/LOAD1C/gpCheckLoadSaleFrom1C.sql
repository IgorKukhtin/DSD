-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpCheckLoadSaleFrom1C (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- ��������� ���� ��������
    IN inEndDate             TDateTime  , -- �������� ���� ��������
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSaleCount Integer;
   DECLARE vbCount Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- ���������� ����� ������� (��� �������� ��� ��� ��� �������� �����������)
     SELECT COUNT(*) INTO vbSaleCount 
       FROM Sale1C 
      WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
        AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);

     -- ���������� ����� ��������� ������� (��� �������� ��� ��� ��� �������� �����������)
     SELECT COUNT(*) INTO vbCount
      FROM Sale1C
           JOIN (SELECT Object_Partner1CLink.ObjectCode
                      , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                 FROM Object AS Object_Partner1CLink
                      LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                           ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                           JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                           ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                 WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                   AND Object_Partner1CLink.ObjectCode <> 0
                   AND ObjectLink_Partner1CLink_Contract.ChildObjectId <> 0
                ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                     AND tmpPartner1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)

           JOIN (SELECT Object_GoodsByGoodsKind1CLink.ObjectCode
                      , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                 FROM Object AS Object_GoodsByGoodsKind1CLink
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                           ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                          AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                 WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                   AND Object_GoodsByGoodsKind1CLink.ObjectCode <> 0
                ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
                                              AND tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)

     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);


     -- ��������
     IF vbSaleCount <> vbCount THEN 
        RAISE EXCEPTION '������.�� ��� ������ ������������������. ������� �� ��������.'; --  <%> <%> <%>, inBranchId, vbSaleCount, vbCount; 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.05.14                                        * add ObjectCode <> 0
 24.04.14                         * 
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
