-- Function: gpInsertUpdate_Object_ProdOptions_excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptions_excel (TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptions_excel(
    IN inId_site         TVarChar  ,    -- 
    IN inModelCode       TVarChar  ,    -- 
    IN inOptName         TVarChar  ,    -- 
    IN inMaterialOptions TVarChar  ,    -- 
    IN inSalePrice       TFloat    ,
    IN inCodeVergl       TVarChar  ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId                  Integer;
   DECLARE vbModelId             Integer;
   DECLARE vbMaterialOptionsId   Integer;
   DECLARE vbProdColorPatternId  Integer;
BEGIN

     -- Поиск     
     vbModelId:= (SELECT Id FROM Object WHERE DescId = zc_Object_ProdModel() AND ValueData ILIKE inModelCode);
     IF COALESCE (vbModelId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.vbModelId is null <%>', inModelCode;
     END IF;

     -- Поиск     
     vbMaterialOptionsId := (SELECT Id FROM Object WHERE DescId = zc_Object_MaterialOptions() AND ValueData ILIKE inMaterialOptions);
     IF COALESCE (vbMaterialOptionsId, 0) = 0 AND TRIM (inMaterialOptions) <> ''
     THEN
         -- сохранили
         vbMaterialOptionsId:= lpInsertUpdate_Object (vbMaterialOptionsId, zc_Object_MaterialOptions(), lfGet_ObjectCode (0, zc_Object_MaterialOptions()), inMaterialOptions);
     END IF;
     

     -- Поиск - 1
     IF 1 < (SELECT COUNT(*)
             FROM Object AS Object_ProdOptions
                  LEFT JOIN ObjectLink AS ObjectLink_Model
                                       ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                  LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                       ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
             WHERE Object_ProdOptions.DescId                = zc_Object_ProdOptions()
               AND ObjectLink_Model.ChildObjectId           = vbModelId
               AND ObjectLink_MaterialOptions.ChildObjectId = vbMaterialOptionsId
               AND Object_ProdOptions.isErased              = FALSE
               AND Object_ProdOptions.ValueData ILIKE (inOptName || '%')
            )
     THEN
         RAISE EXCEPTION 'Ошибка1.vbModelId = <%> vbMaterialOptionsId = <%> inOptName = <%>'
                       , lfGet_Object_ValueData_sh (vbModelId), lfGet_Object_ValueData_sh (vbMaterialOptionsId), inOptName;
     END IF;
     -- Поиск - 1
     vbId:= (SELECT Object_ProdOptions.Id
             FROM Object AS Object_ProdOptions
                  LEFT JOIN ObjectLink AS ObjectLink_Model
                                       ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                  LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                       ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
             WHERE Object_ProdOptions.DescId                = zc_Object_ProdOptions()
               AND ObjectLink_Model.ChildObjectId           = vbModelId
               AND ObjectLink_MaterialOptions.ChildObjectId = vbMaterialOptionsId
               AND Object_ProdOptions.isErased              = FALSE
               AND Object_ProdOptions.ValueData ILIKE (inOptName || '%')
            );


     -- Поиск - 2
     IF 1 < (SELECT COUNT(*)
             FROM Object AS Object_ProdOptions
                  LEFT JOIN ObjectLink AS ObjectLink_Model
                                       ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                  LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                       ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                      AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
             WHERE Object_ProdOptions.DescId                = zc_Object_ProdOptions()
               AND ObjectLink_Model.ChildObjectId           = vbModelId
               AND COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0) = 0
               AND Object_ProdOptions.isErased              = FALSE
               AND Object_ProdOptions.ValueData ILIKE (inOptName || '%')
            )
     THEN
         RAISE EXCEPTION 'Ошибка2.vbModelId = <%> vbMaterialOptionsId = <%> inOptName = <%>'
                       , lfGet_Object_ValueData_sh (vbModelId), lfGet_Object_ValueData_sh (vbMaterialOptionsId), inOptName;
     END IF;
     -- Поиск - 2
     IF COALESCE (vbId, 0) = 0
     THEN
         vbId:= (SELECT Object_ProdOptions.Id
                 FROM Object AS Object_ProdOptions
                      LEFT JOIN ObjectLink AS ObjectLink_Model
                                           ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                          AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                      LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                           ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                          AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                 WHERE Object_ProdOptions.DescId                = zc_Object_ProdOptions()
                   AND ObjectLink_Model.ChildObjectId           = vbModelId
                   AND COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0) = 0
                   AND Object_ProdOptions.isErased              = FALSE
                   AND Object_ProdOptions.ValueData ILIKE (inOptName || '%')
                );
     END IF;
            
   
     -- Поиск
     vbProdColorPatternId:= (SELECT MAX (CASE WHEN inOptName ILIKE 'Hypalon Primary'   AND gpSelect.ProdColorGroupName ILIKE 'Hypalon' AND  gpSelect.Name ILIKE 'primary'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Hypalon Secondary' AND gpSelect.ProdColorGroupName ILIKE 'Hypalon' AND  gpSelect.Name ILIKE 'secondary'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Upholstery' AND gpSelect.ProdColorGroupName ILIKE 'Upholstery' AND  gpSelect.Name ILIKE 'primary'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Teak' AND gpSelect.ProdColorGroupName ILIKE 'Teak color'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Hull' AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass - Hull'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Deck' AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass - Deck'
                                                   THEN gpSelect.Id
                                              WHEN inOptName ILIKE 'Steering Console' AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass SteeringConsole'
                                                   THEN gpSelect.Id
                                              ELSE 0
                                         END)
                             FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_ColorPattern_Model() AND OL.ChildObjectId = vbModelId)
                                                                  , inIsErased:= 'FALSE', inIsShowAll:= 'FALSE', inSession:= inSession
                                                                   ) AS gpSelect
                            );

     -- сохранили
     vbId:= gpInsertUpdate_Object_ProdOptions (ioId                := vbId
                                             , inCode              := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbId), 0)
                                             , inCodeVergl         := zfConvert_StringToNumber (inCodeVergl)
                                             , inName              := COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbId), inOptName)
                                             , inSalePrice         := inSalePrice
                                             , inComment           := ''
                                             , inId_Site           := inId_site
                                             , inGoodsId           := NULL
                                             , inModelId           := vbModelId
                                             , inTaxKindId         := NULL
                                             , inMaterialOptionsId := vbMaterialOptionsId
                                             , inProdColorPatternId:= vbProdColorPatternId
                                             , inSession           := inSession
                                              );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.12.20         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdOptions_excel()
