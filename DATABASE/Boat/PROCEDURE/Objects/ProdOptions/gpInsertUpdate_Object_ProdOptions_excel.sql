-- Function: gpInsertUpdate_Object_ProdOptions_excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions_excel(Integer, Integer, TVarChar, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptions_excel(
    IN inId_site         TVarChar  ,    -- 
    IN inModelCode       TVarChar  ,    -- 
    IN inOptName         TVarChar  ,    -- 
    IN inMaterialOptions TVarChar  ,    -- 
    IN inSalePrice       TFloat    ,
    IN inComment         TVarChar  ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbId      Integer;
   DECLARE vbModelId Integer;
BEGIN

     -- �����     
     vbModelId:= (SELECT Id FROM Object WHERE DescId = zc_Object_ProdModel() AND ValueData ILIKE inModelCode);
     IF COALESCE (vbModelId, 0) = 0
     THEN
         RAISE EXCEPTION '������.vbModelId is null <%>', inModelCode;
     END IF;

     -- �����     
     vbMaterialOptionsId := (SELECT Id FROM Object WHERE DescId = zc_Object_MaterialOptions() AND ValueData ILIKE inMaterialOptions);
     IF COALESCE (vbMaterialOptionsId, 0) = 0
     THEN
         -- ���������
         vbMaterialOptionsId:= lpInsertUpdate_Object (vbMaterialOptionsId, zc_Object_MaterialOptions(), lfGet_ObjectCode (inCode, zc_Object_MaterialOptions()), inMaterialOptions);
     END IF;


     vbId:= (SELECT Object_ProdOptions.Id
             FROM Object AS Object_ProdOptions
                  LEFT JOIN ObjectLink AS ObjectLink_Model
                                       ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                  LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                       ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
             WHERE Object_ProdOptions.DescId = zc_Object_ProdOptions()
               AND ObjectLink_Model.ChildObjectId = vbModelId
             --AND ObjectLink_MaterialOptions.ChildObjectId     = vbMaterialOptionsId
               AND Object_ProdOptions.isErased = FALSE
               AND inOptName ILIKE Object_ProdOptions.ValueData
            );
            
   
     vbId:= gpInsertUpdate_Object_ProdOptions (ioId           := vbId
                                             , inCode         := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbId), 0)
                                             , inName         := COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbId), inOptName)
                                             , inSalePrice    := inSalePrice
                                             , inComment      := ''
                                             , inGoodsId      := NULL
                                             , inModelId      := vbModelId
                                             , inTaxKindId    := NULL
                                             , inSession      := inSession
                                              );

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_TaxKind(), vbId, vbMaterialOptionsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.12.20         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdOptions_excel()
