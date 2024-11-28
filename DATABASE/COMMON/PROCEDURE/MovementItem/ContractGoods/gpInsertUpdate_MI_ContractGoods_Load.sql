-- Function: gpInsertUpdate_MI_ContractGoods_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ContractGoods_Load (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ContractGoods_Load(
    IN inMovementId          Integer   , -- ���� �������
    IN inGoodsCode           Integer   , -- ������
    IN inGoodsName           TVarChar  ,
    IN inGoodsKindName       TVarChar  , -- ���� �������
    IN inPrice               TFloat    , -- 
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inChangePercent       TFloat    , -- % ������ 
    IN inCountForAmount      TFloat    , -- ����� �������� �� ���-�� ����������
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbMIId        Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());

     IF inGoodsCode = 0 AND TRIM (inGoodsName) = ''
     THEN
         RETURN;
     END IF;

     -- ����� Id ������
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsName))
                   AND Object.ObjectCode = inGoodsCode
                   AND Object.DescId = zc_Object_Goods()
                 LIMIT 1 --
                );
 
     -- ������� ����� �� ����
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode AND inGoodsCode > 0);

     IF COALESCE (vbGoodsId,0) = 0 AND inGoodsCode > 0
     THEN
        RAISE EXCEPTION '������. ����� <%> �� ���� <%> �� ������.', inGoodsName, inGoodsCode;
     END IF;


     -- ������� ��� ������
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION '������. ��� ������ �� �������� <%> �� ������.', inGoodsKindName;
     END IF;



     --������� ����� ������ ���� ��� �������
     vbMIId := (SELECT MovementItem.Id
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.ObjectId = vbGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE(vbGoodsKindId,0)
                );

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_ContractGoods (ioId            := COALESCE (vbMIId,0) ::Integer
                                                      , inMovementId    := inMovementId
                                                      , inGoodsId       := vbGoodsId
                                                      , inGoodsKindId   := vbGoodsKindId
                                                      , inisBonusNo     := FALSE
                                                      , inPrice         := inPrice
                                                      , inChangePrice   := inChangePrice
                                                      , inChangePercent := inChangePercent
                                                      , inCountForAmount:= inCountForAmount
                                                      , inCountForPrice := 1 ::TFloat
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                       ) ;
                                                       
                                                       
  
     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION '������.ok.';
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.11.24        *
*/

-- ����
--