-- Function: gpInsertUpdate_Object_GoodsSP_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                                  TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                                  TFloat, TFloat, TFloat, TFloat, TFloat, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                                  TFloat, TFloat, TFloat, TFloat, TFloat, TBlob,
                                                                  TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,
                                                                  TVarChar);
                                                                  
                                                                  
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Sticker_From_Excel(
    IN inCode                Integer   , -- ��� ������� <�����>
    IN inStickerGroupName    TVarChar  , -- 
    IN inStickerTypeName     TVarChar  , -- 
    IN inStickerTagName      TVarChar  , -- 
    IN inStickerSortName     TVarChar  , -- 
    IN inStickerNormName     TVarChar  , -- 
    IN inValue1              TFloat    , -- �������� ����
    IN inValue2              TFloat    , -- �������� ����
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inInfo                TBlob     , --
--StickerProperty
    IN inStickerSkinName     TVarChar  , -- 
    IN inStickerPackName     TVarChar  , -- 
    IN inBarCode             TVarChar  , --
    IN inValue1_pr           TFloat    , -- 
    IN inValue2_pr           TFloat    , -- 
    IN inValue3_pr           TFloat    , --
    IN inValue4_pr           TFloat    , --
    IN inValue5_pr           TFloat    , --
    IN inValue6_pr           TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbStickerId Integer;
   DECLARE vbStickerPropertyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;      --RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

     -- !!!����� �� �������� ������!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inCode
                    AND Object_Goods.DescId = zc_Object_Goods()
                 );

     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� ���� % �� ������� � �����������.', inCode;
     END IF;  
   
     vbStickerId := (SELECT ObjectLink_Sticker_Goods.ObjectId
                     FROM ObjectLink AS ObjectLink_Sticker_Goods
                          LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                               ON ObjectLink_Sticker_StickerGroup.ObjectId = ObjectLink_Sticker_Goods.ObjectId
                                              AND ObjectLink_Sticker_StickerGroup.DescId = zc_ObjectLink_Sticker_StickerGroup()
                          INNER JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId
                                                                  AND UPPER (TRIM(Object_StickerGroup.ValueData)) = UPPER (TRIM(inStickerGroupName))
             
                          LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                               ON ObjectLink_Sticker_StickerType.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                              AND ObjectLink_Sticker_StickerType.DescId = zc_ObjectLink_Sticker_StickerType()
                          INNER JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId
                                                                 AND UPPER (TRIM(Object_StickerType.ValueData)) = UPPER (TRIM(inStickerTypeName))
             
                          LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                               ON ObjectLink_Sticker_StickerTag.ObjectId = ObjectLink_Sticker_Goods.ObjectId
                                              AND ObjectLink_Sticker_StickerTag.DescId = zc_ObjectLink_Sticker_StickerTag()
                          INNER JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId
                                                                AND UPPER (TRIM(Object_StickerTag.ValueData)) = UPPER (TRIM(inStickerTagName))
             
                          LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                               ON ObjectLink_Sticker_StickerSort.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                              AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
                          INNER JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId
                                                                 AND UPPER (TRIM(Object_StickerSort.ValueData)) = UPPER (TRIM(inStickerSortName))
             
                          LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                               ON ObjectLink_Sticker_StickerNorm.ObjectId = ObjectLink_Sticker_Goods.ObjectId 
                                              AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
                          INNER JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId
                                                                 AND UPPER (TRIM(Object_StickerNorm.ValueData)) = UPPER (TRIM(inStickerNormName))
             
                     WHERE ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
                       AND ObjectLink_Sticker_Goods.ChildObjectId = vbGoodsId
                     );
              
     IF COALESCE (vbStickerId, 0) = 0 THEN
        -- ���������� ����� ��������
        vbStickerId := gpInsertUpdate_Object_Sticker(ioId                  := 0                   ::Integer
                                                   , inCode                := lfGet_ObjectCode (0, zc_Object_Sticker())  ::Integer
                                                   , inComment             := ''                  ::TVarChar
                                                   , inJuridicalId         := 0                   ::Integer
                                                   , inGoodsId             := vbGoodsId           ::Integer
                                                   , inStickerFileId       := 0                   ::Integer
                                                   , inStickerGroupName    := inStickerGroupName  ::TVarChar
                                                   , inStickerTypeName     := inStickerTypeName   ::TVarChar
                                                   , inStickerTagName      := inStickerTagName    ::TVarChar
                                                   , inStickerSortName     := inStickerSortName   ::TVarChar
                                                   , inStickerNormName     := inStickerNormName   ::TVarChar
                                                   , inInfo                := inInfo              ::TBlob
                                                   , inValue1              := inValue1            ::TFloat
                                                   , inValue2              := inValue2            ::TFloat
                                                   , inValue3              := inValue3            ::TFloat
                                                   , inValue4              := inValue4            ::TFloat
                                                   , inValue5              := inValue5            ::TFloat
                                                   , inSession             := inSession 
                                                     );
     END IF; 
              
     --������� ����� ��������
     vbStickerPropertyId := (SELECT ObjectLink_StickerProperty_Sticker.ObjectId
                             FROM ObjectLink AS ObjectLink_StickerProperty_Sticker
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                                       ON ObjectLink_StickerProperty_StickerPack.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId
                                                      AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
                                  INNER JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId
                                                                         AND UPPER (TRIM(Object_StickerPack.ValueData)) = UPPER (TRIM(inStickerPackName))
                     
                                  LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                                       ON ObjectLink_StickerProperty_StickerSkin.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId
                                                      AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
                                  INNER JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId
                                                                      AND UPPER (TRIM(Object_StickerSkin.ValueData)) = UPPER (TRIM(inStickerSkinName))
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value1
                                                         ON ObjectFloat_Value1.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()
                                                        AND COALESCE (ObjectFloat_Value1.ValueData, 0) = inValue1_pr
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value2
                                                         ON ObjectFloat_Value2.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()
                                                        AND COALESCE (ObjectFloat_Value2.ValueData, 0) = inValue2_pr
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value3
                                                         ON ObjectFloat_Value3.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()
                                                        AND COALESCE (ObjectFloat_Value3.ValueData, 0) = inValue3_pr
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value4
                                                         ON ObjectFloat_Value4.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()
                                                        AND COALESCE (ObjectFloat_Value4.ValueData, 0) = inValue4_pr
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value5
                                                         ON ObjectFloat_Value5.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                                        AND COALESCE (ObjectFloat_Value5.ValueData, 0) = inValue5_pr
                     
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value6
                                                         ON ObjectFloat_Value6.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                        AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()
                                                        AND COALESCE (ObjectFloat_Value6.ValueData, 0) = inValue6_pr
                     
                                  INNER JOIN ObjectString AS ObjectString_BarCode
                                                          ON ObjectString_BarCode.ObjectId = ObjectLink_StickerProperty_Sticker.ObjectId 
                                                         AND ObjectString_BarCode.DescId = zc_ObjectString_StickerProperty_BarCode()
                                                         AND TRIM (COALESCE (ObjectString_BarCode.ValueData, '')) = TRIM (inBarCode)
                        
                             WHERE ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
                               AND ObjectLink_StickerProperty_Sticker.ChildObjectId = vbStickerId);
                               
     IF COALESCE (vbStickerPropertyId, 0) = 0 THEN
        -- ���������� ����� �������� ��������
        vbStickerId := gpInsertUpdate_Object_StickerProperty(ioId                := 0                 ::Integer
                                                           , inCode              := lfGet_ObjectCode (0, zc_Object_StickerProperty())  ::Integer
                                                           , inComment           := ''                ::TVarChar
                                                           , inStickerId         := vbStickerId       ::Integer 
                                                           , inGoodsKindId       := 0                 ::Integer 
                                                           , inStickerFileId     := 0                 ::Integer 
                                                           , inStickerSkinName   := inStickerSkinName ::TVarChar
                                                           , inStickerPackName   := inStickerPackName ::TVarChar
                                                           , inBarCode           := inBarCode         ::TVarChar
                                                           , inFix               := FALSE             ::Boolean 
                                                           , inValue1            := inValue1_pr       ::TFloat  
                                                           , inValue2            := inValue2_pr       ::TFloat  
                                                           , inValue3            := inValue3_pr       ::TFloat  
                                                           , inValue4            := inValue4_pr       ::TFloat  
                                                           , inValue5            := inValue5_pr       ::TFloat  
                                                           , inValue6            := inValue6_pr       ::TFloat  
                                                           , inValue7            := 0                 ::TFloat  
                                                           , inSession           := inSession
                                                           );
                                                             
     END IF;                                                                     

                                   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.10.17         *
*/

-- ����
-- 