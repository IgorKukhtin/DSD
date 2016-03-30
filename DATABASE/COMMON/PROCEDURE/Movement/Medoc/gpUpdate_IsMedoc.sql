-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_...());
   vbUserId:= lpGetUserBySession(inSession);

   -- ��������� - �������� � ����� ������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Medoc(), inMovementId, TRUE);

   -- ��������� "������� ����", ������ "�����������" - ���� � ��� ��� ������ ������� ����������� (�.�. ����������� �����)
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
   FROM (SELECT inMovementId AS MovementId) AS tmp
        LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                 AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
   WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
   ;

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.03.16                                        * 
 15.12.14                         * 
*/

-- ����
-- SELECT * FROM gpUpdate_IsMedoc (ioId:= 0, inSession:= '2')
