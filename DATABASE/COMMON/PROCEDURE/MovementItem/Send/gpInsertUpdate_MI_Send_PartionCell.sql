-- Function: gpInsertUpdate_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������> 
    IN inGoodsId               Integer   , -- 
    IN inGoodsKindId           Integer   , -- 
    IN inAmount                TFloat,
    --IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     ----����� �������� ����� / ��� ������ / ���-��  ������� ���������
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := inId
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := inGoodsId
                                             , inAmount              := inAmount
                                             , inPartionGoodsDate    := tmp.PartionGoodsDate
                                             , inCount               := tmp.Count
                                             , inHeadCount           := tmp.HeadCount
                                             , ioPartionGoods        := tmp.PartionGoods
                                             , ioPartNumber          := tmp.PartNumber
                                             , inGoodsKindId         := inGoodsKindId
                                             , inGoodsKindCompleteId := tmp.GoodsKindId_Complete
                                             , inAssetId             := tmp.AssetId
                                             , inAssetId_two         := tmp.AssetId_two
                                             , inUnitId              := NULL ::Integer
                                             , inStorageId           := tmp.StorageId
                                             , inPartionModelId      := tmp.PartionModelId
                                             , inPartionGoodsId      := tmp.PartionGoodsId
                                             , inUserId              := vbUserId
                                              ) 
     FROM gpSelect_MovementItem_Send (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS tmp
     WHERE tmp.Id = inId; 
  
     --  1  
     IF COALESCE (ioPartionCellName_1, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_1))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --���� �� ����� ������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_1;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId); 
         
         ioPartionCellName_1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId); 
     ELSE 
      --RAISE EXCEPTION '������.555';
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, Null);
     END IF;

     --  2  
     IF COALESCE (ioPartionCellName_2, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --���� �� ����� ������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_12;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, vbPartionCellId);
         
         ioPartionCellName_2 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, Null);
     END IF;


     --  3  
     IF COALESCE (ioPartionCellName_3, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --���� �� ����� ������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_3;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, vbPartionCellId); 
         
         ioPartionCellName_3 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, Null);
     END IF;
     
     --  4  
     IF COALESCE (ioPartionCellName_4, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --���� �� ����� ������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_4;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, vbPartionCellId);
         
         ioPartionCellName_4 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, Null);
     END IF;

     --  5  
     IF COALESCE (ioPartionCellName_5, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName_5) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_5)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --���� �� ����� ������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_5;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, vbPartionCellId);
         
         ioPartionCellName_5 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, Null);
     END IF;



     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.23         *
*/

-- ����
--