-- Function: gpUpdate_Movement_FinalSUA_DateOrder()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FinalSUA_DateOrder (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_FinalSUA_DateOrder(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inDateOrder           TDateTime , -- ���� ������� � �����
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_FinalSUA());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF inDateOrder <> DATE_TRUNC ('DAY', inDateOrder)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������.';
     END IF;

     -- ��������� <���� ������� � �����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Order(), inId, inDateOrder);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.08.22                                                       *
 */

-- ����
-- SELECT * FROM gpUpdate_Movement_FinalSUA_DateOrder (inSession:= '2')