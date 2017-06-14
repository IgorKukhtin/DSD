-- Function: gpSelect_Movement_Promo_Mobile()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Mobile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Mobile(
     IN inJuridicalBasisId  Integer   ,
     IN inMemberId          Integer  , -- ���.����
     IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer   -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , InvNumber       TVarChar  -- ����� ���������
             , OperDate        TDateTime -- ���� ���������
             , StatusId        Integer   -- ���� ��������
             , StatusCode      Integer   -- 
             , StartSale       TDateTime -- ���� ������ �������� �� ��������� ����
             , EndSale         TDateTime -- ���� ��������� �������� �� ��������� ����
             , isChangePercent Boolean   -- ��������� % ������ �� ��������, *�����* - ���� FALSE, ����� � �������� ����� ������ ChangePercent ������ = 0 
             , CommentMain     TVarChar  -- ���������� (�����)
             , isSync          Boolean  
             , ContractCode    Integer
             , ContractName    TVarChar
             , ContractTagName TVarChar
             , PartnerCode     Integer
             , PartnerName     TVarChar
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
                    tmpPromo.Id
                  , tmpPromo.InvNumber
                  , tmpPromo.Operdate
                  , tmpPromo.StatusId
                  , Object_Status.ObjectCode AS StatusCode
                  , tmpPromo.StartSale
                  , tmpPromo.EndSale
                  , tmpPromo.isChangePercent
                  , tmpPromo.CommentMain
                  , tmpPromo.isSync  
                  , Object_Contract.ObjectCode    AS ContractCode
                  , Object_Contract.ValueData     AS ContractName
                  , Object_ContractTag.ValueData  AS ContractTagName
                  , Object_Partner.ObjectCode     AS PartnerCode
                  , Object_Partner.ValueData      AS PartnerName
             FROM gpSelectMobile_Movement_Promo (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS tmpPromo
                 LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpPromo.StatusId
                 LEFT JOIN gpSelectMobile_Movement_PromoPartner (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS tmpPromoPartner ON tmpPromoPartner.MovementId = tmpPromo.Id

                  LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpPromoPartner.ContractId
                  LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpPromoPartner.PartnerId
                  
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                       ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                  LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
            WHERE tmpPromo.isSync = TRUE
            ORDER BY tmpPromo.Id
             ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 29.03.17         *
*/

-- SELECT * FROM gpSelect_Movement_Promo_Mobile (inJuridicalBasisId:= 0, inMemberId:= 0, inSession:= zfCalc_UserAdmin())
