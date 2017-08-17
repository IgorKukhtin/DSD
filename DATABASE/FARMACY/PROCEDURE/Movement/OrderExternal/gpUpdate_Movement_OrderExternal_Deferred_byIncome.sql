-- Function: gpUpdate_Movement_OrderExternal_Deferred_byIncome()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_Deferred_byIncome (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_Deferred_byIncome(
    IN inMovementId          Integer              , -- ���� ��������� ������
    IN inSession             TVarChar               -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId     Integer;
  DECLARE vbToId            Integer;
  DECLARE vbOperDate_Branch TDateTime;
  DECLARE vbOrderId         Integer;
  DECLARE vbisDeferred      Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;
     
     -- ���������� �� ����, ����, ���� ������
     SELECT MLO_From.ObjectId   AS JuridicalId
          , MLO_To.ObjectId     AS ToId
          , MD_Branch.ValueData AS OperDate_Branch
            INTO vbJuridicalId, vbToId, vbOperDate_Branch
     FROM MovementLinkObject AS MLO_From 
          LEFT JOIN MovementLinkObject AS MLO_To
                                       ON MLO_To.MovementId = inMovementId
                                      AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MD_Branch
                                 ON MD_Branch.MovementId = inMovementId
                                AND MD_Branch.DescId = zc_MovementDate_Branch()    
     WHERE MLO_From.MovementId = inMovementId 
       AND MLO_From.DescId = zc_MovementLinkObject_From();

   
     -- - ����� ����� �� ����������, ����������� � ����� �������
        SELECT MLM.MovementChildId 
             , COALESCE (MB_Deferred.ValueData, False) AS isDeferred
      INTO vbOrderId, vbisDeferred
        FROM MovementLinkMovement AS MLM 
             LEFT JOIN MovementBoolean AS MB_Deferred
                    ON MB_Deferred.MovementId = MLM.MovementChildId
                   AND MB_Deferred.DescId = zc_MovementBoolean_Deferred()
        WHERE MLM.descid = zc_MovementLinkMovement_Order()
          AND MLM.MovementId = inMovementId; 
    
     -- � ��������� ������ ������ ������ �������� �� �� �������
     IF COALESCE (vbOrderId, 0) <> 0 AND vbisDeferred = TRUE 
     THEN
         -- C�������� �������� <�������> ���
         PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), vbOrderId, FALSE);
         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (vbOrderId, vbUserId, FALSE);
     END IF;
     
     -- ��������� ������� � ���� ������ � ���� ����� �� ���� �������
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), Movement.Id, FALSE)            -- ��������� �������� �������  ���
           , lpInsert_MovementProtocol (Movement.Id, vbUserId, FALSE)                                     -- ��������� ��������
     FROM Movement
          INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                    AND MovementBoolean_Deferred.ValueData = TRUE

          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      AND MovementLinkObject_From.ObjectId = vbJuridicalId

          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      AND MovementLinkObject_To.ObjectId = vbToId
     WHERE Movement.DescId   = zc_Movement_OrderExternal()
       AND Movement.OperDate < vbOperDate_Branch
       AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.08.17         * 
*/

-- ����
