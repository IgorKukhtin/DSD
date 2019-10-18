-- Function: gpUpdate_Goods_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_FromSite (Integer, Integer, TBlob, TVarChar, TVarChar, TBlob, TVarChar, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_FromSite(
    IN inGoodsCode           Integer   ,    -- ���� ������� <�����>
    IN inId                  Integer   ,    -- ���� ������ �� �����
    IN inName                TBlob     ,    -- �������� ������ �� �����
    IN inPhoto               TVarChar  ,    -- ����
    IN inThumb               TVarChar  ,    -- ������
    IN inDescription         TBlob     ,    -- �������� ������ �� �����
    IN inManufacturer        TVarChar  ,    -- �������������
    IN inAppointmentCode     Integer   ,    -- ���������� ���������
    IN inAppointmentName     TVarChar  ,    -- ���������� ���������
    IN inPublished           Boolean   ,    -- �����������
    IN inIsOnly              Boolean   ,    -- ��������� ������ 2 � 3 ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbId Integer;
  DECLARE vbCount Integer;
  DECLARE vbApoitmentId Integer;
  DECLARE text_var1 text;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- �����
    SELECT MAX (Id), COUNT (*)
           INTO vbId, vbCount
    FROM Object_Goods_View
    WHERE ObjectId = lpGet_DefaultValue ('zc_Object_Retail', vbUserId) :: Integer AND GoodsCodeInt = inGoodsCode;

    
    -- ��������
    IF COALESCE (vbId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� � ����� <%> �� ������.', inGoodsCode;
    END IF;
    -- ��������
    IF vbCount > 1
    THEN
        RAISE EXCEPTION '������.������� � ����� <%> ������ ��� 1.', inGoodsCode;
    END IF;


    -- ���� �����
    IF vbId <> 0
    THEN
        -- ��������� �������� <���� ������ �� �����>
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Site(), vbId, inId);

        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Foto(), vbId, inPhoto);
        -- ��������� �������� <������>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Thumb(), vbId, inThumb);
        -- ��������� �������� <�����������>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), vbId, inPublished);

          -- ��������� � ������� �������
        BEGIN
          UPDATE Object_Goods_Main SET SiteId = inId
                                     , Foto = inPhoto
                                     , Thumb = inThumb
                                     , isPublished = inPublished
          WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
        END;

        IF COALESCE (inIsOnly, FALSE) = FALSE -- ��������� ������ 2 � 3 ��������
        THEN
          -- ��������� �������� <�������� �� �����>
          PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_Goods_Site(), vbId, inName);

          -- ��������� �������� <�������� �� �����>
          PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_Goods_Description(), vbId, inDescription);
          -- ��������� �������� <�������������>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), vbId, inManufacturer);


            -- ��������� � ������� �������
          BEGIN
            UPDATE Object_Goods_Main SET MakerName = inManufacturer
            WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  

            UPDATE Object_Goods_Blob SET Description = inDescription
                                       , NameSite    = inName
            WHERE Object_Goods_Blob.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
          EXCEPTION
             WHEN others THEN 
               GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
               PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
          END;
        END IF;
        
    END IF;

    -- ��� ����������� ����
    IF inAppointmentCode <> 0
    THEN
        -- ����� �� ����
        vbApoitmentId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Appointment() AND ObjectCode = inAppointmentCode);
        -- ��������/�������� - ������
        vbApoitmentId:= lpInsertUpdate_Object (vbApoitmentId, zc_Object_Appointment(), inAppointmentCode, inAppointmentName);

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (vbApoitmentId, vbUserId);

        -- ���� �����
        IF vbId <> 0
        THEN
          -- ��������� �������� <Apoitment>
          PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Appointment(), vbId, vbApoitmentId);

            -- ��������� � ������� �������
          BEGIN
            UPDATE Object_Goods_Main SET AppointmentId = vbApoitmentId
            WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = vbId);  
          EXCEPTION
             WHEN others THEN 
               GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
               PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NotTransferTime', text_var1::TVarChar, vbUserId);
          END;
        END IF;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 17.10.19                                                                      *    
 06.04.16                                        * ALL
 11.11.15                                                          *
*/
