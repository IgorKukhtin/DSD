-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId                Integer   , -- �������������
    IN inAmount                 TFloat    , -- ���������� ������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId
                                                 , inParentId
                                                 , inMovementId
                                                 , inObjectId
                                                 , inAmount
                                                 , vbUserId
                                                 ) AS tmp;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.21         *
*/

-- ����
--