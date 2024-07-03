-- Function: gpUpdate_MI_Inventory_Scan()

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_Scan (Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_Scan(
    IN inId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inGoodsId                 Integer   , -- ������
    IN inAmount                  TFloat    , -- ����������
    IN inPartNumber              TVarChar  , -- � �� ��� ��������
 INOUT ioPartionCellName         TVarChar  , -- ��� ��� ��������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Inventory());
     vbUserId := lpGetUserBySession (inSession);

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (ioPartionCellName, '') <> '' THEN
         -- !!!����� �� !!!
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', ioPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId      := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (ioPartionCellName)                     ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
         ioPartionCellName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         vbPartionCellId := NULL ::Integer;
     END IF;


     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Scan(), inGoodsId, NULL, inMovementId, inAmount, NULL, vbUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), inId, inPartNumber);
    
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), inId, vbPartionCellId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.07.24         *
*/

-- ����
--