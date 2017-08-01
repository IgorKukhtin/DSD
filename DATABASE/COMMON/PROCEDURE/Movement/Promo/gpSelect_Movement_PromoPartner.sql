-- Function: gpSelect_Movement_PromoPartner()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoPartner (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoPartner(
    IN inMovementId    Integer , -- ���� ��������� <�����>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , PartnerId        Integer     --���������� ��� �����
             , PartnerCode      Integer     --���������� ��� �����
             , PartnerName      TVarChar    --���������� ��� �����
             , PartnerDescId    Integer     --��� ���������� ��� �����
             , PartnerDescName  TVarChar    --��� ���������� ��� �����
             , Juridical_Name   TVarChar    --������
             , Retail_Name      TVarChar    --����
             , RetailName_inf   TVarChar    --����. ���� ���.
             , ContractId       Integer     --�� ���������
             , ContractCode     Integer     --��� ���������
             , ContractName     TVarChar    --�������� ���������
             , ContractTagName  TVarChar    --������� ��������
             , Comment          TVarChar    --����������
             , AreaName         TVarChar    --������
             , isErased         Boolean     --������
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT
            Movement_PromoPartner.Id                  --�������������
          , Movement_PromoPartner.PartnerId           --���������� ��� �����
          , Movement_PromoPartner.PartnerCode::Integer--���������� ��� �����
          , Movement_PromoPartner.PartnerName         --���������� ��� �����
          , Movement_PromoPartner.PartnerDescId       --��� ���������� ��� �����
          , Movement_PromoPartner.PartnerDescName     --��� ���������� ��� �����
          , Movement_PromoPartner.Juridical_Name      --������
          , Movement_PromoPartner.Retail_Name         --����
          , Movement_PromoPartner.RetailName_inf      --����. ���� ���.
          , Movement_PromoPartner.ContractId          --�� ���������
          , Movement_PromoPartner.ContractCode        --��� ���������
          , Movement_PromoPartner.ContractName        --�������� ���������
          , Movement_PromoPartner.ContractTagName     --������� �������� 
          , Movement_PromoPartner.Comment             --����������
          , Movement_PromoPartner.AreaName            --������
          , Movement_PromoPartner.isErased            --������
        FROM
            Movement_PromoPartner_View AS Movement_PromoPartner
        WHERE
            Movement_PromoPartner.ParentId = inMovementId
            AND
            (
                Movement_PromoPartner.isErased = FALSE
                OR
                inIsErased = TRUE
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PromoPartner (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 01.08.17         * add RetailName_inf
 17.11.15                                                                        *Contract
 05.11.15                                                                        *
*/