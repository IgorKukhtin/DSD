-- Function: gpInsertUpdate_MI_Send_BarCode_PartNumber()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_BarCode_PartNumber(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_BarCode_PartNumber(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBarCode_Goods       TVarChar  , -- 
    IN inBarCode_PartNumber  TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsId Integer;
   DECLARE vbCountForPrice TFloat;
   DECLARE vboperprice   TFloat;
   DECLARE vbAmount     TFloat;
   
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ������ �����
     IF TRIM (inBarCode_Goods) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_Goods) = 13
         THEN -- �� ����� ����, 
              vbGoodsId:= (SELECT Object.Id
                           FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_Goods, 4, 13-4)) AS GoodsId
                                ) AS tmp
                                INNER JOIN Object ON Object.Id = tmp.GoodsId
                                                   AND Object.DescId = zc_Object_Goods()
                                                   AND Object.isErased = FALSE
                          );
         ELSE -- �� ����
              vbGoodsId:= (SELECT Object.Id
                           FROM Object
                           WHERE Object.ObjectCode = inBarCode_Goods::Integer
                             AND Object.DescId = zc_Object_Goods()
                             AND Object.isErased = FALSE
                          );
         END IF;

         -- ��������
         IF COALESCE (vbGoodsId, 0) = 0
         THEN
             --RAISE EXCEPTION '', inBarCode_OrderClient;
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������������� ' || CASE WHEN CHAR_LENGTH (inBarCode_Goods) = 13 THEN '�/�' ELSE '���' END || ' <%>  <S/N> <%> �� ������.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MI_Send_barcode'     :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_Goods      :: TVarChar
                                                   , inParam2        := inBarCode_PartNumber :: TVarChar
                                                   );
         END IF;

 
         -- ������� ����� ����������� ������ �� ������ ������, ���� ���� +1 � ���-��
         SELECT MovementItem.Id
              , MovementItem.Amount
              , MIFloat_OperPrice.ValueData     AS OperPrice
              , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
        INTO ioId, vbAmount, vbOperPrice, vbCountForPrice
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

              LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     =  zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = vbGoodsId
         ;
   
         -- ���� ����� ���������
         IF COALESCE (ioId,0) <> 0
         THEN
             SELECT tmp.ioId
                    INTO ioId 
             FROM lpInsertUpdate_MovementItem_Send (COALESCE (ioId,0)
                                                  , inMovementId
                                                  , vbGoodsId
                                                  , (COALESCE (vbAmount,0) + 1) ::TFloat
                                                  , vbOperPrice
                                                  , vbCountForPrice
                                                  , inBarCode_PartNumber
                                                  , ''::TVarChar
                                                  , vbUserId
                                                  ) AS tmp;
         ELSE
            --����� ����� OperPrice, CountForPrice
            SELECT Object_PartionGoods.EKPrice ::TFloat AS OperPrice
                 , COALESCE (Object_PartionGoods.CountForPrice,1) ::TFloat AS CountForPrice
             INTO vbOperPrice, vbCountForPrice
            FROM Object_PartionGoods
            WHERE Object_PartionGoods.ObjectId = vbGoodsId
            ;
            
             --��������� ������
             SELECT tmp.ioId
                    INTO ioId 
             FROM lpInsertUpdate_MovementItem_Send (COALESCE (ioId,0)
                                                  , inMovementId
                                                  , vbGoodsId
                                                  , (COALESCE (vbAmount,0) + 1) ::TFloat
                                                  , vbOperPrice
                                                  , vbCountForPrice
                                                  , inBarCode_PartNumber
                                                  , ''::TVarChar
                                                  , vbUserId
                                                  ) AS tmp;

         END IF;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
     
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.10.21         *
*/

-- ����
--