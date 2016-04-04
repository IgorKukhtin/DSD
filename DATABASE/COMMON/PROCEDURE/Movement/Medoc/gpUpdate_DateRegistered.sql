-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_DateRegistered (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_DateRegistered(
    IN inMovementId_Tax          Integer   , -- ���� ������� <��������>
    IN inMovementId_Corrective   Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_...());
   vbUserId:= lpGetUserBySession(inSession);


   -- ��������� "������� ����", ������ "�����������" - ���� ��� ���� � ��� ��� ������ ������� ����������� (�.�. ����������� �����)
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
   FROM (SELECT inMovementId_Tax AS MovementId WHERE inMovementId_Tax <> 0 AND COALESCE (inMovementId_Corrective, 0) = 0
        UNION 
         SELECT inMovementId_Corrective AS MovementId WHERE inMovementId_Corrective <> 0
        ) AS tmp
        LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                 AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
   WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
   ;

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (tmp.MovementId, vbUserId, FALSE)
   FROM (SELECT inMovementId_Tax AS MovementId WHERE inMovementId_Tax <> 0 AND COALESCE (inMovementId_Corrective, 0) = 0
        UNION 
         SELECT inMovementId_Corrective AS MovementId WHERE inMovementId_Corrective <> 0
        ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.16                                        * 
*/

-- ����
-- SELECT * FROM gpUpdate_DateRegistered (ioId:= 0, inSession:= '2')
