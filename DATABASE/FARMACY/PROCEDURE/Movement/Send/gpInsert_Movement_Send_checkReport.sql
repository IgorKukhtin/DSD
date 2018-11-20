DROP FUNCTION IF EXISTS gpInsert_Movement_Send_checkReport (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_checkReport(
    IN inStartSale           TDateTime , -- ���� ������ ������
    IN inEndSale             TDateTime , -- ���� ��������� ������
    IN inFromId              Integer   , -- �� ����
    IN inToId                Integer   , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
      vbUserId := inSession;

      -- ���� �� ��������� (���� - �������������, ���. �����. ������)
      SELECT tmp.Id
      INTO vbMovementId_ReportUnLiquid
      FROM (SELECT Movement.Id  
                 , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
            FROM Movement
              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.ID
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                           AND MovementLinkObject_Unit.ObjectId = inFromId
              INNER JOIN MovementDate AS MovementDate_StartSale
                                      ON MovementDate_StartSale.MovementId = Movement.Id
                                     AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                     AND MovementDate_StartSale.ValueData = inStartSale
              INNER JOIN MovementDate AS MovementDate_EndSale
                                      ON MovementDate_EndSale.MovementId = Movement.Id
                                     AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                     AND MovementDate_EndSale.ValueData = inEndSale
            WHERE Movement.DescId = zc_Movement_ReportUnLiquid() 
              AND Movement.StatusId <> zc_Enum_Status_Erased()
           ) AS tmp
      WHERE tmp.Ord = 1;
        
         
      IF COALESCE (vbMovementId_ReportUnLiquid, 0) = 0 THEN
         RAISE EXCEPTION '����������� �� ����� ���� �������. �������� <����� �� ������������ ������> �� ��������.';
      END IF;


      -- ���� �� ��������� ����������� (���� - ����, �� ����, ����, ������ �������������)
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                  AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
 
        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     AND MovementLinkObject_From.ObjectId = inFromId

        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                     AND MovementLinkObject_To.ObjectId = inToId

      WHERE Movement.DescId = zc_Movement_Send() AND Movement.OperDate = inEndSale
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0 
      THEN
         -- ���������� ����� <��������>
         vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                     , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                     , inOperDate         := inEndSale
                                                     , inFromId           := inFromId
                                                     , inToId             := inToId
                                                     , inComment          := '' :: TVarChar
                                                     , inChecked          := FALSE
                                                     , inUserId           := vbUserId
                                                     );
  
         -- ��������� ����� � <�������� ����� �� ������������ ������>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReportUnLiquid(), vbMovementId, vbMovementId_ReportUnLiquid);
      END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/
--