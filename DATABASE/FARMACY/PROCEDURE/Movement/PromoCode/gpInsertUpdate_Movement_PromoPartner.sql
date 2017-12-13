-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartner(
 INOUT ioId                    Integer    , -- ���� ������� <��������>
    IN inParentId              Integer    , -- ������ �������� ����������
    IN inJuridicalId           Integer    , -- ���������
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbOperdate  Tdatetime;
   DECLARE vbInvnumber Tvarchar;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
       
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    SELECT Movement.Operdate
         , Movement.Invnumber
         INTO vbOperdate, vbInvnumber
    FROM Movement
    WHERE Movement.Id = inParentId;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoPartner(), vbInvnumber, vbOperdate, inParentId);
    
    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 12.10.17         *
*/