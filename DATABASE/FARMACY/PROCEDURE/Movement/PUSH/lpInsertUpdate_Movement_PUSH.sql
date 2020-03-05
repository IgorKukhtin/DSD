-- Function: lpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TDateTime, Integer, Boolean, TBlob, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PUSH(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inDateEndPUSH           TDateTime  ,
    IN inReplays               Integer    , -- ���������� ��������  
    IN inDaily                 Boolean    , -- ����. ���������
    IN inMessage               TBlob      , -- ���������
    IN inFunction              TVarChar   , -- �������
    IN inisPoll                Boolean    , -- �����
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PUSH(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Message(), ioId, inMessage);

    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Replays(), ioId, inReplays);

    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PUSHDaily(), ioId, inDaily);

    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Poll(), ioId, inisPoll);

    -- ��������� �������� <�������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Function(), ioId, inFunction);

    -- ��������� �������� <���� ���������>
    IF inDateEndPUSH > inOperDate
    THEN
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateEndPUSH(), ioId, inDateEndPUSH);
    END IF;

    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 05.03.20        *
 19.02.20        *
 11.05.19        *
 15.10.18        *
 11.09.18        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_PUSH (ioId:= 0, inOperDate:= '01.09.2018', inSession:= '3')