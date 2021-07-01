-- Function: gpSelectMobile_Object_Measure (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Measure (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Measure (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- ���
             , ValueData  TVarChar -- ��������
             , isErased   Boolean  -- ��������� �� �������
             , isSync     Boolean  -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �����, ���� ������ � ������ ��������� - ����� ���������� ���
      IF 1 = 0 -- inSyncDateIn > zc_DateStart()
      THEN
          -- ���������
          RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS MeasureId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_Measure
                                                   ON Object_Measure.Id = ObjectProtocol.ObjectId
                                                  AND Object_Measure.DescId = zc_Object_Measure() 
                                  WHERE ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
             SELECT Object_Measure.Id
                  , Object_Measure.ObjectCode
                  , Object_Measure.ValueData
                  , Object_Measure.isErased
                  , (NOT Object_Measure.isErased) AS isSync
             FROM Object AS Object_Measure
                  JOIN tmpProtocol ON tmpProtocol.MeasureId = Object_Measure.Id
             WHERE Object_Measure.DescId = zc_Object_Measure()
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
             ;
      ELSE
           -- ���������
           RETURN QUERY
             SELECT Object_Measure.Id
                  , Object_Measure.ObjectCode
                  , Object_Measure.ValueData
                  , Object_Measure.isErased
                  , TRUE AS isSync
             FROM Object AS Object_Measure
             WHERE Object_Measure.DescId = zc_Object_Measure()
               -- ����� - ���� ��������� ���
               -- AND Object_Measure.isErased = FALSE
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;  

      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_Measure(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
