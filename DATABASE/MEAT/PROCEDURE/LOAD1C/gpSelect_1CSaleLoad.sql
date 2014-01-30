-- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId TVarChar, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TVarChar, ClientCode TVarChar, ClientName TVarChar, 
               GoodsCode TVarChar, GoodsName TVarChar, OperCount TVarChar, OperPrice TVarChar,
               Tax TVarChar, Doc1Date TVarChar, Doc1Number TVarChar, Doc2Date TVarChar, Doc2Number TVarChar,
               Suma TVarChar, PDV TVarChar, SumaPDV TVarChar, ClientINN TVarChar, ClientOKPO TVarChar,
               InvNalog TVarChar, BillId TVarChar, EkspCode TVarChar, ExpName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());

   -- Результат
   RETURN QUERY 
   SELECT   
      Sale1C.Id          ,
      Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
      Sale1C.ClientName  ,   
      Sale1C.GoodsCode   ,   
      Sale1C.GoodsName   ,   
      Sale1C.OperCount   ,
      Sale1C.OperPrice   ,
      Sale1C.Tax         ,
      Sale1C.Doc1Date    ,
      Sale1C.Doc1Number  ,
      Sale1C.Doc2Date    ,
      Sale1C.Doc2Number  ,
      Sale1C.Suma        ,
      Sale1C.PDV         ,
      Sale1C.SumaPDV     ,
      Sale1C.ClientINN   ,
      Sale1C.ClientOKPO  ,
      Sale1C.InvNalog    ,
      Sale1C.BillId      ,
      Sale1C.EkspCode    ,
      Sale1C.ExpName     

   FROM Sale1C;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoad(TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.13                                        * add vbAccessKeyAll
*/

-- тест
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())