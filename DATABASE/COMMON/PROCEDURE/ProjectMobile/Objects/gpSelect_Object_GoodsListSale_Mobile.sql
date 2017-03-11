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
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcSession TVarChar;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION '������.�� ���������� ���� �������.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                     FROM ObjectLink AS ObjectLink_User_Member
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

     -- ���������
     RETURN QUERY
       -- ���������
       SELECT tmpMobileGoodsListSale.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId 
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Partner.Id           AS PartnerId
            , Object_Partner.ObjectCode   AS PartnerCode
            , Object_Partner.ValueData    AS PartnerName
            , tmpMobileGoodsListSale.AmountCalc
            , tmpMobileGoodsListSale.isErased
            , tmpMobileGoodsListSale.isSync
       FROM gpSelectMobile_Object_GoodsListSale (zc_DateStart(), calcSession) AS tmpMobileGoodsListSale
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMobileGoodsListSale.GoodsId 
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMobileGoodsListSale.GoodsKindId 
               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpMobileGoodsListSale.PartnerId
       WHERE tmpMobileGoodsListSale.isSync = TRUE
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