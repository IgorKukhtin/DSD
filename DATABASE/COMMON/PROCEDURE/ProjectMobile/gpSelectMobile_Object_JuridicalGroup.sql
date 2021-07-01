-- Function: gpSelectMobile_Object_JuridicalGroup (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_JuridicalGroup (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_JuridicalGroup (
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

      -- ���������
      IF inSyncDateIn > zc_DateStart()
      THEN
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS JuridicalGroupId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_JuridicalGroup
                                                   ON Object_JuridicalGroup.Id = ObjectProtocol.ObjectId
                                                  AND Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup() 
                                  WHERE ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
             SELECT Object_JuridicalGroup.Id
                  , Object_JuridicalGroup.ObjectCode
                  , Object_JuridicalGroup.ValueData
                  , Object_JuridicalGroup.isErased
                  , (NOT Object_JuridicalGroup.isErased) AS isSync
             FROM Object AS Object_JuridicalGroup
                  JOIN tmpProtocol ON tmpProtocol.JuridicalGroupId = Object_JuridicalGroup.Id
             WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;
      ELSE
           RETURN QUERY
             SELECT Object_JuridicalGroup.Id
                  , Object_JuridicalGroup.ObjectCode
                  , Object_JuridicalGroup.ValueData
                  , Object_JuridicalGroup.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_JuridicalGroup
             WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
               AND (NOT Object_JuridicalGroup.isErased)
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
               ;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 06.04.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_JuridicalGroup(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
