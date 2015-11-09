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
 05.11.15                                                                        *
*/