-- Function: gpUpdate_MI_SendPartionDate_ExpirationDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_SendPartionDate_ExpirationDate (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SendPartionDate_ExpirationDate(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inExpirationDate        TDateTime ,
    IN inExpirationDate_in     TDateTime ,
   OUT outisExpirationDateDiff Boolean   ,
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    IF COALESCE (inId,0) = 0
    THEN
        --
        
        RETURN;
    END IF;

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), inId, inExpirationDate);
    
    outisExpirationDateDiff := CASE WHEN inExpirationDate <> inExpirationDate_in THEN TRUE ELSE FALSE END;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.19         *
*/