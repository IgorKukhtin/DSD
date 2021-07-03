-- Function: gpUpdate_Movement_OrderExternal_OperDatePartner()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_OperDatePartner (Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_OperDatePartner(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inFromId              Integer   , --
    IN inOperDate            TDateTime , -- ���� ���.
    IN inOperDatePartner     TDateTime , -- ���� �������� �� ������
    IN inIsAuto              Boolean   , -- TRUE - ������, FALSE - ������ ������ �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- ��������
     IF inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner)
     THEN
         -- inOperDatePartner:= DATE_TRUNC ('DAY', inOperDatePartner);
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     IF inIsAuto = TRUE 
     THEN
         inOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;
     END IF;

     -- ��������� �������� <���� �������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inId, inOperDatePartner);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inIsAuto);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.06.18         *
*/

-- ����
-- 