-- Function: gpInsert_EDIFiles()
                             
DROP FUNCTION IF EXISTS gpUpdate_IsMedoc_False (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc_False(
   OUT onisMedoc             Boolean   , -- �� �����
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar     -- ������������
)                              
RETURNS Boolean AS --VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpGetUserBySession(inSession);

   vbDescId := (select DescId from Movement where Id = inMovementId);
   IF  vbDescId = zc_Movement_Tax()
   THEN
       vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_IsMedoc());
   ELSE
   IF  vbDescId = zc_Movement_TaxCorrective()
   THEN
       vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_IsMedoc());
   ELSE
       RAISE EXCEPTION '������.��� �������� ��� ����';
   END IF;
   END IF;

   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Medoc(), inMovementId, FALSE);
   
   onIsMedoc := False;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.15         *

*/

-- ����
-- SELECT * FROM gpUpdate_IsMedoc_False (ioId:= 0, inSession:= '2')
