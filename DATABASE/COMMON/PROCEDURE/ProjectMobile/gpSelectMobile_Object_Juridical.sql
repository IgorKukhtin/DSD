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
             WITH tmpJuridical AS (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                   FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                        JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                     AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                  )
                , tmpDebt AS (SELECT tmpJuridical.JuridicalId
                                   , ContainerLinkObject_Contract.ObjectId AS ContractId 
                                   , SUM (Container_Summ.Amount)::TFloat AS Amount
                              FROM Container AS Container_Summ
                                   JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                   ON ObjectLink_Account_AccountGroup.ObjectId = Container_Summ.ObjectId
                                                  AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup() 
                                                  AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- ��������
                                   JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                            ON ContainerLinkObject_Juridical.ContainerId = Container_Summ.Id
                                                           AND ContainerLinkObject_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                   JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                            ON ContainerLinkObject_Contract.ContainerId = Container_Summ.Id
                                                           AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                                   JOIN tmpJuridical ON tmpJuridical.JuridicalId = ContainerLinkObject_Juridical.ObjectId
                              WHERE Container_Summ.DescId = zc_Container_Summ()
                                AND Container_Summ.Amount <> 0.0
                              GROUP BY tmpJuridical.JuridicalId
                                     , ContainerLinkObject_Contract.ObjectId 
                             )
             SELECT Object_Juridical.Id
                  , Object_Juridical.ObjectCode
                  , Object_Juridical.ValueData
                  , COALESCE (tmpDebt.Amount, 0.0)::TFloat AS DebtSum
                  , CAST(0.0 AS TFloat)                    AS OverSum
                  , CAST(0 AS Integer)                     AS OverDays
                  , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                  , Object_Juridical.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Juridical
                  JOIN tmpJuridical ON tmpJuridical.JuridicalId = Object_Juridical.Id 
                  JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  LEFT JOIN tmpDebt ON tmpDebt.JuridicalId = Object_Juridical.Id
                                   AND tmpDebt.ContractId = ObjectLink_Contract_Juridical.ObjectId
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
