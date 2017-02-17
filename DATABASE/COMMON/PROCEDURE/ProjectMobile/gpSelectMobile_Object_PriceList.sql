-- Function: gpSelectMobile_Object_PriceList (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceList (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceList (
  IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
  IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- ���
             , ValueData    TVarChar -- ��������
             , PriceWithVAT Boolean  -- ���� � ��� (��/���)
             , VATPercent   TFloat   -- % ���
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
-- SELECT * FROM gpSelectMobile_Object_PriceList(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
