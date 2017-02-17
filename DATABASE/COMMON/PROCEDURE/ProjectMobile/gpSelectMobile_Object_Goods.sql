-- Function: gpSelectMobile_Object_Goods (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Goods (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Goods (
  IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
  IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- ���
             , ValueData    TVarChar -- ��������
             , Weight       TFloat   -- ��� ������
             , Remains      TFloat   -- ������� ������|��� ������ Object_Const.UnitId - �� ������ "���������"  �������������
             , Forecast     TFloat   -- ������� �� ����������� - ������� ������� �� ����� Object_Const.UnitId �� �������� ������ ��� ����� �������� �� ������ - �� ������ "���������"  �������������
             , GoodsGroupId Integer  -- ������ ������
             , MeasureId    Integer  -- ������� ���������
             , isErased     Boolean  -- ��������� �� �������
             , isSync       Boolean  -- ���������������� (��/���)
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
-- SELECT * FROM gpSelectMobile_Object_Goods(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
