-- Function: gpInsertUpdate_MI_Inventory_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Inventory_PartionCell(
    IN inId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
 INOUT ioPartionCellName_1       TVarChar   , --
    IN inisPartionCell_Close_1   Boolean    ,
    IN inPartionGoodsDate        TDateTime , -- ���� ������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;


     --  1
     IF COALESCE (ioPartionCellName_1, '') <> '' AND TRIM (ioPartionCellName_1) <> '0'
     THEN
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
                                WHERE Object.ValueData ILIKE TRIM (ioPartionCellName_1)
                                  AND Object.DescId    = zc_Object_PartionCell()
                               );
         END IF;

         -- ���� �� �����
         IF COALESCE (vbPartionCellId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ � % = <%>.'
                           , CASE WHEN zfConvert_StringToNumber (ioPartionCellName_1) > 0 THEN '����� =' ELSE '��������� =' END
                           , ioPartionCellName_1
                            ;
         END IF;

         -- ��������� ����� � <������ ��������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId);

         --
         ioPartionCellName_1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- �������� ����� � <������ ��������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, NULL);
         --
         ioPartionCellName_1:= '';
     END IF;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ��������� �������� <���� ������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.24         *
*/

-- ����
--