-- Function: gpComplete_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpComplete_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TechnicalRediscount(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outOperDate         TDateTime             ,  
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS TDateTime
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbInvNumber TVarChar;  
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TechnicalRediscount());

    -- ��������� ���������
    SELECT
        Movement.OperDate,
        Movement.InvNumber       
    INTO
        outOperDate,
        vbInvNumber
    FROM Movement
    WHERE Movement.Id = inMovementId;

    outOperDate:= CURRENT_DATE;

    -- ��������� <��������> c ����� ����� 
    PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_TechnicalRediscount(), vbInvNumber, outOperDate, NULL);

    -- ���������� ��������
    PERFORM lpComplete_Movement_TechnicalRediscount(inMovementId, -- ���� ���������
                                                    vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
 */