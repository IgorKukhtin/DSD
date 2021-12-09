-- Function: gpComplete_Movement_Pretension()

--DROP FUNCTION IF EXISTS gpComplete_Movement_Pretension (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Pretension (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Pretension(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsCurrentData     Boolean               , -- ���� ��������� ������� �� /���
   OUT outOperDate         TDateTime             , --
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS TDateTime
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbParentID Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbChangeIncomePaymentId Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Pretension());

      -- ��������
    IF COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean  AS MovementBoolean_Deferred
                  WHERE MovementBoolean_Deferred.MovementId = inMovementId
                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
    THEN
         RAISE EXCEPTION '������.�������� �������, ���������� ���������!';
    END IF;

      -- ��������� ���������
     SELECT
          Movement.OperDate, Movement.InvNumber, Movement.ParentID
     INTO
          outOperDate, vbInvNumber, vbParentID
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- ���� ��������� ����������� ������ ��������� � ������� �����.
     -- ���� �������� �������� ���-� ������ ����� - ������ ��������������
     IF (outOperDate <> CURRENT_DATE) AND (inIsCurrentData = TRUE)
     THEN
         --RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
        outOperDate:= CURRENT_DATE;
        -- ��������� <��������> c ����� ����� 
        PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_Pretension(), vbInvNumber, outOperDate, vbParentID);
        
/*     ELSE
         IF ((outOperDate <> CURRENT_DATE) OR (outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH')) AND (inIsCurrentData = FALSE)
         THEN
             -- �������� ���� �� ���������� ������ ������
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_Pretension());
         END IF;*/
     END IF;

     -- ��������� ����� ����������� �� ������������� �������, ��� � ��.
     PERFORM lpCheckComplete_Movement_Pretension (inMovementId);
     
      -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_Pretension (inMovementId);
     
     -- ���������� ��������
/*     PERFORM lpComplete_Movement_Pretension(inMovementId, -- ���� ���������
                                           vbUserId);    -- ������������                          
*/
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

       -- �������� � �� ������� �� ����� ������� ���� ����������
     IF COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB 
                   WHERE MB.MovementId = inMovementId 
                     AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
     THEN
         RAISE EXCEPTION '������. �� ����� ���������� �������� ����������.';
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.12.21                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')