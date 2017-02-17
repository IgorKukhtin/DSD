-- Function: gpSelectMobile_Object_GoodsLinkGoodsKind (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsLinkGoodsKind (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsLinkGoodsKind (
  IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
  IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id          Integer
             , GoodsId     Integer  -- �����
             , GoodsKindId Integer  -- ��� ������
             , isErased    Boolean  -- ��������� �� �������
             , isSync      Boolean  -- ���������������� (��/���)
)
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
  vbUserId:= lpGetUserBySession (inSession);

  -- ���������
  RETURN;
  -- RETURN QUERY

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_GoodsLinkGoodsKind(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
