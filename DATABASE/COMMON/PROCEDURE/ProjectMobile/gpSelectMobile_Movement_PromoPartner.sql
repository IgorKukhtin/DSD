-- Function: gpSelectMobile_Movement_PromoPartner()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_PromoPartner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_PromoPartner(
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id         Integer -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , MovementId Integer -- ���������� ������������� ���������
             , ContractId Integer -- ��������
             , PartnerId  Integer -- ����������
             , isSync     Boolean 
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
             SELECT DISTINCT
                    Movement_PromoPartner.Id
                  , Movement_PromoPartner.ParentId                                AS MovementId
                  , COALESCE (MILinkObject_Contract.ObjectId, 0) :: Integer       AS ContractId
                  , MI_PromoPartner.ObjectId                                      AS PartnerId
                  , TRUE :: Boolean                                               AS isSync
             FROM Movement AS Movement_PromoPartner
                  -- JOIN MovementLinkObject AS MovementLinkObject_Partner
                  --                         ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                  --                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                  INNER JOIN MovementItem AS MI_PromoPartner
                                          ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                         AND MI_PromoPartner.DescId     = zc_MI_Master()
                                         AND MI_PromoPartner.IsErased   = FALSE
                  JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                  ON ObjectLink_Partner_PersonalTrade.ObjectId      = MI_PromoPartner.ObjectId -- MovementLinkObject_Partner.ObjectId 
                                 AND ObjectLink_Partner_PersonalTrade.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                  -- LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                  --                              ON MovementLinkObject_Contract.MovementId = Movement_PromoPartner.Id
                  --                             AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract() 
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                   ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                                  AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                  JOIN Movement AS Movement_Promo
                                ON Movement_Promo.Id = Movement_PromoPartner.ParentId
                               -- AND Movement_Promo.DescId = zc_Movement_Promo()
                               AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                  JOIN MovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement_PromoPartner.ParentId
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                   AND MovementDate_StartSale.ValueData <= CURRENT_DATE
                  JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement_PromoPartner.ParentId
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                   AND MovementDate_EndSale.ValueData >= CURRENT_DATE
             WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
               -- AND Movement_PromoPartner.ParentId IS NOT NULL
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
              ;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_PromoPartner (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
