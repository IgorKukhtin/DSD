-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIOrder(
    IN inOrderInvNumber      TVarChar  , -- ����� ���������
    IN inOrderOperDate       TDateTime , -- ���� ���������

    IN inGLN                 TVarChar   , -- 
    IN inGLNPlace            TVarChar   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer) -- ������������� �������) 
AS
$BODY$
   DECLARE vbMovementId INTEGER;
   DECLARE vbUserId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     vbMovementId := null;

     SELECT Id INTO vbMovementId 
       FROM Movement WHERE DescId = zc_Movement_EDI() 
        AND OperDate = inOrderOperDate 
        AND InvNumber = inOrderInvNumber;

     -- ��������� <��������>
     IF COALESCE(vbMovementId, 0) = 0 THEN
        vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     IF inGLN <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), vbMovementId, inGLN);
     END IF;

     IF inGLNPlace <> '' THEN 
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);
        -- �������� ���������� ����� � ������ ��������
        vbPartnerId := COALESCE((SELECT MIN(ObjectId)
                    FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inGLNPlace), 0);
        IF vbPartnerId <> 0 THEN
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);
        END IF;
     END IF;


     IF vbPartnerId <> 0 THEN -- ������� �� ���� �� �����������
        vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
     END IF;

     IF COALESCE(vbJuridicalId, 0) <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);
        -- ���������� ������ �� ������������� �������
        vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
     END IF;

     PERFORM lpInsert_Movement_EDIEvents(vbMovementId, '�������� ORDER �� EDI', vbUserId);

     RETURN QUERY 
     SELECT vbMovementId, vbGoodsPropertyID;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.14                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
