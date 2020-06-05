-- Function: gpUpdate_Movement_TransportService_SummReestr ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportService_SummReestr (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportService_SummReestr(
    IN inId                       Integer   , --
    IN inMIId                     Integer   , -- ���� ������� <�������� ����� ���������>
    IN inSummReestr               TFloat    , -- ����� ��������, ���
    IN inSession                  TVarChar    -- ������ ������������

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbisSummReestr Boolean;
   DECLARE vbSummReestr   TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportService());


     -- 
     IF COALESCE (inSummReestr, 0) <> 0
     THEN
          -- ��������� ��-��
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SummReestr(), inMIId, FALSE);
          -- ��������� ��-��
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), inMIId, inSummReestr);
     ELSE
          -- ��������� ��-��
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SummReestr(), inMIId, TRUE);

          --������������ � ��������� ��-�� ����� �������� �� ������� ���������
          vbSummReestr := COALESCE ((SELECT SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS vbSummReestr
                                     FROM MovementLinkMovement
                                          INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement.MovementId
                                          JOIN MovementFloat AS MovementFloat_MovementItemId
                                                             ON MovementFloat_MovementItemId.ValueData ::Integer = MovementItem.Id
                                                            AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                          JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                     WHERE MovementLinkMovement.MovementChildId = inId
                                       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport() )
                                    ,0) ::TFloat;
          
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummReestr(), inMIId, vbSummReestr );

     END IF;

     -- ��������� ��������
     --PERFORM lpInsert_MovementProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.20         *
*/

-- ����
--