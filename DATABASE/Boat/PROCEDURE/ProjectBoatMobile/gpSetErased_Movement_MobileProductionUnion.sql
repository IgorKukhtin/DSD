-- Function: gpSetErased_Movement_MobileProductionUnion (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MobileProductionUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MobileProductionUnion(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outStatusCode       Integer               , 
   OUT outStatusName       TVarChar              ,
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ������� ��������
    PERFORM gpSetErased_Movement_ProductionUnion (inMovementId  := inMovementId
                                                , inSession     := inSession);
                                                
    SELECT Object_Status.ObjectCode            AS StatusCode
         , Object_Status.ValueData             AS StatusName
    INTO outStatusCode, outStatusName
    FROM Movement

         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         
    WHERE Movement.Id = inMovementId;                                                

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.04.24                                                       *
*/