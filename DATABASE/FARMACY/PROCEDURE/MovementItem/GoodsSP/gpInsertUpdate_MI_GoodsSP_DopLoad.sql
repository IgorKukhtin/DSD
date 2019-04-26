-- Function: gpInsertUpdate_MI_GoodsSP_From_Excel()
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSP_DopLoad (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSP_DopLoad(
    IN inMovementId          Integer   ,    -- 
    IN inCode                Integer   ,    -- ��� ������� <�����> MainID
    IN inIdSP                TVarChar  ,    --
    IN inDosageIdSP          TVarChar  ,    --
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMainId Integer;
   DECLARE vbMI_Id Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <inName>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;--RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

     -- !!!����� �� �������� ������!!!
     vbMainId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
                 FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                      INNER JOIN Object AS Object_Goods 
                                        ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                       AND Object_Goods.ObjectCode = inCode
                 WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbMainId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� ���� % �� ������� � �����������.', inCode;
     END IF;  

    -- ���� ������ � ����� �������
     vbMI_Id := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = COALESCE (vbMainId, 0)
                 Limit 1 -- �� ������ ������
                );
    
    IF COALESCE (vbMI_Id, 0) <> 0
    THEN
        -- ��������� <>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), vbMI_Id, TRIM (inIdSP));
        -- ��������� <>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DosageIdSP(), vbMI_Id, TRIM (inDosageIdSP));
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.19         *
*/

-- ����