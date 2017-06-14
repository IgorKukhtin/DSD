-- Function: gpSelect_Movement_PromoPartner_Mobile()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoPartner_Mobile (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PromoPartner_Mobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoPartner_Mobile(
    IN inMovementId Integer  , -- 
    IN inMemberId   Integer  , -- 
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id           Integer -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , MovementId   Integer -- ���������� ������������� ���������
             , ContractId   Integer -- ��������
             , ContractCode Integer -- ��������
             , ContractName TVarChar -- ��������
             , PartnerId    Integer -- ����������
             , PartnerCode  Integer -- ����������
             , PartnerName  TVarChar -- ����������
             , JuridicalId   Integer -- ��.����
             , JuridicalCode Integer -- ��.����
             , JuridicalName TVarChar -- ��.����
             , RetailId      Integer --
             , RetailName    TVarChar -- 
             , ContractTagId   Integer -- ��.����
             , ContractTagCode Integer -- ��.����
             , ContractTagName TVarChar -- ��.����
             , isSync          Boolean 
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ ��������!!! - � ������ ����������� ������������ ����� ������������� ������ � ���������� ����������
     vbUserId_Mobile:= (SELECT CASE WHEN lfGet.UserId > 0 THEN lfGet.UserId ELSE vbUserId END FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);

     -- ���������
     RETURN QUERY
             SELECT DISTINCT
                    tmpPromoPartner.Id
                  , tmpPromoPartner.MovementId
                  , tmpPromoPartner.ContractId
                  , Object_Contract.ObjectCode   AS ContractCode
                  , Object_Contract.ValueData    AS ContractName
                  , tmpPromoPartner.PartnerId
                  , Object_Partner.ObjectCode    AS PartnerCode
                  , Object_Partner.ValueData     AS PartnerName

                  , Object_Juridical.Id          AS JuridicalId
                  , Object_Juridical.ObjectCode  AS JuridicalCode
                  , Object_Juridical.ValueData   AS JuridicalName

                  , Object_Retail.Id                AS RetailId
                  , Object_Retail.ValueData         AS RetailName

                  , Object_ContractTag.Id         AS ContractTagId
                  , Object_ContractTag.ObjectCode AS ContractTagCode
                  , Object_ContractTag.ValueData  AS ContractTagName

                  , tmpPromoPartner.isSync
             FROM gpSelectMobile_Movement_PromoPartner (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS tmpPromoPartner
                  LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpPromoPartner.ContractId
                  LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpPromoPartner.PartnerId
                  
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                       ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                  LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

             WHERE tmpPromoPartner.isSync = TRUE
               AND tmpPromoPartner.MovementId = inMovementId 
          ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 13.06.17         * add inMemberId
 29.03.17         *
*/

-- SELECT * FROM gpSelect_Movement_PromoPartner_Mobile (inMovementId:= 0, inMemberId:= 0, inSession:= zfCalc_UserAdmin())
