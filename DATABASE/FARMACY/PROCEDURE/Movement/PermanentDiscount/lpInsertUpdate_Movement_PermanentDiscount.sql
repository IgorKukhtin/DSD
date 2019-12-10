-- Function: lpInsertUpdate_Movement_PermanentDiscount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PermanentDiscount (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PermanentDiscount(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inRetailId            Integer   , -- �������������
    IN inStartPromo          TDateTime , -- ���� ������ ���������
    IN inEndPromo            TDateTime , -- ���� ��������� ���������
    IN inChangePercent       TFloat    , -- ������� ������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PermanentDiscount());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PermanentDiscount(), inInvNumber, inOperDate, NULL, 0);

      -- ��������� <>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

      -- ��������� <>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

      -- ��������� <����������>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

      -- ��������� �������� <>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

      IF vbIsInsert = True
      THEN
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
      ELSE
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
      END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.12.19                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_PermanentDiscount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticlePermanentDiscountId:= 1, inSession:= '3')
