-- Function: gpInsertUpdate_Movement_ConvertRemains()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ConvertRemains (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ConvertRemains(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- ���� ���������
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   
   DECLARE vbOperDate TDateTime;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ConvertRemains());
     vbUserId := inSession;
	 
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ���������� ���� � ����� ���������
     SELECT Movement.OperDate
          , Movement.InvNumber
     INTO vbOperDate, vbInvNumber
     FROM Movement
     WHERE Movement.Id = ioId;
    
     -- ��������� <��������>
     IF vbIsInsert = TRUE OR vbOperDate <> inOperDate OR vbInvNumber <> inInvNumber
     THEN
       ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ConvertRemains(), inInvNumber, inOperDate, NULL);
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
 */

-- ����
--