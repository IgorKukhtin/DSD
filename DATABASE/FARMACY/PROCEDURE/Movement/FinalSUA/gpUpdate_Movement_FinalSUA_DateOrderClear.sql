-- Function: gpUpdate_Movement_FinalSUA_DateOrderClear()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FinalSUA_DateOrderClear (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_FinalSUA_DateOrderClear(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
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

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������.';
     END IF;

     IF NOT EXISTS(SELECT * 
                   FROM MovementDate AS MovementDate_DateOrder
                   WHERE MovementDate_DateOrder.MovementId = inId
                     AND MovementDate_DateOrder.DescId = zc_MovementDate_Order()
                     AND MovementDate_DateOrder.ValueData IS NOT NULL)
     THEN
         RETURN;
     END IF;

     -- ��������� <���� ������� � �����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Order(), inId, Null);

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
-- SELECT * FROM gpUpdate_Movement_FinalSUA_DateOrderClear (inSession:= '2')