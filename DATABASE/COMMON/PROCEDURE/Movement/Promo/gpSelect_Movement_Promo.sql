-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        Integer     --����� ���������
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������
             , PromoKindId      Integer     --��� �����
             , PromoKindName    TVarChar    --��� �����
             , PriceListId      Integer     --����� ����
             , PriceListName    TVarChar    --����� ����
             , StartPromo       TDateTime   --���� ������ �����
             , EndPromo         TDateTime   --���� ��������� �����
             , StartSale        TDateTime   --���� ������ �������� �� ��������� ����
             , EndSale          TDateTime   --���� ��������� �������� �� ��������� ����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , CostPromo        TFloat      --��������� ������� � �����
             , Comment          TVarChar    --����������
             , CommentMain      TVarChar    --���������� (�����)
             , UnitId           Integer     --�������������
             , UnitName         TVarChar    --�������������
             , PersonalTradeId  Integer     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������
             , PersonalId       Integer     --������������� ������������� �������������� ������	
             , PersonalName     TVarChar    --������������� ������������� �������������� ������	
             , PartnerName      TVarChar     --�������
             , PartnerDescName  TVarChar     --��� ��������
             , ContractName     TVarChar     --� ��������
             , ContractTagName  TVarChar     --������� ��������
             , isFirst          Boolean      --������ �������� � ������ (��� ������������� ������)
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        SELECT
            Movement_Promo.Id                 --�������������
          , Movement_Promo.InvNumber          --����� ���������
          , Movement_Promo.OperDate           --���� ���������
          , Movement_Promo.StatusCode         --��� �������
          , Movement_Promo.StatusName         --������
          , Movement_Promo.PromoKindId        --��� �����
          , Movement_Promo.PromoKindName      --��� �����
          , Movement_Promo.PriceListId        --���� �����
          , Movement_Promo.PriceListName      --���� �����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.OperDateStart      --���� ������ ����. ������ �� �����
          , Movement_Promo.OperDateEnd        --���� ��������� ����. ������ �� �����
          , Movement_Promo.CostPromo          --��������� ������� � �����
          , Movement_Promo.Comment            --����������
          , Movement_Promo.CommentMain        --���������� (�����)
          , Movement_Promo.UnitId             --�������������
          , Movement_Promo.UnitName           --�������������
          , Movement_Promo.PersonalTradeId    --������������� ������������� ������������� ������
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalId         --������������� ������������� �������������� ������	
          , Movement_Promo.PersonalName       --������������� ������������� �������������� ������	
          , Movement_PromoPartner.PartnerName     --�������
          , Movement_PromoPartner.PartnerDescName --��� ��������
          , Movement_PromoPartner.ContractName --�������� ���������
          , Movement_PromoPartner.ContractTagName --������� �������� 
          , CASE
                WHEN (ROW_NUMBER() OVER(PARTITION BY Movement_Promo.Id ORDER BY Movement_PromoPartner.Id)) = 1
                    THEN TRUE
            ELSE FALSE
            END as IsFirst
        FROM
            Movement_Promo_View AS Movement_Promo
            INNER JOIN tmpStatus ON Movement_Promo.StatusId = tmpStatus.StatusId
            Left Outer Join Movement_PromoPartner_View AS Movement_PromoPartner
                                                       ON Movement_PromoPartner.ParentId = Movement_Promo.ID
        WHERE
            (
                inPeriodForOperDate = TRUE
                AND
                Movement_Promo.OperDate BETWEEN inStartDate AND inEndDate
            )
            OR
            (
                inPeriodForOperDate = FALSE
                AND
                (
                    Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                    OR
                    inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
                )
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 27.11.15                                                                        *inPeriodForOperDate
 17.11.15                                                                        *Movement_PromoPartner_View
 13.10.15                                                                        *
*/