-- Function: gpUpdate_Movement_OrderClient_Info()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_Info(Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_Info(
    IN inId                  Integer   , -- ���� ������� <>
    IN inCodeInfo            Integer   , -- ��� ����������
    IN inText_Info           TBlob     , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);
    
    IF COALESCE (inCodeInfo,0) = 0    -- �������� ����� ����������
    THEN
        -- ��������� ������� ����� ��� ���� , ����� ���� �� �� ������ 3 (3 �����)
        vbCode := COALESCE ( (SELECT MAX (tmp.CodeInfo) FROM gpSelect_Movement_OrderClient_Info (inMovementId:= inId, inSession:= inSession) AS tmp), 0) ;
        --
        IF vbCode >= 3   -- �� ������ ������ 
        THEN
            -- ������
            RAISE EXCEPTION '������. 3 ��������� ���������� ���������.';
           -- RETURN;
        END IF;
        inCodeInfo := vbCode + 1;
    ENd IF;

    --��������
        IF inCodeInfo = 1
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info1(), inId, inText_Info);
        ENd IF;
        IF inCodeInfo = 2
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info2(), inId, inText_Info);
        ENd IF;
        IF inCodeInfo = 3
        THEN
            PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Info3(), inId, inText_Info);
        ENd IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.21         *
*/

-- ����
--