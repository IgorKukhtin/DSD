-- Function: gpInsertUpdate_MI_Send_PartionCell_edit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell_edit (Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Boolean, Boolean, Boolean, Boolean, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell_edit(
    IN inId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inPartionCell_Last         TFloat    ,
    IN inPartionCell_Amount_1     TFloat   , -- 
    IN inPartionCell_Amount_2     TFloat   ,
    IN inPartionCell_Amount_3     TFloat   ,
    IN inPartionCell_Amount_4     TFloat   ,
    IN inPartionCell_Amount_5     TFloat   ,
    
    IN inisPartionCell_Close_1    Boolean   , -- 
    IN inisPartionCell_Close_2    Boolean   ,
    IN inisPartionCell_Close_3    Boolean   ,
    IN inisPartionCell_Close_4    Boolean   ,
    IN inisPartionCell_Close_5    Boolean   ,
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;
  
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Last(), inId, inPartionCell_Last);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_1(), inId, inPartionCell_Amount_1);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_2(), inId, inPartionCell_Amount_2);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_3(), inId, inPartionCell_Amount_3);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_4(), inId, inPartionCell_Amount_4);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_Amount_5(), inId, inPartionCell_Amount_5);


    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inId, inisPartionCell_Close_2);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inId, inisPartionCell_Close_3);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inId, inisPartionCell_Close_4);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inId, inisPartionCell_Close_5);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.12.23         *
*/

-- ����
--