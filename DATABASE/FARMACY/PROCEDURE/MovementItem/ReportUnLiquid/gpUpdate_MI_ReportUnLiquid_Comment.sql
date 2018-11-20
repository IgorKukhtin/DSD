-- Function: gpInsertUpdate_MI_ReportUnLiquid_Comment)

DROP FUNCTION IF EXISTS gpUpdate_MI_ReportUnLiquid_Comment(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReportUnLiquid_Comment(
    IN inId                  Integer  , -- ���� ������ ������
    IN inComment             TVarChar , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ReportUnLiquid());
     vbUserId := inSession;

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