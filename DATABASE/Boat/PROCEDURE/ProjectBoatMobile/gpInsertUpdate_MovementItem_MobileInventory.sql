-- Function: gpInsertUpdate_MovementItem_MobileInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileInventory (Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileInventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inGoodsId                            Integer   , -- ������
    IN inAmount                             TFloat    , -- ����������
    IN inPartNumber                         TVarChar  , --
    IN inPartionCellName                    TVarChar  , -- ��� ��� ��������
    IN inSession                            TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;

   DECLARE vbMovementId_OrderClient Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrice     TFloat;
   DECLARE vbComment   TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
     INTO vbStatusId, vbInvNumber
     FROM Movement
     WHERE Movement.Id = inMovementId;

     IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) <> zc_Enum_Status_UnComplete()
     THEN
       RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- ���� ����� ��� ���� ����� ����� ��������
     IF EXISTS(SELECT MI.Id
               FROM MovementItem AS MI
                    LEFT JOIN MovementItemString AS MIString_PartNumber
                                                 ON MIString_PartNumber.MovementItemId = MI.Id
                                                AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
               WHERE MI.MovementId = inMovementId
                 AND MI.DescId     = zc_MI_Master()
                 AND MI.ObjectId   = inGoodsId
                 AND MI.isErased   = FALSE
                 AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
     THEN
       RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ��������������.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
     END IF;


     -- ���� �������� S/N �� ����� ������ 1 �� � ���.
     IF COALESCE (inPartNumber, '') <> ''
     THEN

       IF COALESCE (inAmount, 0) <> 1
       THEN
         RAISE EXCEPTION '������. ���������� �������������� <%> � S/N <%> ������ ���� 1.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;

       IF EXISTS(SELECT MI.Id
                 FROM MovementItem AS MI
                      LEFT JOIN MovementItemString AS MIString_PartNumber
                                                   ON MIString_PartNumber.MovementItemId = MI.Id
                                                  AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Scan()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND MI.Id <> COALESCE (ioId, 0)
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
       THEN
         RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ��������������.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;
     END IF;

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (inPartionCellName, '') <> '' THEN
         -- !!!����� �� !!!
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (inPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', inPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (inPartionCellName)                          ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Scan(), inGoodsId, NULL, inMovementId, inAmount, NULL, vbUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, vbPartionCellId);

     -- ��������� �������� <����>
     vbPrice:= (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inGoodsId, vbUserId) AS lpGet);
     --
     IF COALESCE (vbPrice, 0) = 0
     THEN
         vbPrice:= (SELECT ObjectFloat_EKPrice.ValueData FROM ObjectFloat AS ObjectFloat_EKPrice WHERE ObjectFloat_EKPrice.ObjectId = inGoodsId AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice());
     END IF;
     --
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE (vbPrice, 0));

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.03.24                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileInventory(ioId := 0, inMovementId := 3179 , inGoodsId := 261920, inAmount := 1, inPartNumber := '', inPartionCellName := '', inSession := zfCalc_UserAdmin())
