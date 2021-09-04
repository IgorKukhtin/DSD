-- Function: gpSelect_Movement_PromoInvoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoInvoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoInvoice(
    IN inMovementId    Integer , -- ���� ��������� <�����>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id                Integer
             , ParentId          Integer
             , OperDate          TDateTime
             , Invnumber         TVarChar
             , InvnumberPartner         TVarChar
             , BonusKindId        Integer 
             , BonusKindCode      Integer 
             , BonusKindName      TVarChar
             , PaidKindId       Integer  
             , PaidKindCode     Integer  
             , PaidKindName     TVarChar 
             , TotalSumm        TFloat 
             , Comment          TVarChar
             , isErased         Boolean
             , StatusId         Integer
             , StatusCode       Integer
             , StatusName       TVarChar
             , InsertName       TVarChar
             , InsertDate       TDateTime
             , UpdateName       TVarChar
             , UpdateDate       TDateTime
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT Movement_PromoInvoice.Id
             , Movement_PromoInvoice.ParentId             --������ �� �������� �������� <�����> (zc_Movement_Promo)
             , Movement_PromoInvoice.OperDate
             , Movement_PromoInvoice.Invnumber
             , Movement_PromoInvoice.InvnumberPartner

             , Movement_PromoInvoice.BonusKindId
             , Movement_PromoInvoice.BonusKindCode
             , Movement_PromoInvoice.BonusKindName

             , Movement_PromoInvoice.PaidKindId
             , Movement_PromoInvoice.PaidKindCode
             , Movement_PromoInvoice.PaidKindName

             , Movement_PromoInvoice.TotalSumm
             , Movement_PromoInvoice.Comment

             , Movement_PromoInvoice.isErased           --������
             , Movement_PromoInvoice.StatusId           --�� �������
             , Movement_PromoInvoice.StatusCode         --��� �������
             , Movement_PromoInvoice.StatusName         --������

             , Movement_PromoInvoice.InsertName
             , Movement_PromoInvoice.InsertDate
             , Movement_PromoInvoice.UpdateName
             , Movement_PromoInvoice.UpdateDate
        FROM Movement_PromoInvoice_View AS Movement_PromoInvoice
        WHERE Movement_PromoInvoice.ParentId = inMovementId
            AND(Movement_PromoInvoice.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.21         *
*/