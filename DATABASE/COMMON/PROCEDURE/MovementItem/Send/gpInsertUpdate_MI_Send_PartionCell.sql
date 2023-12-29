-- Function: gpInsertUpdate_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
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

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     --  1  
     IF COALESCE (ioPartionCellName_1, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_1))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_1;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId);
     END IF;

     --  2  
     IF COALESCE (ioPartionCellName_2, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_2;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, vbPartionCellId);
     END IF;


     --  3  
     IF COALESCE (ioPartionCellName_3, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_3;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, vbPartionCellId);
     END IF;

     --  4  
     IF COALESCE (ioPartionCellName_4, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_4;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, vbPartionCellId);
     END IF;

     --  5  
     IF COALESCE (ioPartionCellName_5, '') <> '' THEN
         -- !!!����� �� ������!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --���� ���� ������ �� ������, ���� ��� ����� �������� ����� �������
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� ������ <%>.', ioPartionCellName_5;
         END IF;

         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, vbPartionCellId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
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