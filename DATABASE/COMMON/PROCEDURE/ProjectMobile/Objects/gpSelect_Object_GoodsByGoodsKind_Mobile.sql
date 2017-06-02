-- Function: gpSelect_Object_GoodsLinkGoodsKind_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsLinkGoodsKind_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsLinkGoodsKind_Mobile (
     IN inMemberId   Integer  , -- ���.����
     IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id                 Integer
             , GoodsId            Integer  -- �����
             , GoodsCode          Integer  -- �����
             , GoodsName          TVarChar -- �����
             , GoodsKindId        Integer  -- ��� ������
             , GoodsKindName      TVarChar -- ��� ������
             , GoodsGroupName     TVarChar -- ������ ������
             , GoodsGroupNameFull TVarChar --
             , InfoMoneyName_all  TVarChar
             , Remains            TFloat   -- ������� ��  ������ vbUnitId
             , Forecast           TFloat   -- ������� ������� �� vbUnitId
             , isErased           Boolean  -- ��������� �� �������
             , isSync             Boolean  -- ���������������� (��/���)
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
     vbUserId_Mobile:= (SELECT CASE WHEN lfGet.UserId > 0 THEN lfGet.UserId ELSE vbUserId END FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- ���������
     RETURN QUERY
       SELECT gpSelect.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_InfoMoney_View.InfoMoneyName_all
            , gpSelect.Remains
            , gpSelect.Forecast
            , gpSelect.isErased
            , gpSelect.isSync
       FROM gpSelectMobile_Object_GoodsByGoodsKind (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS gpSelect
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id = gpSelect.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = gpSelect.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 02.06.17         * add InfoMoney
 10.03.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsLinkGoodsKind_Mobile (inMemberId:= 1, inSession := zfCalc_UserAdmin())
