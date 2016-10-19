-- Function: gpInsertUpdate_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ConfirmedKind (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ConfirmedKind(
    IN inMovementId         Integer  , -- 
    IN inisComplete         Boolean  , --
   OUT outConfirmedKindName TVarChar , -- 
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbConfirmedKindId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inisComplete = TRUE 
       THEN
           vbConfirmedKindId:= (SELECT zc_Enum_ConfirmedKind_Complete());
           outConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');
       ELSE
           vbConfirmedKindId:= (SELECT zc_Enum_ConfirmedKind_UnComplete());
           outConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');
    END IF;

    -- ��������� �����
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), inMovementId, vbConfirmedKindId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
