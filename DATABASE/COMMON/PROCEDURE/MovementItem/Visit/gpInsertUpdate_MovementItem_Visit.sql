-- Function: gpInsertUpdate_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Visit (Integer, Integer, TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Visit(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPhotoMobileName     TVarChar  , -- 
    IN inPhotoData           TBlob     , --
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPhotoMobileId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Visit());

    IF COALESCE(ioId,0) <> 0 
    THEN
        --������� ������������ ������� �� ObjectCode = ioId
        vbPhotoMobileId := (SELECT Object_PhotoMobile.Id
                            FROM Object AS Object_PhotoMobile
                            WHERE Object_PhotoMobile.DescId = zc_Object_PhotoMobile()
                              AND Object_PhotoMobile.ObjectCode = ioId); 
    
    ELSE 
        IF COALESCE (inPhotoMobileName,'') <> ''
           THEN
               -- ��������� ����� �������
               vbPhotoMobileId := lpInsertUpdate_Object (0, zc_Object_PhotoMobile(), 0, TRIM (inPhotoMobileName));
           END IF;
    END IF;
	    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_Visit (ioId             := COALESCE(ioId,0)
                                            , inMovementId     := inMovementId
                                            , inPhotoMobileId  := COALESCE(vbPhotoMobileId,0)
                                            , inComment        := inComment
                                            , inUserId         := vbUserId
                                            );

   -- ��������� ������� ����
   PERFORM lpInsertUpdate_Object_PhotoMobile (vbPhotoMobileId, ioId, TRIM (inPhotoMobileName), inPhotoData, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.   ��������� �.�.
 26.03.17         *
*/

-- ����
-- 