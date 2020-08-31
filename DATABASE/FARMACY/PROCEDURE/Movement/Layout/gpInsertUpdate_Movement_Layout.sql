-- Function: gpInsertUpdate_Movement_Layout()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Layout (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Layout(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inLayoutId            Integer   , -- �������� ��������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� �� ������ ��������� ��� ������� ������������ �������� � ���� ������� �� ����� ����� ������� �� ��� ���� ������ ��������� ������������ ���� ���� �����
     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Layout
                                                   ON MovementLinkObject_Layout.MovementId = Movement.Id
                                                  AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
                                                  AND MovementLinkObject_Layout.ObjectId = inLayoutId
                WHERE Movement.DescId = zc_Movement_Layout()
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                  AND Movement.Id <> ioId)
     THEN
          RAISE EXCEPTION '������.�������� ��� �������� <%> ��� ����������.', lfGet_Object_ValueData (inLayoutId);
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Layout (ioId           := ioId
                                           , inInvNumber    := inInvNumber
                                           , inOperDate     := inOperDate
                                           , inLayoutId     := inLayoutId
                                           , inComment      := inComment
                                           , inUserId       := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.20         *
 */

-- ����
--