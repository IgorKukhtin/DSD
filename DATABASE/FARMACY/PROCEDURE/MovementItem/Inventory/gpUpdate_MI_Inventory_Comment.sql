-- Function: gpUpdate_MI_Inventory_Comment)

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_Comment(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_Comment(
    IN inId                  Integer  , -- ������
    IN inComment             TVarChar , -- ����������
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '������ �������� �� �������.';
    END IF;

    SELECT Movement.StatusId
    INTO vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ���������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� �������� <����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/

-- ����
--