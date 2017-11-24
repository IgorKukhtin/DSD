-- Function: gpUpdate_Movement_EDI_Params()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Params (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Params(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inContractId          Integer   , -- 
    IN inUnitId              Integer   , -- 
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� ���������� ����� � ������ ��������
     vbPartnerId:= (SELECT MIN (ObjectString.ObjectId)
                    FROM MovementString AS MovementString_GLNPlaceCode
                         INNER JOIN ObjectString ON ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = MovementString_GLNPlaceCode.ValueData
                    WHERE MovementString_GLNPlaceCode.MovementId =  inMovementId
                      AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                   );
     IF vbPartnerId <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inMovementId, vbPartnerId);
        --
        vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
        IF COALESCE (vbJuridicalId, 0) <> 0 THEN
           -- ��������� <�� ����>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inMovementId, vbJuridicalId);

           -- ��������� <����>
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), inMovementId, (SELECT OKPO FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = vbJuridicalId));

         END IF;
     END IF;


     -- ���������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);
     -- ���������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), inMovementId, inUnitId);


     -- �������� <������������� �������> + ��������� �������� !!!�� ����� ���� ������ �������� GoodsId and GoodsKindId!!!
     PERFORM lpUpdate_MI_EDI_Params (inMovementId  := inMovementId
                                   , inContractId  := inContractId
                                   , inJuridicalId := (SELECT MLO_Juridical.ObjectId FROM MovementLinkObject AS MLO_Juridical WHERE MLO_Juridical.MovementId = inMovementId AND MLO_Juridical.DescId = zc_MovementLinkObject_Juridical())
                                   , inUserId      := vbUserId
                                    );

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.14                                        * 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_EDI_Params (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
