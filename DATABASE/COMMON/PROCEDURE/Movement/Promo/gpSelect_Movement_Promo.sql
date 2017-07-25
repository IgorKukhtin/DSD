-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inJuridicalBasisId  Integer ,
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
             , EndReturn        TDateTime   --���� ��������� ��������� �� ��������� ����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , MonthPromo       TDateTime   --����� �����
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
             , ChangePercentName TVarChar    -- ������ �� ��������
             , isPromo          Boolean     --����� (��/���)
             , Checked          Boolean     --����������� (��/���)
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
          , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusCode ELSE Movement_Promo.StatusCode END :: Integer  AS StatusCode
          , CASE WHEN Movement_PromoPartner.StatusId = zc_Enum_Status_Erased() THEN Movement_PromoPartner.StatusName ELSE Movement_Promo.StatusName END :: TVarChar AS StatusName
          , Movement_Promo.PromoKindId        --��� �����
          , Movement_Promo.PromoKindName      --��� �����
          , Movement_Promo.PriceListId        --���� �����
          , Movement_Promo.PriceListName      --���� �����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.EndReturn          --���� ��������� ��������� �� ��������� ����
          , Movement_Promo.OperDateStart      --���� ������ ����. ������ �� �����
          , Movement_Promo.OperDateEnd        --���� ��������� ����. ������ �� �����
          , Movement_Promo.MonthPromo         -- ����� �����
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
          , COALESCE (Object_ChangePercent.ValueData, '��')    :: TVarChar AS ChangePercentName
          
          , Movement_Promo.isPromo            --�����
          , Movement_Promo.Checked            --�����������
        FROM
            Movement_Promo_View AS Movement_Promo
            INNER JOIN tmpStatus ON Movement_Promo.StatusId = tmpStatus.StatusId
            LEFT JOIN Movement_PromoPartner_View AS Movement_PromoPartner
                                                 ON Movement_PromoPartner.ParentId = Movement_Promo.Id
                                                AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementItem AS MI_Child
                                   ON MI_Child.MovementId = Movement_Promo.Id
                                  AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- ��� ����� % ������ �� ��������
                                  AND MI_Child.isErased   = FALSE
            LEFT JOIN Object AS Object_ChangePercent ON Object_ChangePercent.Id = MI_Child.ObjectId
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
--ALTER FUNCTION gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 25.07.17         *
 05.10.16         * add inJuridicalBasisId
 27.11.15                                                                        *inPeriodForOperDate
 17.11.15                                                                        *Movement_PromoPartner_View
 13.10.15                                                                        *
*/

-- SELECT * FROM gpSelect_Movement_Promo (inStartDate:= '01.11.2016', inEndDate:= '30.11.2016', inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
