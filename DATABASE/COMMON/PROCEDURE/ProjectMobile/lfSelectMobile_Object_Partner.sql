-- Function: lfSelectMobile_Object_Partner (Boolean, TVarChar)

DROP FUNCTION IF EXISTS lfSelectMobile_Object_Partner (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lfSelectMobile_Object_Partner (
    IN inIsErased Boolean,
    IN inSession  TVarChar   -- ������ ������������
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer  -- ���
             , ValueData        TVarChar -- ��������
             , JuridicalId      Integer  -- ����������� ����
             , isErased         Boolean  -- ��������� �� �������
              )
AS
$BODY$
   DECLARE vbPersonalId Integer;
BEGIN
      -- ���������� ���������� ��� ������������
      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpPartner AS (-- ���� vbPersonalId - ��������� (��������)
                                 SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
                                 FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 UNION
                                 -- ���� vbPersonalId - ��������� (�����������)
                                 SELECT ObjectLink_Partner_Personal.ObjectId AS PartnerId
                                 FROM ObjectLink AS ObjectLink_Partner_Personal
                                 WHERE ObjectLink_Partner_Personal.ChildObjectId = vbPersonalId
                                   AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                                )
                , tmpIsErased AS (SELECT FALSE AS isErased UNION SELECT inIsErased AS isErased)
             SELECT Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                  , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0)::Integer AS JuridicalId
                  , Object_Partner.isErased 
             FROM tmpPartner
                  JOIN Object AS Object_Partner
                              ON Object_Partner.Id = tmpPartner.PartnerId
                             AND Object_Partner.DescId = zc_Object_Partner() 
                  JOIN tmpIsErased ON tmpIsErased.isErased = Object_Partner.isErased
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.PartnerId
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 14.06.17                                                        *
*/

-- ����
-- SELECT * FROM lfSelectMobile_Object_Partner (inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
