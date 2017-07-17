-- Function: gpSelectMobile_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_Promo (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_Promo(
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer   -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , InvNumber       TVarChar  -- ����� ���������
             , OperDate        TDateTime -- ���� ���������
             , StatusId        Integer   -- ���� ��������
             , StartSale       TDateTime -- ���� ������ �������� �� ��������� ����
             , EndSale         TDateTime -- ���� ��������� �������� �� ��������� ����
             , isChangePercent Boolean   -- ��������� % ������ �� ��������, *�����* - ���� FALSE, ����� � �������� ����� ������ ChangePercent ������ = 0 
             , CommentMain     TVarChar  -- ���������� (�����)
             , isSync          Boolean   
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
             WITH tmpPromoPartner AS (SELECT Movement_Promo.Id AS PromoId
                                           , Movement_Promo.InvNumber
                                           , Movement_Promo.Operdate
                                           , Movement_Promo.StatusId
                                           , MovementDate_StartSale.ValueData     AS StartSale
                                           , MovementDate_EndSale.ValueData       AS EndSale
                                           , ROW_NUMBER() OVER (PARTITION BY MI_PromoPartner.ObjectId ORDER BY Movement_Promo.Operdate DESC, Movement_PromoPartner.ParentId DESC) AS RowNum
                                      FROM Movement AS Movement_PromoPartner
                                           JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased = FALSE
                                           JOIN lfSelectMobile_Object_Partner (inIsErased:= FALSE, inSession:= inSession) AS OP ON OP.Id = MI_PromoPartner.ObjectId
                                           JOIN Movement AS Movement_Promo 
                                                         ON Movement_Promo.Id = Movement_PromoPartner.ParentId
                                                        AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                            AND MovementDate_StartSale.ValueData <= CURRENT_DATE
                                           JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                                            AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                     )
                , tmpPromo AS (SELECT DISTINCT tmpPromoPartner.PromoId AS Id
                                    , tmpPromoPartner.InvNumber
                                    , tmpPromoPartner.Operdate
                                    , tmpPromoPartner.StatusId
                                    , tmpPromoPartner.StartSale
                                    , tmpPromoPartner.EndSale
                               FROM tmpPromoPartner
                               WHERE tmpPromoPartner.RowNum = 1
                              )
             SELECT tmpPromo.Id
                  , tmpPromo.InvNumber
                  , tmpPromo.Operdate
                  , tmpPromo.StatusId
                  , tmpPromo.StartSale
                  , tmpPromo.EndSale
                  , (MI_Child.ObjectId IS NULL)          AS isChangePercent
                  , MovementString_CommentMain.ValueData AS CommentMain
                  , true::Boolean                        AS isSync  
             FROM tmpPromo
                  LEFT JOIN MovementItem AS MI_Child
                                         ON MI_Child.MovementId = tmpPromo.Id
                                        AND MI_Child.DescId = zc_MI_Child() 
                                        AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- ��� ����� % ������ �� ��������
                                        AND NOT MI_Child.isErased
                  LEFT JOIN MovementString AS MovementString_CommentMain
                                           ON MovementString_CommentMain.MovementId = tmpPromo.Id
                                          AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain() 
             ;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 29.05.17                                                                          *
 16.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_Promo (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
