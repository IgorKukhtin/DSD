-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIINVOICE_NP (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EDIINVOICE_NP(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsPropertyId     Integer   , 
    IN inLineNumber          Integer   , -- 
    IN inEAN                 TVarChar  , -- 
    IN inGLNCode             TVarChar  , -- ��� ����� � �����.
    IN inGoodsName           TVarChar  , -- �����
    IN inAmountPartner       TFloat    , -- ���-�� � �����.
    IN inPricePartner        TFloat    , -- ����
    IN inSummPartner         TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbGoodsId        Integer;
   DECLARE vbGoodsKindId    Integer;
   DECLARE vbAmount         TFloat;
   DECLARE vbAmountPartner  TFloat;
   DECLARE vbSummPartner    TFloat;
   DECLARE vbGoodsName      TVarChar;

   DECLARE vbIsInsert       Boolean;
   DECLARE vbUserId         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_EDIComDoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������
     inGLNCode:= TRIM (inGLNCode);
     
     vbGoodsName:= TRIM (inGoodsName) :: TVarChar;

     -- ����� �������� ��������� EDI
     vbMovementItemId:= (SELECT MAX (MovementItem.Id)
                         FROM MovementItemString 
                              INNER JOIN MovementItem ON MovementItem.Id = MovementItemString.MovementItemId 
                                                     AND MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId = zc_MI_Master() 
                         WHERE MovementItemString.ValueData = inGLNCode
                           AND MovementItemString.DescId = zc_MIString_GLNCode());
                           
     -- ������������ <���������� �� ������> �� ��������� EDI
     vbAmount:= COALESCE ((SELECT Amount FROM MovementItem WHERE Id = vbMovementItemId), 0);
     -- ������������ <���-�� � �����.> �� ��������� EDI
     vbAmountPartner:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = vbMovementItemId AND DescId = zc_MIFloat_AmountPartner()), 0);
     -- ������������ <�����> �� ��������� EDI
     vbSummPartner:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = vbMovementItemId AND DescId = zc_MIFloat_Summ()), 0);

     -- ������� vbGoodsId � vbGoodsKindId
     SELECT MovementItem.ObjectId
          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId
     INTO vbGoodsId, vbGoodsKindId
     FROM MovementItemString 
          INNER JOIN MovementItem ON MovementItem.Id = MovementItemString.MovementItemId 
                                 AND MovementItem.DescId = zc_MI_Master() 
                                 AND COALESCE(MovementItem.ObjectId) <> 0
          INNER JOIN Movement ON Movement.DescId = zc_Movement_EDI()
                             AND Movement.Id = MovementItem.MovementId
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
     WHERE MovementItemString.ValueData = inGLNCode
       AND MovementItemString.DescId = zc_MIString_GLNCode()
     ORDER BY MovementItem.Id DESC
     LIMIT 1;
               
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
     
     IF vbIsInsert = TRUE OR vbAmountPartner <> inAmountPartner OR vbSummPartner <> inSummPartner OR 
        COALESCE(vbGoodsId, 0) <> COALESCE ((SELECT ObjectId FROM MovementItem WHERE Id = vbMovementItemId), 0)
     THEN
       -- ���������� �� ���-�� � �����.
       vbAmount := inAmountPartner;

       -- ��������� <������� ���������>
       vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbGoodsId, inMovementId, vbAmount, NULL);

       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GLNCode(), vbMovementItemId, inGLNCode);
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), vbMovementItemId, vbGoodsName);

       -- ���-�� � �����.
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, inAmountPartner);
       -- ����
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPricePartner);
       -- ����� 
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), vbMovementItemId, inSummPartner);

       -- ��������� ����� � <���� �������>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, vbGoodsKindId);

       -- ����������� �������� ����� �� ���������
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

       -- ��������� ��������
       PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.06.24                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDIINVOICE_NP (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')