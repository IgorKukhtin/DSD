-- Function: gpSelect_Movement_PromoAdvertising()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoAdvertising (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoAdvertising(
    IN inMovementId    Integer , -- ���� ��������� <�����>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , AdvertisingId    Integer     --��������� ���������
             , AdvertisingCode  Integer     --��������� ���������
             , AdvertisingName  TVarChar    --��������� ���������
             , Comment          TVarChar    --����������
             , isErased         Boolean     --������
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT
            Movement_PromoAdvertising.Id                  --�������������
          , Movement_PromoAdvertising.AdvertisingId           --���������� ��� �����
          , Movement_PromoAdvertising.AdvertisingCode::Integer--���������� ��� �����
          , Movement_PromoAdvertising.AdvertisingName         --���������� ��� �����
          , Movement_PromoAdvertising.Comment             --����������
          , Movement_PromoAdvertising.isErased            --������
        FROM
            Movement_PromoAdvertising_View AS Movement_PromoAdvertising
        WHERE
            Movement_PromoAdvertising.ParentId = inMovementId
            AND
            (
                Movement_PromoAdvertising.isErased = FALSE
                OR
                inIsErased = TRUE
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PromoAdvertising (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 17.11.15                                                                        *Contract
 05.11.15                                                                        *
*/