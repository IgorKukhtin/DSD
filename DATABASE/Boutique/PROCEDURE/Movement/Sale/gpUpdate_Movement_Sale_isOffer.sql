-- Function: gpUpdate_Movement_Sale_isOffer()


DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_isOffer (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_isOffer(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inisOffer              Boolean   , -- ��������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     -- ��������������
     inisOffer := Not inisOffer;
     
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Offer(), inId, inisOffer);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.05.17         *
 */

-- ����