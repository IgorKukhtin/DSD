-- Function: gpSelectMobile_Object_Juridical (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Juridical (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Juridical (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- ���
             , ValueData  TVarChar -- ��������
             , DebtSum    TFloat   -- ����� ����� (���) - �� - �.�. �� ���� ����������� ������ � ������� �� ��� + ���������
             , OverSum    TFloat   -- ����� ������������� ����� (���) - �� - ��������� ��������� ������ ������������ ���-�� ����
             , OverDays   Integer  -- ���-�� ���� ��������� (���)
             , ContractId Integer  -- ������� - ��� ��������� ��������...
             , isErased   Boolean  -- ��������� �� �������
             , isSync     Boolean  -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             SELECT DISTINCT Object_Juridical.Id
                  , Object_Juridical.ObjectCode
                  , Object_Juridical.ValueData
                  , CAST(0.0 AS TFloat) AS DebtSum
                  , CAST(0.0 AS TFloat) AS OverSum
                  , CAST(0 AS Integer) AS OverDays
                  , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                  , Object_Juridical.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Juridical
                  JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                  ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId 
             WHERE Object_Juridical.DescId = zc_Object_Juridical();
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
-- SELECT * FROM gpSelectMobile_Object_Juridical(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
