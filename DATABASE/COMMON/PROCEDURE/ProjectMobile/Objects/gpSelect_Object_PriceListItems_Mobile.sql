-- Function: gpSelect_Object_PriceListItems_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceListItems_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceListItems_Mobile (
     IN inMemberId   Integer  , -- ���.����
     IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer   -- �����
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsGroupName     TVarChar -- ������ ������
             , GoodsGroupNameFull TVarChar -- 
             , PriceListId    Integer   -- �����-����
             , PriceListName  TVarChar
             , OrderStartDate TDateTime -- ���� � ������� ��������� ���� ������
             , OrderEndDate   TDateTime -- ���� �� ������� ��������� ���� ������
             , OrderPrice     TFloat    -- ���� ������
             , SaleStartDate  TDateTime -- ���� � ������� ��������� ���� ��������
             , SaleEndDate    TDateTime -- ���� �� ������� ��������� ���� ��������
             , SalePrice      TFloat    -- ���� ��������
             , isSync         Boolean   -- ���������������� (��/���)
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

     RETURN QUERY
       SELECT tmpMobilePriceListItems.Id
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsGroup.ValueData AS GoodsGroupName 
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_PriceList.Id         AS PriceListId 
            , Object_PriceList.ValueData  AS PriceListName

            , tmpMobilePriceListItems.OrderStartDate
            , tmpMobilePriceListItems.OrderEndDate
            , tmpMobilePriceListItems.OrderPrice
            , tmpMobilePriceListItems.SaleStartDate
            , tmpMobilePriceListItems.SaleEndDate
            , tmpMobilePriceListItems.SalePrice
            , tmpMobilePriceListItems.isSync

        FROM gpSelectMobile_Object_PriceListItems (zc_DateStart(), calcSession) AS tmpMobilePriceListItems
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMobilePriceListItems.GoodsId 
             LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMobilePriceListItems.PriceListId 

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        WHERE tmpMobilePriceListItems.isSync = TRUE;
  
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.03.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PriceListItems_Mobile(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())