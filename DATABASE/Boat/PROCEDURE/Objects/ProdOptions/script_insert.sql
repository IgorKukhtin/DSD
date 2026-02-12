-- 11 
 select  /*gpInsertUpdate_Object_ProdOptions(ioId := 0  :: Integer, inCode := code , inCodeVergl := 0 :: Integer , inName := name 
, inSalePrice := SalePrice 
, inAmount := 0 :: TFloat , inComment := '' :: TVarChar , inId_Site := zfCalc_Text_replace_2 (Id_Site, 'b280', 'b280e')  :: TVarChar
, inGoodsId := GoodsId , inModelId := 269791  :: Integer, 
  inTaxKindId := 0 :: Integer, inMaterialOptionsId := MaterialOptionsId , inProdColorPatternId := ProdColorPatternId , 
inPriceListId := 2773  :: Integer, inOperDate := ('01.01.2020')::TDateTime , inis—hangePrice := True ,  inSession := '5' :: TVarChar)

*/
, Id_Site

from 
(select * from gpSelect_Object_ProdOptions(inModelId := 1876 , inPriceListId := 2773 , inLanguageId1 := 0 , inLanguageId2 := 0 , inLanguageId3 := 0 , inLanguageId4 := 0 , inIsErased := 'False' ,  inSession := '5')
where name not ilike 'hypalon%'
 and Id_Site <> 'b280_u_0'
order by code
)
as a






select    
 lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptions_ProdColorPattern(), Id, 559680 ) ,
 *
 from gpSelect_Object_ProdOptions(inModelId := 269791 , inPriceListId := 2773 , inLanguageId1 := 0 , inLanguageId2 := 0 , inLanguageId3 := 0 , inLanguageId4 := 0 , inIsErased := 'False' ,  inSession := '5')
where name  ilike 'Upholstery%'
order by code


