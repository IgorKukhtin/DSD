-- Function: gpUpdate_Status_Sale()

DROP FUNCTION IF EXISTS gpUpdate_Status_Sale (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Sale(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
   OUT outisDeferred         boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS boolean AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Sale (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Sale (inMovementId,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Sale (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
     outisDeferred := COALESCE ((SELECT ValueData FROM MovementBoolean 
                                 WHERE MovementId = inMovementId
                                   AND DescId = zc_MovementBoolean_Deferred()), FALSE);     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 04.08.19                                                                                     *
 13.10.15                                                                      *
 */