-- Function: gpInsertUpdate_MovementItem_SendAsset()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendAsset(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inContainerId           Integer   , -- ������ �� 
    IN inStorageId             Integer   , -- ����� �������� 
    
    IN inPartionModelId        Integer   ,    -- ������ (������)
    IN inInvNumber             TVarChar  ,    -- ����������� �����
    IN inSerialNumber          TVarChar  ,    -- ��������� �����
    IN inPassportNumber        TVarChar  ,    -- ����� ��������  
    IN inProduction            TFloat    ,     -- ������������������, ��
    IN inKW                    TFloat    ,     -- ������������ �������� KW   
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendAsset());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_SendAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inContainerId := inContainerId
                                                  , inStorageId   := inStorageId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;


     -- ��� �������� �� ���������, + �������� ���� � ����������� ��������� ������ , � � ��������� ���, ����� ������ 
     IF EXISTS (SELECT 1 
                FROM ObjectLink 
                WHERE ObjectLink.ObjectId = inGoodsId 
                  AND ObjectLink.DescId = zc_ObjectLink_Asset_PartionModel()
                  AND COALESCE (ObjectLink.ChildObjectId,0) <> 0)
        AND COALESCE (inPartionModelId,0) = 0 
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ����������� ������ (������).', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_InvNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inInvNumber,'') = ''
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ���������� ����������� �����.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_SerialNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inSerialNumber,'') = '' 
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ���������� ��������� �����.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_PassportNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inPassportNumber,'') = ''
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ���������� ����� ��������.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;     
     --
     IF EXISTS (SELECT 1 
                FROM ObjectFloat 
                WHERE ObjectFloat.ObjectId = inGoodsId 
                  AND ObjectFloat.DescId = zc_ObjectFloat_Asset_Production()
                  AND COALESCE (ObjectFloat.ValueData, 0) <> 0)
         AND COALESCE (inProduction,0) = 0 
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ����������� ������������������.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectFloat 
                WHERE ObjectFloat.ObjectId = inGoodsId 
                  AND ObjectFloat.DescId = zc_ObjectFloat_Asset_KW()
                  AND COALESCE (ObjectFloat.ValueData, 0) <> 0)
         AND COALESCE (inKW,0) = 0
     THEN 
          RAISE EXCEPTION '������.��� �� <%> �� ����������� ��������.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
          
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_PartionModel(), inGoodsId, inPartionModelId);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), inGoodsId, inInvNumber);
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_SerialNumber(), inGoodsId, inSerialNumber);
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_PassportNumber(), inGoodsId, inPassportNumber);    
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_Production(), inGoodsId, inProduction);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_KW(), inGoodsId, inKW);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 
 28.06.23         *
 16.03.20         *
*/

-- ����
--