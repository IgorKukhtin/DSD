-- Function: gpInsertUpdate_MI_Inventory_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Inventory_PartionCell(
    IN inId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
 INOUT ioPartionCellName_1       TVarChar   , -- 
    IN inisPartionCell_Close_1   Boolean    ,
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
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, Null);
     END IF;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);



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