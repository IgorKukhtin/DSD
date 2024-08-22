-- Function: gpUpdate_Movement_ProductionUnion_Etiketka()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Etiketka (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Etiketka(
    IN inId                    Integer   , -- ���� ������� <��������>
    IN inisEtiketka            Boolean   , --
   OUT outEtiketka             Boolean   , --
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� �������
     outEtiketka := not inisEtiketka;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Etiketka(), inId, outEtiketka);


     IF vbUserId = 9457
     THEN
           RAISE EXCEPTION '����. ��.'; 
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.24          *
*/

-- ����
--  