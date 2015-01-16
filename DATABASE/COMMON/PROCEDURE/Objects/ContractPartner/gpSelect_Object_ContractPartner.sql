-- Function: gpSelect_Object_ContractPartner (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartner (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartner(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractPartner());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_ContractPartner.Id          AS Id
           , Object_ContractPartner.ObjectCode  AS Code
         
           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS ContractName

           , Object_Partner.Id         AS PartnerId
           , Object_Partner.ValueData  AS PartnerName
         
           , Object_ContractPartner.isErased    AS isErased
           
       FROM Object AS Object_ContractPartner
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_ContractPartner.AccessKeyId
                                                            
            LEFT JOIN ObjectLink AS ContractPartner_Contract
                                 ON ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                AND ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ContractPartner_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                 ON ObjectLink_ContractPartner_Partner.ObjectId = Object_ContractPartner.Id
                                AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId
            
     WHERE Object_ContractPartner.DescId = zc_Object_ContractPartner()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartner(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.15          * 
        
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractPartner (zfCalc_UserAdmin())