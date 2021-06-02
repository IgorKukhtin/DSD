-- Function: gpUpdate_Movement_Sale_isDisableSMS()


DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_isDisableSMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_isDisableSMS(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inisDisableSMS         Boolean   , -- 
   OUT outisDisableSMS        Boolean   , -- 
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     -- ��������������
     outisDisableSMS := Not inisDisableSMS;
     
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DisableSMS(), inId, outisDisableSMS);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.21         *
 */

-- ����