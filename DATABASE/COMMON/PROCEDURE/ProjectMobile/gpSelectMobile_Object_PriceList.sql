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
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ���������
      RETURN QUERY
        WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                             FROM ObjectProtocol
                                  JOIN Object AS Object_PriceList
                                              ON Object_PriceList.Id = ObjectProtocol.ObjectId
                                             AND Object_PriceList.DescId = zc_Object_PriceList() 
                             WHERE ObjectProtocol.OperDate > inSyncDateIn
                             GROUP BY ObjectProtocol.ObjectId
                            )
        SELECT Object_PriceList.Id
             , Object_PriceList.ObjectCode
             , Object_PriceList.ValueData
             , ObjectBoolean_PriceList_PriceWithVAT.ValueData AS PriceWithVAT
             , ObjectFloat_PriceList_VATPercent.ValueData AS VATPercent
             , Object_PriceList.isErased
             , (NOT Object_PriceList.isErased) AS isSync
        FROM Object AS Object_PriceList
             JOIN tmpProtocol ON tmpProtocol.PriceListId = Object_PriceList.Id
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT
                                     ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id
                                    AND ObjectBoolean_PriceList_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() 
             LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent
                                   ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id
                                  AND ObjectFloat_PriceList_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent() 
        WHERE Object_PriceList.DescId = zc_Object_PriceList();

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_PriceList(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
