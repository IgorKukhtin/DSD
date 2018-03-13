-- Function: gpInsertUpdate_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDI_Send (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI_Send(
 INOUT ioId                    Integer    , -- ���� ������� <�������� ��� �������� � EDI>
    IN inParentId              Integer    , -- �������� - ������� ����������
    IN inDescCode              TVarChar  , --
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbDescId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- �����
     vbDescId := (SELECT Id FROM MovementBooleanDesc WHERE LOWER (Code) = LOWER (inDescCode));
     -- ��������
     IF COALESCE (vbDescId, 0) = 0 THEN
         RAISE EXCEPTION '������.������� �������� ��-�� <��� ��������> = <%>.', inDescCode;
     END IF;


     -- �����
     ioId:=  (SELECT Movement.Id
              FROM Movement
                   INNER JOIN MovementBoolean ON MovementBoolean.MovementId = Movement.Id
                                             AND MovementBoolean.DescId     = vbDescId
                                             AND MovementBoolean.ValueData  = TRUE
              WHERE Movement.ParentId = inParentId
                AND Movement.DescId   = zc_Movement_EDI_Send()
             );


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     IF ioId > 0
     THEN
         -- ������� ������, �� �������� - ������ �� ���������
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = ioId AND StatusId <> zc_Enum_Status_UnComplete();

         -- ��������� �������� <����/����� ���������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);

     ELSE
         -- ��������� <��������>
         ioId := lpInsertUpdate_Movement (ioId, zc_Movement_EDI_Send(), CAST (NEXTVAL (LOWER ('Movement_EDI_Send_seq')) AS TVarChar) , CURRENT_TIMESTAMP, inParentId);

         -- ��������� �������� <��� ��������> - ������ ���� �� ��-� ����� ���������, �.�. ��� ������ �������� ����� ��������� ������
         PERFORM lpInsertUpdate_MovementBoolean (vbDescId, ioId, TRUE);

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.18                                        *

*/
-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI_Send (ioId:= 0, inParentId:= 1, inDescCode:= '', inSession:= '2')
