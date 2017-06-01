-- Function: gpSelect_Object_GoodsListSale_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsListSale_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsListSale_Mobile (
     IN inMemberId       Integer  , -- ���.����
     IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer  -- �����
             , GoodsCode      Integer  -- �����
             , GoodsName      TVarChar -- �����
             , GoodsKindId    Integer  -- ��� ������
             , GoodsKindName  TVarChar -- ��� ������
             , PartnerId      Integer  -- ����������
             , PartnerCode    Integer  -- ����������
             , PartnerName    TVarChar --
             , AmountCalc     TFloat   -- ��������������� ��������, ����� ������������ ��� ������� �� ���������  ���������� "���������������� ������", ����������� � ������� �� = ���������� ������� ���� �� �� + ���������� �� �� - �������� � ��, ������ ��� ��� �� "������������" ������
             , isErased       Boolean  -- ��������� �� �������
             , isSync         Boolean  -- ���������������� (��/���)
             )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ ��������!!! - � ������ ����������� ������������ ����� ������������� ������ � ���������� ����������
     vbUserId_Mobile:= (SELECT lfGet.UserId FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- ���������
     RETURN QUERY
       SELECT gpSelect.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Partner.Id           AS PartnerId
            , Object_Partner.ObjectCode   AS PartnerCode
            , Object_Partner.ValueData    AS PartnerName
            , gpSelect.AmountCalc
            , gpSelect.isErased
            , gpSelect.isSync
       FROM gpSelectMobile_Object_GoodsListSale (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS gpSelect
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = gpSelect.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = gpSelect.GoodsKindId
            LEFT JOIN Object AS Object_Partner   ON Object_Partner.Id   = gpSelect.PartnerId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 10.03.17         *
*/

-- ����
-- select * from gpSelect_Object_GoodsListSale_Mobile(inMemberId := 149833 ,  inSession := '5'::TVarChar);