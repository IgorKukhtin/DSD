-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIComDoc (Integer, Integer, Text, TVarChar, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIComDoc (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EDIComDoc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsPropertyId     Integer   , 
    IN inGoodsName           TVarChar  , -- �����
    IN inGLNCode             TVarChar  , -- 
    IN inAmountPartner       TFloat    , -- ���-�� � �����.
    IN inPricePartner        TFloat    , -- ����
    IN inSummPartner         TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbAmountPartner TFloat;
   DECLARE vbSummPartner TFloat;
   DECLARE vbGoodsName   TVarChar;

   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
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
     -- ������������ <���-�� � �����.> �� ��������� EDI, !!!�.�. ����� ���-�� �����������!!!
     vbAmountPartner:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = vbMovementItemId AND DescId = zc_MIFloat_AmountPartner()), 0);
     -- ������������ <�����> �� ��������� EDI
     vbSummPartner:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = vbMovementItemId AND DescId = zc_MIFloat_Summ()), 0);

     -- ������� vbGoodsId � vbGoodsKindId
     SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
            INTO vbGoodsId, vbGoodsKindId
     FROM (SELECT MAX (Id) AS Id FROM Object_GoodsPropertyValue_View WHERE GoodsPropertyId = inGoodsPropertyId AND ArticleGLN <> '' AND ArticleGLN = inGLNCode
           ) AS tmpGoodsPropertyValue
           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = tmpGoodsPropertyValue.Id
                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = tmpGoodsPropertyValue.Id
                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind();


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbGoodsId, inMovementId, vbAmount, NULL);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GLNCode(), vbMovementItemId, inGLNCode);
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), vbMovementItemId, vbGoodsName);

     -- ���-�� � �����. - !!!����� �����������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, COALESCE (inAmountPartner, 0) + COALESCE (vbAmountPartner, 0));
     -- ����
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPricePartner);
     -- ����� - !!!����� �����������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), vbMovementItemId, COALESCE (inSummPartner, 0) + COALESCE (vbSummPartner, 0));

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, vbGoodsKindId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.14                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 19.07.14                                        * add lpInsert_MovementItemProtocol
 29.05.14                         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDIComDoc (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
