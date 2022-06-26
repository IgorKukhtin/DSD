-- Function: gpInsertUpdate_Movement_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsSPSearch_1303 (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsSPSearch_1303(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDateStart       TDateTime , --
    IN inOperDateEnd         TDateTime , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsSPSearch_1303());
     vbUserId := inSession;
	 
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_GoodsSPSearch_1303(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.05.22                                                       *
 */

-- ����
--