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
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ���������
      RETURN QUERY
        WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS GoodsId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                             FROM ObjectProtocol
                                  JOIN Object AS Object_Goods
                                              ON Object_Goods.Id = ObjectProtocol.ObjectId
                                             AND Object_Goods.DescId = zc_Object_Goods() 
                             WHERE ObjectProtocol.OperDate > inSyncDateIn
                             GROUP BY ObjectProtocol.ObjectId
                            )
        SELECT Object_Goods.Id
             , Object_Goods.ObjectCode
             , Object_Goods.ValueData
             , CAST(0.0 AS TFloat) AS Weight
             , CAST(0.0 AS TFloat) AS Remains
             , CAST(0.0 AS TFloat) AS Forecast
             , CAST(0 AS Integer)  AS GoodsGroupId
             , CAST(0 AS Integer)  AS MeasureId
             , Object_Goods.isErased
             , (NOT Object_Goods.isErased) AS isSync
        FROM Object AS Object_Goods
             JOIN tmpProtocol ON tmpProtocol.GoodsId = Object_Goods.Id
        WHERE Object_Goods.DescId = zc_Object_Goods();

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_Goods(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
